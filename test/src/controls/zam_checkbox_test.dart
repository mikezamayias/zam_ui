import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

ShadCheckbox _shad(WidgetTester tester) =>
    tester.widget<ShadCheckbox>(find.byType(ShadCheckbox));

Color? _edge(ShadCheckbox box) => box.decoration?.border?.top?.color;

void main() {
  group('ZamCheckbox', () {
    testWidgets('toggles to the opposite value on a tap', (tester) async {
      final changes = <bool>[];
      await tester.pumpApp(
        Center(child: ZamCheckbox(value: false, onChanged: changes.add)),
      );

      await tester.tap(find.byType(ShadCheckbox));
      expect(changes, [true]);

      await tester.pumpApp(
        Center(child: ZamCheckbox(value: true, onChanged: changes.add)),
      );
      await tester.tap(find.byType(ShadCheckbox));
      expect(changes, [true, false]);
    });

    testWidgets('Enter and Space toggle it while focused', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final changes = <bool>[];
      await tester.pumpApp(
        Center(
          child: ZamCheckbox(
            value: false,
            focusNode: focusNode,
            onChanged: changes.add,
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.sendKeyEvent(LogicalKeyboardKey.space);

      expect(changes, [true, true]);
    });

    testWidgets('does nothing without onChanged or when disabled', (
      tester,
    ) async {
      var calls = 0;
      await tester.pumpApp(const Center(child: ZamCheckbox(value: false)));
      await tester.tap(find.byType(ShadCheckbox), warnIfMissed: false);

      await tester.pumpApp(
        Center(
          child: ZamCheckbox(
            value: false,
            enabled: false,
            onChanged: (_) => calls++,
          ),
        ),
      );
      await tester.tap(find.byType(ShadCheckbox), warnIfMissed: false);

      expect(calls, 0);
      expect(_shad(tester).enabled, isFalse);
    });

    testWidgets('reports checked state, enabled state and the tap action', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final changes = <bool>[];
      await tester.pumpApp(
        Center(
          child: ZamCheckbox(
            value: true,
            semanticLabel: 'Accept',
            onChanged: changes.add,
          ),
        ),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Accept'));
      expect(
        node,
        isSemantics(
          label: 'Accept',
          hasCheckedState: true,
          isChecked: true,
          isEnabled: true,
          isFocusable: true,
          hasEnabledState: true,
          hasTapAction: true,
        ),
      );
      tester.semantics.tap(find.semantics.byLabel('Accept'));
      expect(changes, [false]);
      handle.dispose();
    });

    testWidgets('a disabled checkbox has no tap action', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        const Center(child: ZamCheckbox(value: false, semanticLabel: 'Off')),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Off'));
      expect(
        node,
        isSemantics(
          label: 'Off',
          hasCheckedState: true,
          isChecked: false,
          hasEnabledState: true,
          isEnabled: false,
          hasTapAction: false,
        ),
      );
      handle.dispose();
    });

    testWidgets('merges into the label of a wrapping node', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        Center(
          child: Semantics(
            container: true,
            label: 'Accept the terms',
            child: ZamCheckbox(value: true, onChanged: (_) {}),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Accept the terms')),
        isSemantics(
          label: 'Accept the terms',
          hasCheckedState: true,
          isChecked: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasTapAction: true,
        ),
      );
      expect(
        find.semantics.byPredicate(
          (node) => node.getSemanticsData().hasAction(SemanticsAction.tap),
        ),
        findsOneWidget,
      );
      handle.dispose();
    });

    testWidgets('leaves the fill and edge to the theme by default', (
      tester,
    ) async {
      await tester.pumpApp(
        Center(child: ZamCheckbox(value: true, onChanged: (_) {})),
      );

      final box = _shad(tester);
      expect(box.color, isNull);
      expect(box.decoration, isNull);
      final shadTheme = ShadTheme.of(tester.element(find.byType(ShadCheckbox)));
      expect(
        shadTheme.checkboxTheme.color,
        testTheme.palette(Brightness.light).primaryControl,
      );
    });

    testWidgets('takes the fill, size and edge colors', (tester) async {
      const fill = Color(0xFF123456);
      const edge = Color(0xFF654321);
      const checkedEdge = Color(0xFF0A0B0C);
      Widget build({required bool value}) => Center(
        child: ZamCheckbox(
          value: value,
          size: 24,
          color: fill,
          borderColor: edge,
          checkedBorderColor: checkedEdge,
          onChanged: (_) {},
        ),
      );

      await tester.pumpApp(build(value: false));
      expect(_shad(tester).color, fill);
      expect(_shad(tester).size, 24);
      expect(_edge(_shad(tester)), edge);

      await tester.pumpApp(build(value: true));
      expect(_edge(_shad(tester)), checkedEdge);
    });

    testWidgets('the checked edge falls back to the border color', (
      tester,
    ) async {
      const edge = Color(0xFF654321);
      await tester.pumpApp(
        Center(
          child: ZamCheckbox(value: true, borderColor: edge, onChanged: (_) {}),
        ),
      );

      expect(_edge(_shad(tester)), edge);
    });

    testWidgets('builds in right-to-left layouts', (
      tester,
    ) async {
      await tester.pumpApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: ZamCheckbox(value: true, size: 20, onChanged: (_) {}),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.byType(ZamCheckbox), findsOneWidget);
    });
  });
}
