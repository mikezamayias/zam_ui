import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

Widget _reducedMotion(Widget child) => MediaQuery(
  data: const MediaQueryData(disableAnimations: true),
  child: child,
);

void main() {
  group('ZamSpinner', () {
    testWidgets('spins through shad with token defaults', (tester) async {
      await tester.pumpApp(const Center(child: ZamSpinner()));

      final spinner = tester.widget<ShadSpinner>(find.byType(ShadSpinner));
      expect(spinner.size, testTheme.sizes.iconSm);
      expect(spinner.strokeWidth, testTheme.strokes.progress);
      expect(tester.getSize(find.byType(ShadSpinner)).width, spinner.size);
    });

    testWidgets('passes its size, color and stroke width on', (tester) async {
      const color = Color(0xFFAA3366);
      await tester.pumpApp(
        const Center(
          child: ZamSpinner(size: 30, color: color, strokeWidth: 5),
        ),
      );

      final spinner = tester.widget<ShadSpinner>(find.byType(ShadSpinner));
      expect(spinner.size, 30);
      expect(spinner.color, color);
      expect(spinner.strokeWidth, 5);
    });

    testWidgets('announces its label as a live region', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        const Center(child: ZamSpinner(semanticLabel: 'Saving')),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Saving'));
      expect(node.label, 'Saving');
      expect(node.getSemanticsData().flagsCollection.isLiveRegion, isTrue);
      expect(node.role, SemanticsRole.loadingSpinner);
      handle.dispose();
    });

    testWidgets('is silent for screen readers without a label', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(const Center(child: ZamSpinner()));

      expect(find.bySemanticsLabel(RegExp('.')), findsNothing);
      expect(
        find.semantics.byPredicate(
          (node) => node.role == SemanticsRole.loadingSpinner,
        ),
        findsNothing,
      );
      handle.dispose();
    });

    testWidgets('keeps animating frames without reduced motion', (
      tester,
    ) async {
      await tester.pumpApp(const Center(child: ZamSpinner()));
      await tester.pump(const Duration(milliseconds: 100));

      expect(tester.binding.hasScheduledFrame, isTrue);
    });

    testWidgets('draws a still arc and schedules no frames under reduced '
        'motion', (tester) async {
      await tester.pumpApp(
        _reducedMotion(const Center(child: ZamSpinner(size: 24))),
      );
      await tester.pumpAndSettle();

      expect(find.byType(ShadSpinner), findsNothing);
      expect(tester.getSize(find.byType(CustomPaint).last), const Size(24, 24));
      expect(tester.binding.hasScheduledFrame, isFalse);

      final paint = find
          .descendant(
            of: find.byType(ZamSpinner),
            matching: find.byType(CustomPaint),
          )
          .first;
      expect(
        tester.renderObject<RenderBox>(paint),
        paints
          ..circle()
          ..arc(),
      );
    });

    testWidgets('repaints the still arc when its color changes', (
      tester,
    ) async {
      Widget build(Color color) => _reducedMotion(
        Center(child: ZamSpinner(color: color)),
      );
      await tester.pumpApp(build(const Color(0xFF112233)));
      await tester.pumpApp(build(const Color(0xFF332211)));
      await tester.pumpApp(build(const Color(0xFF332211)));

      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps its label under reduced motion', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        _reducedMotion(
          const Center(child: ZamSpinner(semanticLabel: 'Loading')),
        ),
      );

      expect(find.bySemanticsLabel('Loading'), findsOneWidget);
      handle.dispose();
    });

    testWidgets('draws the same in right-to-left layouts', (tester) async {
      await tester.pumpApp(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: Center(child: ZamSpinner(size: 20)),
        ),
      );

      expect(tester.getSize(find.byType(ShadSpinner)), const Size(20, 20));
      expect(tester.takeException(), isNull);
    });
  });
}
