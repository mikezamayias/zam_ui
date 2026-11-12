import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import 'text_test_support.dart';

const _text = 'alpha beta gamma';
const _style = TextStyle(fontSize: 20, height: 1);

// The center of the glyph at [index] in the one-line text, in 20 px glyphs.
Offset _glyph(WidgetTester tester, int index, {bool rtl = false}) {
  final rect = tester.getRect(find.text(_text));
  final dx = 20.0 * index + 10;
  return Offset(rtl ? rect.right - dx : rect.left + dx, rect.center.dy);
}

Future<void> _pump(
  WidgetTester tester, {
  TextDirection textDirection = TextDirection.ltr,
  TextScaler textScaler = TextScaler.noScaling,
  bool systemContextMenu = false,
}) {
  return pumpField(
    tester,
    const ZamSelectionArea(child: Text(_text, style: _style)),
    width: 340,
    textDirection: textDirection,
    textScaler: textScaler,
    systemContextMenu: systemContextMenu,
  );
}

void main() {
  testWidgets('a long press selects a word with teardrop handles', (
    tester,
  ) async {
    final clipboard = FakeClipboard()..install(tester);
    await _pump(tester);

    await tester.longPressAt(_glyph(tester, 7));
    await tester.pumpAndSettle();

    expect(findHandlePainter('_ZamAndroidHandlePainter'), findsNWidgets(2));
    expect(find.text('Copy'), findsOneWidget);
    expect(find.text('Select All'), findsOneWidget);
    expect(find.text('Cut'), findsNothing);
    expect(find.text('Paste'), findsNothing);

    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();
    expect(clipboard.text, 'beta');
  });

  testWidgets('select all then copy takes the whole text', (tester) async {
    final clipboard = FakeClipboard()..install(tester);
    await _pump(tester);

    await tester.longPressAt(_glyph(tester, 7));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Select All'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();

    expect(clipboard.text, _text);
  });

  testWidgets('dragging a handle shows the magnifier', (tester) async {
    await _pump(tester);

    await tester.longPressAt(_glyph(tester, 7));
    await tester.pumpAndSettle();
    final endHandle = tester.getCenter(
      findHandlePainter('_ZamAndroidHandlePainter').last,
    );
    final gesture = await tester.startGesture(endHandle);
    await tester.pump();
    await tester.pump();
    for (var i = 0; i < 4; i++) {
      await gesture.moveBy(const Offset(15, 0));
      await tester.pump();
    }

    expect(find.byType(RawMagnifier), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();
    expect(find.byType(RawMagnifier), findsNothing);
  });

  testWidgets(
    'uses bar-and-ball handles and shad menu on iOS',
    (tester) async {
      FakeClipboard().install(tester);
      await _pump(tester, systemContextMenu: true);

      await tester.longPressAt(_glyph(tester, 7));
      await tester.pumpAndSettle();

      expect(findHandlePainter('_ZamIosHandlePainter'), findsNWidgets(2));
      expect(find.byType(SystemContextMenu), findsNothing);
      expect(find.text('Copy'), findsOneWidget);
    },
    variant: TargetPlatformVariant.only(TargetPlatform.iOS),
  );

  testWidgets('selects a word in right-to-left text', (tester) async {
    final clipboard = FakeClipboard()..install(tester);
    await _pump(tester, textDirection: TextDirection.rtl);

    expect(tester.getRect(find.text(_text)).right, 360);
    // Latin words keep their order inside a right-to-left paragraph, so the
    // glyph at 2 from the left edge still sits in "alpha".
    final rect = tester.getRect(find.text(_text));
    await tester.longPressAt(Offset(rect.left + 50, rect.center.dy));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();

    expect(clipboard.text, 'alpha');
    expect(findHandlePainter('_ZamAndroidHandlePainter'), findsNothing);
  });

  testWidgets('works at a large text scale', (tester) async {
    final clipboard = FakeClipboard()..install(tester);
    await _pump(tester, textScaler: const TextScaler.linear(2));

    expect(tester.takeException(), isNull);
    final rect = tester.getRect(find.text(_text));
    // At twice the size each glyph is 40 wide, so the 340 wide box holds
    // "alpha", "beta" and "gamma" on three lines of 40.
    expect(rect.height, 120);
    await tester.longPressAt(Offset(rect.left + 60, rect.top + 60));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy'));
    await tester.pumpAndSettle();

    expect(clipboard.text, 'beta');
  });

  testWidgets('takes a focus node', (tester) async {
    final focusNode = FocusNode();
    addTearDown(focusNode.dispose);
    await pumpField(
      tester,
      ZamSelectionArea(focusNode: focusNode, child: const Text(_text)),
    );

    expect(
      tester.widget<SelectableRegion>(find.byType(SelectableRegion)).focusNode,
      focusNode,
    );
  });
}
