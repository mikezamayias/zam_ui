import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

const _target = ColoredBox(
  key: Key('target'),
  color: Color(0x00000000),
  child: SizedBox(width: 120, height: 60),
);

BoxDecoration _overlay(WidgetTester tester) {
  final box = tester.widget<DecoratedBox>(
    find
        .descendant(
          of: find.byType(ZamPressable),
          matching: find.byType(DecoratedBox),
        )
        .first,
  );
  return box.decoration as BoxDecoration;
}

Color get _foreground => testTheme.palette(Brightness.light).foreground;

void main() {
  group('ZamPressable', () {
    testWidgets('calls onTap on a tap and onLongPress on a long press', (
      tester,
    ) async {
      var taps = 0;
      var longPresses = 0;
      await tester.pumpApp(
        Center(
          child: ZamPressable(
            onTap: () => taps++,
            onLongPress: () => longPresses++,
            child: _target,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('target')));
      expect(taps, 1);
      expect(longPresses, 0);

      await tester.longPress(find.byKey(const Key('target')));
      expect(taps, 1);
      expect(longPresses, 1);
    });

    testWidgets('draws the press overlay only while pressed', (tester) async {
      await tester.pumpApp(
        Center(
          child: ZamPressable(onTap: () {}, child: _target),
        ),
      );
      final opacities = testTheme.opacities;

      expect(_overlay(tester).color, testTheme.colors.transparent);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('target'))),
      );
      await tester.pump();
      expect(
        _overlay(tester).color,
        opacities.apply(_foreground, opacities.pressed),
      );

      await gesture.up();
      await tester.pump();
      expect(_overlay(tester).color, testTheme.colors.transparent);
    });

    testWidgets('draws the press overlay during a long press only', (
      tester,
    ) async {
      await tester.pumpApp(
        Center(
          child: ZamPressable(onLongPress: () {}, child: _target),
        ),
      );
      final opacities = testTheme.opacities;

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('target'))),
      );
      await tester.pump();
      expect(
        _overlay(tester).color,
        opacities.apply(_foreground, opacities.pressed),
      );

      await gesture.up();
      await tester.pump();
      expect(_overlay(tester).color, testTheme.colors.transparent);
    });

    testWidgets('draws a lighter overlay on hover', (tester) async {
      await tester.pumpApp(
        Center(
          child: ZamPressable(onTap: () {}, child: _target),
        ),
      );
      final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
      await mouse.addPointer(location: Offset.zero);
      addTearDown(mouse.removePointer);

      await mouse.moveTo(tester.getCenter(find.byKey(const Key('target'))));
      await tester.pump();
      final opacities = testTheme.opacities;
      expect(
        _overlay(tester).color,
        opacities.apply(_foreground, opacities.whisper),
      );

      await mouse.moveTo(const Offset(1, 1));
      await tester.pump();
      expect(_overlay(tester).color, testTheme.colors.transparent);
    });

    testWidgets('Enter and Space activate onTap and a ring shows on focus', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var taps = 0;
      await tester.pumpApp(
        Center(
          child: ZamPressable(
            focusNode: focusNode,
            onTap: () => taps++,
            child: _target,
          ),
        ),
      );

      focusNode.requestFocus();
      await tester.pump();
      // A key event moves the focus highlight to keyboard mode.
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pump();
      expect(taps, 1);
      expect(_overlay(tester).border, isNotNull);
      expect(
        (_overlay(tester).border! as Border).top.color,
        testTheme.palette(Brightness.light).ring,
      );

      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pump();
      expect(taps, 2);
    });

    testWidgets('ignores input and cannot focus when disabled', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      var taps = 0;
      await tester.pumpApp(
        Center(
          child: ZamPressable(
            focusNode: focusNode,
            enabled: false,
            onTap: () => taps++,
            onLongPress: () => taps++,
            child: _target,
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('target')));
      await tester.longPress(find.byKey(const Key('target')));
      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);

      expect(taps, 0);
      expect(focusNode.hasFocus, isFalse);
      expect(_overlay(tester).color, testTheme.colors.transparent);
    });

    testWidgets('is inactive with no callback', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(const Center(child: ZamPressable(child: _target)));

      final node = tester.getSemantics(find.byKey(const Key('target')));
      expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });

    testWidgets('clears the overlay when it becomes disabled mid-press', (
      tester,
    ) async {
      Widget build({required bool enabled}) => Center(
        child: ZamPressable(enabled: enabled, onTap: () {}, child: _target),
      );
      await tester.pumpApp(build(enabled: true));
      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(const Key('target'))),
      );
      await tester.pump();

      await tester.pumpApp(build(enabled: false));
      expect(_overlay(tester).color, testTheme.colors.transparent);
      await gesture.up();
    });

    testWidgets('adds the tap action and leaves label and role to callers', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        Center(
          child: Semantics(
            button: true,
            label: 'Open',
            child: ZamPressable(onTap: () {}, child: _target),
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Open')),
        isSemantics(label: 'Open', isButton: true, hasTapAction: true),
      );

      await tester.pumpApp(
        Center(
          child: ZamPressable(onTap: () {}, child: _target),
        ),
      );
      final bare = tester
          .getSemantics(find.byKey(const Key('target')))
          .getSemanticsData();
      expect(bare.label, isEmpty);
      expect(bare.flagsCollection.isButton, isFalse);
      expect(bare.hasAction(SemanticsAction.tap), isTrue);
      handle.dispose();
    });

    testWidgets('reports a long press action to screen readers', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        Center(
          child: ZamPressable(onLongPress: () {}, child: _target),
        ),
      );

      final data = tester
          .getSemantics(find.byKey(const Key('target')))
          .getSemanticsData();
      expect(data.hasAction(SemanticsAction.longPress), isTrue);
      handle.dispose();
    });

    testWidgets('rounds the overlay with a directional radius', (
      tester,
    ) async {
      const radius = BorderRadiusDirectional.only(
        topStart: Radius.circular(12),
      );
      await tester.pumpApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Center(
            child: ZamPressable(onTap: () {}, radius: radius, child: _target),
          ),
        ),
      );

      expect(_overlay(tester).borderRadius, radius);
    });
  });
}
