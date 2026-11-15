import 'dart:ui' show Tristate;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

const _label = 'Search';
const _clearLabel = 'Clear search';
const _placeholder = 'Search skills';

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  ZamThemeMode themeMode = ZamThemeMode.light,
  ZamThemeData? theme,
}) async {
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  final effectiveTheme = theme ?? testTheme;
  await tester.pumpWidget(
    ZamApp(
      theme: effectiveTheme,
      darkTheme: effectiveTheme,
      themeMode: themeMode,
      home: Align(
        alignment: AlignmentDirectional.topStart,
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: SizedBox(width: 300, child: child),
        ),
      ),
    ),
  );
}

ZamSearchField _field({
  TextEditingController? controller,
  FocusNode? focusNode,
  ValueChanged<String>? onChanged,
  ValueChanged<String>? onSubmitted,
  bool enabled = true,
}) => ZamSearchField(
  semanticsLabel: _label,
  clearSemanticsLabel: _clearLabel,
  placeholderText: _placeholder,
  controller: controller,
  focusNode: focusNode,
  onChanged: onChanged,
  onSubmitted: onSubmitted,
  enabled: enabled,
);

Finder get _clearButton => find.descendant(
  of: find.byType(ZamSearchField),
  matching: find.byType(ZamPressable),
);

BoxDecoration _decoration(WidgetTester tester, DecorationPosition position) {
  final box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(ZamSearchField),
          matching: find.byWidgetPredicate(
            (widget) => widget is DecoratedBox && widget.position == position,
          ),
        )
        .first,
  );
  return box.decoration as BoxDecoration;
}

BoxDecoration _box(WidgetTester tester) =>
    _decoration(tester, DecorationPosition.background);

BoxDecoration _ring(WidgetTester tester) =>
    _decoration(tester, DecorationPosition.foreground);

void main() {
  group('ZamSearchField', () {
    testWidgets('typing calls onChanged and submit calls onSubmitted', (
      tester,
    ) async {
      final changes = <String>[];
      final submits = <String>[];
      await _pump(
        tester,
        _field(onChanged: changes.add, onSubmitted: submits.add),
      );

      await tester.enterText(find.byType(ZamTextField), 'dart');
      await tester.testTextInput.receiveAction(TextInputAction.search);
      await tester.pump();

      expect(changes, ['dart']);
      expect(submits, ['dart']);
    });

    testWidgets('asks for the search action and switches autofill off', (
      tester,
    ) async {
      await _pump(tester, _field());

      final config = tester
          .state<EditableTextState>(find.byType(EditableText))
          .textInputConfiguration;
      expect(config.inputAction, TextInputAction.search);
      expect(config.autofillConfiguration.enabled, isFalse);
    });

    testWidgets('shows the search icon and the placeholder', (tester) async {
      await _pump(tester, _field());

      expect(find.byIcon(testTheme.icons.search!), findsOneWidget);
      expect(find.text(_placeholder), findsOneWidget);
    });

    testWidgets('the clear button shows only with text and clears it', (
      tester,
    ) async {
      final changes = <String>[];
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await _pump(tester, _field(focusNode: focusNode, onChanged: changes.add));

      expect(_clearButton, findsNothing);

      await tester.enterText(find.byType(ZamTextField), 'flutter');
      await tester.pump();
      expect(_clearButton, findsOneWidget);
      expect(find.byIcon(testTheme.icons.clear!), findsOneWidget);

      await tester.tap(_clearButton);
      await tester.pump();

      expect(find.text('flutter'), findsNothing);
      expect(_clearButton, findsNothing);
      expect(changes, ['flutter', '']);
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('the clear button is at least the minimum tap target', (
      tester,
    ) async {
      await _pump(tester, _field());
      await tester.enterText(find.byType(ZamTextField), 'a');
      await tester.pump();

      final minTapTarget = testTheme.sizes.minTapTarget;
      final size = tester.getSize(_clearButton);
      expect(size.width, greaterThanOrEqualTo(minTapTarget));
      expect(size.height, greaterThanOrEqualTo(minTapTarget));
      expect(
        tester.getSize(find.byType(ZamSearchField)).height,
        greaterThanOrEqualTo(minTapTarget),
      );
    });

    testWidgets('works with an external controller', (tester) async {
      final controller = TextEditingController(text: 'preset');
      addTearDown(controller.dispose);
      await _pump(tester, _field(controller: controller));

      expect(find.text('preset'), findsOneWidget);
      expect(_clearButton, findsOneWidget);

      controller.clear();
      await tester.pump();
      expect(_clearButton, findsNothing);

      await tester.enterText(find.byType(ZamTextField), 'typed');
      expect(controller.text, 'typed');

      await tester.pump();
      await tester.tap(_clearButton);
      await tester.pump();
      expect(controller.text, isEmpty);
    });

    testWidgets('keeps the text across a swap to and from a controller', (
      tester,
    ) async {
      await _pump(tester, _field());
      await tester.enterText(find.byType(ZamTextField), 'local');

      final external = TextEditingController(text: 'external');
      addTearDown(external.dispose);
      await _pump(tester, _field(controller: external));
      expect(find.text('external'), findsOneWidget);

      await _pump(tester, _field());
      await tester.pump();
      expect(find.text('external'), findsOneWidget);
    });

    testWidgets('focus shows the ring', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await _pump(tester, _field(focusNode: focusNode));
      final palette = testTheme.palette(Brightness.light);

      expect(_ring(tester).border, isNull);

      focusNode.requestFocus();
      await tester.pump();

      expect(
        _ring(tester).border,
        Border.fromBorderSide(
          BorderSide(color: palette.ring, width: testTheme.strokes.focusRing),
        ),
      );

      focusNode.unfocus();
      await tester.pump();
      expect(_ring(tester).border, isNull);
    });

    testWidgets('a tap on the box padding focuses the field', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await _pump(tester, _field(focusNode: focusNode));

      await tester.tap(find.byIcon(testTheme.icons.search!));
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('names the field and the clear button for screen readers', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _pump(tester, _field());

      final field = tester
          .getSemantics(find.byType(ZamTextField))
          .getSemanticsData();
      expect(field.label, _label);
      expect(field.hint, _placeholder);
      expect(find.bySemanticsLabel(_clearLabel), findsNothing);

      await tester.enterText(find.byType(ZamTextField), 'x');
      await tester.pump();

      final clear = tester.getSemantics(find.bySemanticsLabel(_clearLabel));
      expect(
        clear,
        matchesSemantics(
          label: _clearLabel,
          isButton: true,
          hasTapAction: true,
        ),
      );
      handle.dispose();
    });

    testWidgets('a disabled field dims, cannot focus and hides clear', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final controller = TextEditingController(text: 'query');
      addTearDown(controller.dispose);
      await _pump(
        tester,
        _field(controller: controller, focusNode: focusNode, enabled: false),
      );

      final opacity = tester.widget<Opacity>(
        find
            .descendant(
              of: find.byType(ZamSearchField),
              matching: find.byType(Opacity),
            )
            .first,
      );
      expect(opacity.opacity, testTheme.opacities.disabled);
      expect(_clearButton, findsNothing);

      await tester.tap(find.byType(ZamSearchField));
      await tester.pump();
      focusNode.requestFocus();
      await tester.pump();
      expect(focusNode.hasFocus, isFalse);

      final data = tester
          .getSemantics(find.byType(ZamTextField))
          .getSemanticsData();
      expect(data.flagsCollection.isEnabled, Tristate.isFalse);
      handle.dispose();
    });

    for (final brightness in Brightness.values) {
      testWidgets('draws the box from the $brightness palette', (
        tester,
      ) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        await _pump(
          tester,
          _field(focusNode: focusNode),
          themeMode: brightness == Brightness.dark
              ? ZamThemeMode.dark
              : ZamThemeMode.light,
        );
        final palette = testTheme.palette(brightness);

        final box = _box(tester);
        expect(box.color, palette.card);
        expect(box.borderRadius, testTheme.radius.md);
        expect(
          box.border,
          Border.fromBorderSide(testTheme.strokes.border(palette.border)),
        );
        final icon = tester.widget<Icon>(
          find.byIcon(testTheme.icons.search!),
        );
        expect(icon.color, palette.mutedForeground);

        focusNode.requestFocus();
        await tester.pump();
        expect(
          (_ring(tester).border! as Border).top.color,
          palette.ring,
        );
      });
    }

    testWidgets('falls back without search and clear icons', (tester) async {
      final theme = testTheme.copyWith(
        icons: ZamIconSet(
          info: testTheme.icons.info,
          success: testTheme.icons.success,
          warning: testTheme.icons.warning,
          error: testTheme.icons.error,
          back: testTheme.icons.back,
          chevronRight: testTheme.icons.chevronRight,
        ),
      );
      await _pump(tester, _field(), theme: theme);

      expect(
        find.descendant(
          of: find.byType(ZamSearchField),
          matching: find.byType(Icon),
        ),
        findsNothing,
      );

      await tester.enterText(find.byType(ZamTextField), 'x');
      await tester.pump();

      expect(
        find.descendant(of: _clearButton, matching: find.byType(CustomPaint)),
        findsOneWidget,
      );
    });
  });

  group('ZamIconSet', () {
    test('compares the search and clear roles', () {
      const base = ZamIconSet(
        info: IconData(1),
        success: IconData(2),
        warning: IconData(3),
        error: IconData(4),
        back: IconData(5),
        chevronRight: IconData(6),
      );
      const withSearch = ZamIconSet(
        info: IconData(1),
        success: IconData(2),
        warning: IconData(3),
        error: IconData(4),
        back: IconData(5),
        chevronRight: IconData(6),
        search: IconData(7),
        clear: IconData(8),
      );

      expect(base.search, isNull);
      expect(base.clear, isNull);
      expect(base == withSearch, isFalse);
      expect(
        withSearch,
        const ZamIconSet(
          info: IconData(1),
          success: IconData(2),
          warning: IconData(3),
          error: IconData(4),
          back: IconData(5),
          chevronRight: IconData(6),
          search: IconData(7),
          clear: IconData(8),
        ),
      );
      expect(withSearch.hashCode, isNot(base.hashCode));
    });
  });
}
