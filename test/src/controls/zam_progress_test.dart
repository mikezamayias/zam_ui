import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

Widget _bar(ZamProgress progress) =>
    Center(child: SizedBox(width: 200, child: progress));

ShadProgress _shad(WidgetTester tester) =>
    tester.widget<ShadProgress>(find.byType(ShadProgress));

void main() {
  final palette = testTheme.palette(Brightness.light);

  group('ZamProgress', () {
    testWidgets('fills the given fraction from the start edge', (
      tester,
    ) async {
      await tester.pumpApp(_bar(const ZamProgress(value: 0.25)));

      final fill = find.descendant(
        of: find.byType(ShadProgress),
        matching: find.byType(FractionallySizedBox),
      );
      expect(tester.widget<FractionallySizedBox>(fill).widthFactor, 0.25);
      final bar = tester.getRect(find.byType(ShadProgress));
      expect(tester.getRect(fill).left, bar.left);
    });

    testWidgets('fills from the right edge in right-to-left layouts', (
      tester,
    ) async {
      await tester.pumpApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: _bar(const ZamProgress(value: 0.25)),
        ),
      );

      final fill = find.descendant(
        of: find.byType(ShadProgress),
        matching: find.byType(FractionallySizedBox),
      );
      expect(
        tester.getRect(fill).right,
        tester.getRect(find.byType(ShadProgress)).right,
      );
    });

    testWidgets(
      'defaults to the control fill, the secondary track and tokens',
      (
        tester,
      ) async {
        await tester.pumpApp(_bar(const ZamProgress(value: 0.5)));

        final shad = _shad(tester);
        expect(shad.color, palette.primaryControl);
        expect(shad.backgroundColor, palette.secondary);
        expect(shad.minHeight, testTheme.spacing.md);
        expect(shad.borderRadius, testTheme.radius.pill);
      },
    );

    testWidgets('takes color, track, height and radius overrides', (
      tester,
    ) async {
      const fill = Color(0xFF112233);
      const track = Color(0xFF445566);
      const radius = BorderRadius.all(Radius.circular(2));
      await tester.pumpApp(
        _bar(
          const ZamProgress(
            value: 0.5,
            color: fill,
            backgroundColor: track,
            minHeight: 6,
            borderRadius: radius,
          ),
        ),
      );

      final shad = _shad(tester);
      expect(shad.color, fill);
      expect(shad.backgroundColor, track);
      expect(shad.minHeight, 6);
      expect(shad.borderRadius, radius);
      expect(tester.getSize(find.byType(ShadProgress)).height, 6);
    });

    testWidgets('is one progress node with label and percentage value', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        _bar(const ZamProgress(value: 0.456, semanticLabel: 'Upload')),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Upload'));
      expect(node.label, 'Upload');
      expect(node.value, '46%');
      handle.dispose();
    });

    testWidgets('prefers the given semantic value', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        _bar(
          const ZamProgress(
            value: 0.5,
            semanticLabel: 'Step',
            semanticValue: '2 of 4',
          ),
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Step')).value,
        '2 of 4',
      );
      handle.dispose();
    });

    testWidgets('clamps a value outside 0 to 1', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        _bar(const ZamProgress(value: 1.7, semanticLabel: 'Over')),
      );

      expect(tester.getSemantics(find.bySemanticsLabel('Over')).value, '100%');
      final fill = find.descendant(
        of: find.byType(ShadProgress),
        matching: find.byType(FractionallySizedBox),
      );
      expect(tester.widget<FractionallySizedBox>(fill).widthFactor, 1);
      handle.dispose();
    });

    testWidgets('an indeterminate bar has a label and no value', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(_bar(const ZamProgress(semanticLabel: 'Loading')));

      final node = tester.getSemantics(find.bySemanticsLabel('Loading'));
      expect(node.value, isEmpty);
      expect(_shad(tester).value, isNull);
      expect(tester.binding.hasScheduledFrame, isTrue);
      handle.dispose();
    });

    testWidgets('an indeterminate bar is a still segment under reduced '
        'motion', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(
        const MediaQuery(
          data: MediaQueryData(disableAnimations: true),
          child: Center(
            child: SizedBox(
              width: 200,
              child: ZamProgress(semanticLabel: 'Loading'),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(_shad(tester).value, isNotNull);
      expect(tester.binding.hasScheduledFrame, isFalse);
      final node = tester.getSemantics(find.bySemanticsLabel('Loading'));
      expect(node.value, isEmpty);
      handle.dispose();
    });
  });
}
