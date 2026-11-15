import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

Future<void> _pumpPill(
  WidgetTester tester, {
  required String label,
  double textScale = 1,
}) async {
  tester.view.physicalSize = const Size(800, 600);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: TextScaler.linear(textScale)),
        child: Center(
          child: ZamFilterPill(label: label, selected: false, onTap: () {}),
        ),
      ),
    ),
  );
}

/// The global rect of the label's laid-out glyphs.
///
/// The paragraph's own box can be stretched by forwarded minimum constraints
/// while its text paints at the top, so the glyph boxes are what the eye sees.
Rect _glyphRect(WidgetTester tester, String label) {
  final paragraph = tester.renderObject<RenderParagraph>(find.text(label));
  final local = paragraph
      .getBoxesForSelection(
        TextSelection(baseOffset: 0, extentOffset: label.length),
      )
      .map((box) => box.toRect())
      .reduce((a, b) => a.expandToInclude(b));
  return local.shift(paragraph.localToGlobal(Offset.zero));
}

void _expectLabelCentred(WidgetTester tester, String label) {
  final pill = tester.getRect(find.byType(ZamFilterPill));
  final text = _glyphRect(tester, label);
  expect(text.center.dy, closeTo(pill.center.dy, 0.5));
  expect(text.center.dx, closeTo(pill.center.dx, 0.5));
}

void main() {
  group('ZamFilterPill label', () {
    testWidgets('fills the minimum tap target around a short label', (
      tester,
    ) async {
      await _pumpPill(tester, label: 'A');

      final pill = tester.getSize(find.byType(ZamFilterPill));
      final minTarget = testTheme.sizes.minTapTarget;
      expect(pill, Size(minTarget, minTarget));
    });

    for (final scale in [1.0, 1.5, 3.0]) {
      testWidgets('is centred both ways at text scale $scale', (tester) async {
        await _pumpPill(tester, label: 'A', textScale: scale);

        _expectLabelCentred(tester, 'A');
      });
    }

    testWidgets('hugs a label taller than the minimum at a large text scale', (
      tester,
    ) async {
      await _pumpPill(tester, label: 'All', textScale: 3);

      final pill = tester.getSize(find.byType(ZamFilterPill));
      final text = _glyphRect(tester, 'All').size;
      final padding = testTheme.spacing(1.5) * 2;
      expect(pill.height, greaterThan(testTheme.sizes.minTapTarget));
      expect(pill.height, closeTo(text.height + padding, 0.5));
    });
  });
}
