import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

int _buttonNodes(WidgetTester tester) => find.semantics
    .byPredicate(
      (node) =>
          !node.isMergedIntoParent &&
          node.getSemanticsData().flagsCollection.isButton,
    )
    .evaluate()
    .length;

Finder _loadingDot() => find.byWidgetPredicate(
  (widget) => widget.runtimeType.toString() == '_ZamLoadingDot',
);

Finder _overlay(Finder owner) => find.descendant(
  of: owner,
  matching: find.byWidgetPredicate(
    (widget) =>
        widget is DecoratedBox &&
        widget.position == DecorationPosition.foreground,
  ),
);

Color? _overlayColor(WidgetTester tester, Finder owner) =>
    (tester.widget<DecoratedBox>(_overlay(owner).first).decoration
            as BoxDecoration)
        .color;

bool _overlayHasBorder(WidgetTester tester, Finder owner) =>
    (tester.widget<DecoratedBox>(_overlay(owner).first).decoration
            as BoxDecoration)
        .border !=
    null;

void main() {
  group('ZamIconButton semantics', () {
    testWidgets('disabled reports button, not enabled, one node', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(const ZamIconButton(icon: Text('x')));
      expect(_buttonNodes(tester), 1);
      expect(
        tester.getSemantics(find.byType(ZamIconButton)),
        isSemantics(isButton: true, isEnabled: false, hasTapAction: false),
      );
      handle.dispose();
    });

    testWidgets('enabled reports enabled with tap action, one node', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        ZamIconButton(
          icon: const Text('x'),
          semanticLabel: 'Add',
          onPressed: () {},
        ),
      );
      expect(_buttonNodes(tester), 1);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Add')),
        isSemantics(
          label: 'Add',
          isButton: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });
  });

  group('loading dot', () {
    testWidgets('takes the label foreground on an outline button', (
      tester,
    ) async {
      await tester.pumpApp(
        const SizedBox(
          width: 300,
          child: ZamButton.outline(label: 'Save', isLoading: true),
        ),
      );
      final labelColor = DefaultTextStyle.of(
        tester.element(find.text('Save')),
      ).style.color;
      final dot = tester.widget<DecoratedBox>(
        find.descendant(of: _loadingDot(), matching: find.byType(DecoratedBox)),
      );
      final scheme = ShadTheme.of(tester.element(_loadingDot())).colorScheme;
      expect((dot.decoration as BoxDecoration).color, labelColor);
      expect(labelColor, isNot(scheme.primaryForeground));
    });

    testWidgets('pulses, and stops with disableAnimations', (tester) async {
      double opacity() => tester
          .widget<FadeTransition>(
            find.descendant(
              of: _loadingDot(),
              matching: find.byType(FadeTransition),
            ),
          )
          .opacity
          .value;

      await tester.pumpApp(const ZamButton(label: 'Save', isLoading: true));
      final start = opacity();
      await tester.pump(const Duration(milliseconds: 100));
      expect(opacity(), isNot(start));
      expect(tester.binding.hasScheduledFrame, isTrue);

      await tester.pumpApp(
        Builder(
          builder: (context) => MediaQuery(
            data: MediaQuery.of(context).copyWith(disableAnimations: true),
            child: const ZamButton(label: 'Save', isLoading: true),
          ),
        ),
      );
      await tester.pumpAndSettle();
      final still = opacity();
      await tester.pump(const Duration(milliseconds: 100));
      expect(opacity(), still);
    });
  });

  group('RTL', () {
    testWidgets('ZamDivider indent starts at the right edge', (tester) async {
      await tester.pumpApp(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(width: 200, child: ZamDivider(indent: 10)),
          ),
        ),
      );
      final line = tester.getRect(
        find.descendant(
          of: find.byType(ZamDivider),
          matching: find.byType(ColoredBox),
        ),
      );
      final box = tester.getRect(find.byType(ZamDivider));
      expect(line.right, box.right - 10);
      expect(line.left, box.left);
    });

    testWidgets('ZamListTile divider indent is on the start side', (
      tester,
    ) async {
      await tester.pumpApp(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 300,
              child: ZamListTile(
                title: 'Row',
                showDivider: true,
                padding: EdgeInsetsDirectional.only(start: 24),
              ),
            ),
          ),
        ),
      );
      final line = tester.getRect(
        find.descendant(
          of: find.byType(ZamDivider),
          matching: find.byType(ColoredBox),
        ),
      );
      final box = tester.getRect(find.byType(ZamDivider));
      expect(line.right, box.right - 24);
      expect(line.left, box.left);
    });
  });

  group('keyboard, hover and press', () {
    var taps = 0;
    final cases = <String, Widget Function()>{
      'ZamFilterPill': () =>
          ZamFilterPill(label: 'All', selected: false, onTap: () => taps++),
      'ZamListTile': () => ZamListTile(
        title: 'Row',
        semanticLabel: 'Row',
        onTap: () => taps++,
      ),
      'ZamSurface': () => ZamSurface(
        semanticLabel: 'Card',
        onTap: () => taps++,
        child: const Text('Card body'),
      ),
      'ZamScreenHeader': () =>
          ZamScreenHeader(title: 'Title', onBack: () => taps++),
    };

    for (final entry in cases.entries) {
      final type = entry.key;
      Finder owner() => find.byType(
        {
          'ZamFilterPill': ZamFilterPill,
          'ZamListTile': ZamListTile,
          'ZamSurface': ZamSurface,
          'ZamScreenHeader': ZamScreenHeader,
        }[type]!,
      );

      testWidgets('$type is focusable and activates with Enter and Space', (
        tester,
      ) async {
        taps = 0;
        await tester.pumpApp(
          Align(alignment: Alignment.topLeft, child: entry.value()),
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(_overlayHasBorder(tester, owner()), isTrue);
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(taps, 1);
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        expect(taps, 2);
      });

      testWidgets('$type activates with Enter under the web shortcuts', (
        tester,
      ) async {
        taps = 0;
        await tester.pumpApp(
          // Web maps Enter to ButtonActivateIntent and has no ActivateIntent
          // fallback for it, which the outer Shortcuts stands in for.
          Shortcuts(
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.enter):
                  DoNothingAndStopPropagationIntent(),
            },
            child: Shortcuts(
              shortcuts: const {
                SingleActivator(LogicalKeyboardKey.enter):
                    ButtonActivateIntent(),
              },
              child: Align(alignment: Alignment.topLeft, child: entry.value()),
            ),
          ),
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(taps, 1);
      });

      testWidgets('$type still taps and shows hover and press overlay', (
        tester,
      ) async {
        taps = 0;
        await tester.pumpApp(
          Align(alignment: Alignment.topLeft, child: entry.value()),
        );
        final target = _overlay(owner()).first;
        final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
        await mouse.addPointer(location: Offset.zero);
        addTearDown(mouse.removePointer);
        await mouse.moveTo(tester.getCenter(target));
        await tester.pump();
        final hover = _overlayColor(tester, owner());
        expect(hover, isNotNull);
        expect(hover!.a, greaterThan(0));

        await mouse.down(tester.getCenter(target));
        await tester.pump();
        final pressed = _overlayColor(tester, owner());
        expect(pressed!.a, greaterThan(hover.a));
        await mouse.up();
        expect(taps, 1);
      });

      testWidgets('$type exposes one button node', (tester) async {
        final handle = tester.ensureSemantics();
        await tester.pumpApp(
          Align(alignment: Alignment.topLeft, child: entry.value()),
        );
        expect(_buttonNodes(tester), 1);
        handle.dispose();
      });
    }
  });
}
