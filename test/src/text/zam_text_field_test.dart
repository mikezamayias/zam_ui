import 'dart:ui' show SemanticsAction, SemanticsValidationResult, Tristate;

import 'package:flutter/gestures.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';
import 'text_test_support.dart';

const _style = TextStyle(fontSize: 20, height: 1);
const _android = '_ZamAndroidHandlePainter';
const _ios = '_ZamIosHandlePainter';

Future<TextEditingController> _pumpWithText(
  WidgetTester tester,
  String text, {
  TextDirection textDirection = TextDirection.ltr,
  bool systemContextMenu = false,
}) async {
  final controller = TextEditingController(text: text);
  addTearDown(controller.dispose);
  await pumpField(
    tester,
    ZamTextField(controller: controller, style: _style),
    textDirection: textDirection,
    systemContextMenu: systemContextMenu,
  );
  return controller;
}

void main() {
  group('typing', () {
    testWidgets('updates the controller and reports changes and submit', (
      tester,
    ) async {
      final changes = <String>[];
      final submits = <String>[];
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await pumpField(
        tester,
        ZamTextField(
          controller: controller,
          style: _style,
          textInputAction: TextInputAction.done,
          onChanged: changes.add,
          onSubmitted: submits.add,
        ),
      );

      await tester.enterText(find.byType(ZamTextField), 'hello');
      await tester.testTextInput.receiveAction(TextInputAction.done);
      await tester.pump();

      expect(controller.text, 'hello');
      expect(changes, ['hello']);
      expect(submits, ['hello']);
    });

    testWidgets('swaps its own focus node for a given one', (tester) async {
      await pumpField(tester, const ZamTextField(style: _style));
      await tester.tap(find.byType(ZamTextField));
      await tester.pump();

      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await pumpField(
        tester,
        ZamTextField(focusNode: focusNode, style: _style),
      );
      await tester.pump();
      await tester.tap(find.byType(ZamTextField));
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('keeps text in its own controller and across a swap', (
      tester,
    ) async {
      Widget field(TextEditingController? controller) =>
          ZamTextField(controller: controller, style: _style);

      await pumpField(tester, field(null));
      await tester.enterText(find.byType(ZamTextField), 'local');
      expect(find.text('local'), findsOneWidget);

      final external = TextEditingController(text: 'external');
      addTearDown(external.dispose);
      await pumpField(tester, field(external));
      expect(find.text('external'), findsOneWidget);

      await pumpField(tester, field(null));
      await tester.pump();
      expect(find.text('external'), findsOneWidget);
    });

    testWidgets('applies input formatters and the max length', (tester) async {
      final controller = TextEditingController();
      addTearDown(controller.dispose);
      await pumpField(
        tester,
        ZamTextField(
          controller: controller,
          style: _style,
          maxLength: 4,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
      );

      await tester.enterText(find.byType(ZamTextField), 'a1b2c3d4e5');

      expect(controller.text, '1234');
    });

    testWidgets('is one line tall with no border, fill or padding', (
      tester,
    ) async {
      await pumpField(tester, const ZamTextField(style: _style));

      expect(tester.getSize(find.byType(ZamTextField)), const Size(300, 20));
      expect(
        tester.getTopLeft(find.byType(EditableText)),
        tester.getTopLeft(find.byType(ZamTextField)),
      );
    });

    testWidgets('a tap on the background focuses the field', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await pumpField(
        tester,
        ZamTextField(
          focusNode: focusNode,
          style: _style,
          placeholderText: 'A placeholder that wraps onto several lines',
        ),
        width: 120,
      );

      final box = tester.getRect(find.byType(ZamTextField));
      expect(box.height, greaterThan(40));
      await tester.tapAt(box.bottomLeft + const Offset(4, -4));
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('a disabled field ignores taps and cannot take focus', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await pumpField(
        tester,
        ZamTextField(focusNode: focusNode, style: _style, enabled: false),
      );

      await tester.tap(find.byType(ZamTextField));
      await tester.pump();
      focusNode.requestFocus();
      await tester.pump();

      expect(focusNode.hasFocus, isFalse);
    });
  });

  group('placeholder', () {
    testWidgets('shows while empty in the placeholder color', (tester) async {
      await pumpField(
        tester,
        const ZamTextField(placeholderText: 'Email', style: _style),
      );
      final palette = testTheme.palette(Brightness.light);

      final style = tester
          .widget<DefaultTextStyle>(
            find
                .ancestor(
                  of: find.text('Email'),
                  matching: find.byType(DefaultTextStyle),
                )
                .first,
          )
          .style;
      expect(style.color, palette.placeholderText);
      expect(style.fontSize, 20);

      await tester.enterText(find.byType(ZamTextField), 'a');
      await tester.pump();
      final visibility = tester.widget<Visibility>(
        find.ancestor(
          of: find.text('Email'),
          matching: find.byType(Visibility),
        ),
      );
      expect(visibility.visible, isFalse);
      expect(visibility.maintainSize, isTrue);
    });

    testWidgets('a wrapping placeholder grows the field', (tester) async {
      await pumpField(
        tester,
        const ZamTextField(
          placeholderText: 'A placeholder long enough to wrap',
          style: _style,
        ),
        width: 120,
      );

      // Six glyphs of 20 fit a line of 120, so the 33 glyphs take six lines.
      expect(tester.getSize(find.byType(ZamTextField)).height, 120);
    });

    testWidgets('keeps its size after typing unless told otherwise', (
      tester,
    ) async {
      Widget field({required bool maintain}) => ZamTextField(
        placeholderText: 'A placeholder long enough to wrap',
        maintainPlaceholderSize: maintain,
        style: _style,
      );

      await pumpField(tester, field(maintain: true), width: 120);
      await tester.enterText(find.byType(ZamTextField), 'a');
      await tester.pump();
      expect(tester.getSize(find.byType(ZamTextField)).height, 120);

      await pumpField(tester, field(maintain: false), width: 120);
      await tester.pump();
      expect(tester.getSize(find.byType(ZamTextField)).height, 20);
    });

    testWidgets('ends in an ellipsis at its max lines', (tester) async {
      await pumpField(
        tester,
        const ZamTextField(
          placeholderText: 'A placeholder long enough to wrap',
          placeholderMaxLines: 1,
          style: _style,
        ),
        width: 120,
      );

      final text = tester.widget<DefaultTextStyle>(
        find
            .ancestor(
              of: find.text('A placeholder long enough to wrap'),
              matching: find.byType(DefaultTextStyle),
            )
            .first,
      );
      expect(text.maxLines, 1);
      expect(text.overflow, TextOverflow.ellipsis);
      expect(tester.getSize(find.byType(ZamTextField)).height, 20);
    });

    testWidgets('takes a custom widget', (tester) async {
      await pumpField(
        tester,
        const ZamTextField(
          placeholder: Text('Custom'),
          placeholderText: 'Announced',
          style: _style,
        ),
      );

      expect(find.text('Custom'), findsOneWidget);
      expect(find.text('Announced'), findsNothing);
    });
  });

  group('selection on Android', () {
    testWidgets('a long press selects a word and shows teardrop handles', (
      tester,
    ) async {
      final controller = await _pumpWithText(tester, 'alpha beta gamma');

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();

      expect(
        controller.selection,
        const TextSelection(baseOffset: 6, extentOffset: 10),
      );
      expect(findHandlePainter(_android), findsNWidgets(2));
      expect(findHandlePainter(_ios), findsNothing);
    });

    testWidgets('handles use the primaryControl color', (tester) async {
      await _pumpWithText(tester, 'alpha beta gamma');

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();

      final color = testTheme.palette(Brightness.light).primaryControl;
      final handle = findHandlePainter(_android).first;
      expect(tester.renderObject(handle), paints..path(color: color));
    });

    testWidgets('a long press drag shows the magnifier', (tester) async {
      await _pumpWithText(tester, 'alpha beta gamma');

      final gesture = await tester.startGesture(
        textOffsetToPosition(tester, 2),
      );
      await tester.pump(kLongPressTimeout + kPressTimeout);
      await gesture.moveTo(textOffsetToPosition(tester, 8));
      await tester.pump();

      expect(find.byType(RawMagnifier), findsOneWidget);
      final magnifier = tester.widget<RawMagnifier>(find.byType(RawMagnifier));
      expect(magnifier.magnificationScale, 1.25);

      await gesture.moveTo(textOffsetToPosition(tester, 12));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(RawMagnifier), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.byType(RawMagnifier), findsNothing);
    });
  });

  group('Android magnifier', () {
    testWidgets('animates only when the drag jumps to another line', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'alpha beta gamma delta');
      addTearDown(controller.dispose);
      await pumpField(
        tester,
        ZamTextField(controller: controller, style: _style, maxLines: null),
        width: 120,
      );

      final gesture = await tester.startGesture(
        textOffsetToPosition(tester, 1),
      );
      await tester.pump(kLongPressTimeout + kPressTimeout);
      await gesture.moveTo(textOffsetToPosition(tester, 3));
      await tester.pump();
      Duration lensDuration() => tester
          .widget<AnimatedPositioned>(
            find.ancestor(
              of: find.byType(RawMagnifier),
              matching: find.byType(AnimatedPositioned),
            ),
          )
          .duration;
      expect(lensDuration(), Duration.zero);

      // "beta" starts the second line.
      await gesture.moveTo(textOffsetToPosition(tester, 8));
      await tester.pump();
      expect(lensDuration(), ZamDurationToken.short1.duration);

      await tester.pump(const Duration(milliseconds: 60));
      expect(lensDuration(), Duration.zero);
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('points at the middle of a field narrower than the lens', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'ab');
      addTearDown(controller.dispose);
      await pumpField(
        tester,
        ZamTextField(controller: controller, style: _style),
        width: 40,
      );

      final gesture = await tester.startGesture(
        textOffsetToPosition(tester, 1),
      );
      await tester.pump(kLongPressTimeout + kPressTimeout);
      await gesture.moveTo(textOffsetToPosition(tester, 2));
      await tester.pump();

      final lens = tester.getRect(find.byType(RawMagnifier));
      final field = tester.getRect(find.byType(ZamTextField));
      final magnifier = tester.widget<RawMagnifier>(find.byType(RawMagnifier));
      expect(
        magnifier.focalPointOffset.dx,
        closeTo(field.center.dx - lens.center.dx, 0.01),
      );
      await gesture.up();
      await tester.pumpAndSettle();
    });
  });

  group('edit menu', () {
    testWidgets('sits above the selection when there is room', (tester) async {
      final controller = TextEditingController(text: 'alpha beta gamma');
      addTearDown(controller.dispose);
      await pumpField(
        tester,
        ZamTextField(controller: controller, style: _style),
        padding: const EdgeInsets.fromLTRB(40, 400, 40, 40),
      );

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();

      final field = tester.getRect(find.byType(ZamTextField));
      expect(
        tester.getRect(find.text('Select All')).bottom,
        lessThan(field.top),
      );
    });

    testWidgets('drops below the handles when there is no room above', (
      tester,
    ) async {
      await _pumpWithText(tester, 'alpha beta gamma');

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();

      final handle = tester.getRect(findHandlePainter(_android).last);
      expect(tester.getRect(find.text('Cut')).top, greaterThan(handle.bottom));
    });

    testWidgets('stays above the keyboard', (tester) async {
      final controller = TextEditingController(text: 'alpha beta gamma');
      addTearDown(controller.dispose);
      // The field sits at 60, too close to the top for the menu, and the
      // keyboard starts at 120, so below the handles is hidden too.
      await pumpField(
        tester,
        ZamTextField(controller: controller, style: _style),
        padding: const EdgeInsets.fromLTRB(40, 60, 40, 0),
        viewInsets: const EdgeInsets.only(bottom: 680),
      );

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();

      for (final label in ['Cut', 'Copy', 'Select All']) {
        expect(tester.getRect(find.text(label)).bottom, lessThanOrEqualTo(120));
      }
    });

    testWidgets('stays below the status bar', (tester) async {
      final controller = TextEditingController(text: 'alpha beta gamma');
      addTearDown(controller.dispose);
      // Above the field at 150 there is room on the screen but not below a
      // status bar of 100, so the menu goes below the handles.
      await pumpField(
        tester,
        ZamTextField(controller: controller, style: _style),
        padding: const EdgeInsets.fromLTRB(40, 150, 40, 0),
        viewPadding: const EdgeInsets.only(top: 100),
      );

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();

      final handle = tester.getRect(findHandlePainter(_android).last);
      expect(tester.getRect(find.text('Cut')).top, greaterThan(handle.bottom));
    });

    testWidgets('a handle can be dragged while the menu shows', (tester) async {
      final controller = await _pumpWithText(tester, 'alpha beta gamma');

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();
      final gesture = await tester.startGesture(
        tester.getCenter(findHandlePainter(_android).last),
      );
      await tester.pump();
      for (var i = 0; i < 4; i++) {
        await gesture.moveBy(const Offset(15, 0));
        await tester.pump();
      }

      expect(find.byType(RawMagnifier), findsOneWidget);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(
        controller.selection,
        const TextSelection(baseOffset: 6, extentOffset: 14),
      );
      expect(find.byType(RawMagnifier), findsNothing);
    });

    testWidgets('copy puts the selected word on the clipboard', (
      tester,
    ) async {
      final clipboard = FakeClipboard()..install(tester);
      await _pumpWithText(tester, 'alpha beta gamma');

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();
      expect(find.text('Copy'), findsOneWidget);
      expect(find.text('Cut'), findsOneWidget);
      expect(find.text('Select All'), findsOneWidget);

      await tester.tap(find.text('Copy'));
      await tester.pumpAndSettle();

      expect(clipboard.text, 'beta');
    });

    testWidgets('cut removes the word and copies it', (tester) async {
      final clipboard = FakeClipboard()..install(tester);
      final controller = await _pumpWithText(tester, 'alpha beta gamma');

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cut'));
      await tester.pumpAndSettle();

      expect(clipboard.text, 'beta');
      expect(controller.text, 'alpha  gamma');
    });

    testWidgets('paste inserts the clipboard text', (tester) async {
      final clipboard = FakeClipboard()..install(tester);
      clipboard.text = 'pasted';
      final controller = await _pumpWithText(tester, 'alpha beta gamma');

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();
      expect(find.text('Paste'), findsOneWidget);
      await tester.tap(find.text('Paste'));
      await tester.pumpAndSettle();

      expect(controller.text, 'alpha pasted gamma');
    });

    testWidgets('select all selects every character', (tester) async {
      final controller = await _pumpWithText(tester, 'alpha beta gamma');

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Select All'));
      await tester.pumpAndSettle();

      expect(
        controller.selection,
        const TextSelection(baseOffset: 0, extentOffset: 16),
      );
      expect(find.text('Select All'), findsNothing);
      expect(find.text('Copy'), findsOneWidget);
    });

    testWidgets(
      'uses the iOS system menu where the platform supports it',
      (tester) async {
        // Answers the platform channel that shows the system menu.
        FakeClipboard().install(tester);
        await _pumpWithText(
          tester,
          'alpha beta gamma',
          systemContextMenu: true,
        );

        await tester.tapAt(textOffsetToPosition(tester, 8));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tapAt(textOffsetToPosition(tester, 8));
        await tester.pumpAndSettle();

        expect(find.byType(SystemContextMenu), findsOneWidget);
        expect(find.text('Copy'), findsNothing);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );

    testWidgets(
      'uses shad menu on iOS when the system menu is unavailable',
      (tester) async {
        await _pumpWithText(tester, 'alpha beta gamma');

        await tester.tapAt(textOffsetToPosition(tester, 8));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tapAt(textOffsetToPosition(tester, 8));
        await tester.pumpAndSettle();

        expect(find.byType(SystemContextMenu), findsNothing);
        expect(find.text('Copy'), findsOneWidget);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );
  });

  group('selection on iOS', () {
    testWidgets(
      'a double tap selects a word and shows bar-and-ball handles',
      (tester) async {
        final controller = await _pumpWithText(tester, 'alpha beta gamma');

        await tester.tapAt(textOffsetToPosition(tester, 8));
        await tester.pump(const Duration(milliseconds: 50));
        await tester.tapAt(textOffsetToPosition(tester, 8));
        await tester.pumpAndSettle();

        expect(
          controller.selection,
          const TextSelection(baseOffset: 6, extentOffset: 10),
        );
        expect(findHandlePainter(_ios), findsNWidgets(2));
        expect(findHandlePainter(_android), findsNothing);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );

    testWidgets(
      'a long press drag shows the bordered magnifier',
      (tester) async {
        await _pumpWithText(tester, 'alpha beta gamma');

        final gesture = await tester.startGesture(
          textOffsetToPosition(tester, 2),
        );
        await tester.pump(kLongPressTimeout + kPressTimeout);
        await gesture.moveTo(textOffsetToPosition(tester, 8));
        await tester.pumpAndSettle();

        final magnifier = tester.widget<RawMagnifier>(
          find.byType(RawMagnifier),
        );
        final shape = magnifier.decoration.shape as RoundedRectangleBorder;
        expect(
          shape.side.color,
          testTheme.palette(Brightness.light).primaryControl,
        );
        expect(magnifier.decoration.opacity, 1);

        double opacity() => tester
            .widget<RawMagnifier>(find.byType(RawMagnifier))
            .decoration
            .opacity;

        // Far below the line the lens fades out, and it returns on the way
        // back.
        await gesture.moveTo(
          textOffsetToPosition(tester, 8) + const Offset(0, 200),
        );
        await tester.pumpAndSettle();
        expect(opacity(), 0);
        await gesture.moveTo(textOffsetToPosition(tester, 10));
        await tester.pumpAndSettle();
        expect(opacity(), 1);

        await gesture.up();
        await tester.pumpAndSettle();
        expect(find.byType(RawMagnifier), findsNothing);
      },
      variant: TargetPlatformVariant.only(TargetPlatform.iOS),
    );
  });

  group('right to left', () {
    testWidgets('selects an Arabic word with handles and aligns to the right', (
      tester,
    ) async {
      final controller = await _pumpWithText(
        tester,
        'مرحبا بالعالم',
        textDirection: TextDirection.rtl,
      );

      final field = tester.getRect(find.byType(ZamTextField));
      expect(field.right, 360);

      await tester.longPressAt(textOffsetToPosition(tester, 2));
      await tester.pumpAndSettle();

      expect(
        controller.selection,
        const TextSelection(baseOffset: 0, extentOffset: 5),
      );
      expect(findHandlePainter(_android), findsNWidgets(2));
      expect(find.text('Copy'), findsOneWidget);
    });

    testWidgets('puts the placeholder at the start edge', (tester) async {
      await pumpField(
        tester,
        const ZamTextField(placeholderText: 'بريد', style: _style),
        textDirection: TextDirection.rtl,
      );

      final field = tester.getRect(find.byType(ZamTextField));
      final placeholder = tester.renderObject<RenderParagraph>(
        find.text('بريد'),
      );
      final glyphs = placeholder.getBoxesForSelection(
        const TextSelection(baseOffset: 0, extentOffset: 4),
      );
      final right = placeholder.localToGlobal(Offset(glyphs.first.right, 0)).dx;
      expect(right, closeTo(field.right, 0.01));
    });
  });

  group('large text scale', () {
    testWidgets('grows with the text scale and wraps the placeholder', (
      tester,
    ) async {
      await pumpField(
        tester,
        const ZamTextField(
          placeholderText: 'A placeholder long enough to wrap',
          style: _style,
        ),
        textScaler: const TextScaler.linear(3),
      );

      expect(tester.takeException(), isNull);
      final height = tester.getSize(find.byType(ZamTextField)).height;
      expect(height, greaterThan(60));
      expect(height % 60, 0);

      await tester.enterText(find.byType(ZamTextField), 'a');
      await tester.pump();
      expect(tester.getSize(find.byType(ZamTextField)).height, height);
      expect(tester.getSize(find.byType(EditableText)).height, 60);
    });

    testWidgets('selection still shows handles at a large scale', (
      tester,
    ) async {
      final controller = TextEditingController(text: 'alpha beta');
      addTearDown(controller.dispose);
      await pumpField(
        tester,
        ZamTextField(controller: controller, style: _style, maxLines: null),
        textScaler: const TextScaler.linear(3),
      );

      await tester.longPressAt(textOffsetToPosition(tester, 8));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(controller.selection.textInside(controller.text), 'beta');
      expect(findHandlePainter(_android), findsNWidgets(2));
    });
  });

  group('semantics', () {
    testWidgets('is one text field node with label and hint', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpField(
        tester,
        const ZamTextField(
          placeholderText: 'name@example.com',
          semanticsLabel: 'Email',
          style: _style,
          maxLength: 10,
        ),
      );

      expect(
        tester.getSemantics(find.byType(ZamTextField)),
        matchesSemantics(
          isTextField: true,
          isFocusable: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
          hasFocusAction: true,
          hasImplicitScrolling: true,
          label: 'Email',
          hint: 'name@example.com',
          maxValueLength: 10,
          currentValueLength: 0,
          textDirection: TextDirection.ltr,
        ),
      );

      await tester.enterText(find.byType(ZamTextField), 'abc');
      await tester.pump();
      final data = tester
          .getSemantics(find.byType(ZamTextField))
          .getSemanticsData();
      expect(data.hint, isEmpty);
      expect(data.value, 'abc');
      expect(data.currentValueLength, 3);
      handle.dispose();
    });

    testWidgets('the tap action focuses the field', (tester) async {
      final handle = tester.ensureSemantics();
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      await pumpField(
        tester,
        ZamTextField(focusNode: focusNode, semanticsLabel: 'Name'),
      );

      final node = tester.getSemantics(find.byType(ZamTextField));
      node.owner!.performAction(
        node.id,
        SemanticsAction.tap,
      );
      await tester.pump();

      expect(focusNode.hasFocus, isTrue);

      node.owner!.performAction(
        node.id,
        SemanticsAction.tap,
      );
      await tester.pump();
      expect(focusNode.hasFocus, isTrue);
      handle.dispose();
    });

    testWidgets('reports disabled and invalid states', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpField(
        tester,
        const ZamTextField(
          semanticsLabel: 'Email',
          enabled: false,
          semanticsValidationResult: SemanticsValidationResult.invalid,
        ),
      );

      final data = tester
          .getSemantics(find.byType(ZamTextField))
          .getSemanticsData();
      expect(data.flagsCollection.isEnabled, Tristate.isFalse);
      expect(data.validationResult, SemanticsValidationResult.invalid);
      expect(data.hasAction(SemanticsAction.tap), isFalse);
      handle.dispose();
    });
  });

  testWidgets('read-only text can be selected but not cut', (tester) async {
    final controller = TextEditingController(text: 'alpha beta');
    addTearDown(controller.dispose);
    await pumpField(
      tester,
      ZamTextField(controller: controller, style: _style, readOnly: true),
    );

    await tester.longPressAt(textOffsetToPosition(tester, 8));
    await tester.pumpAndSettle();

    expect(controller.selection.textInside(controller.text), 'beta');
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Cut'), findsNothing);
  });
}
