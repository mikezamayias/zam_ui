import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

void main() {
  final controls = ZamTextSelectionControls();

  group('Android shape', () {
    test('is a 22 px teardrop anchored at the selection edge', () {
      expect(controls.getHandleSize(20), const Size.square(22));
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.left, 20),
        const Offset(22, 0),
      );
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.right, 20),
        Offset.zero,
      );
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.collapsed, 20),
        const Offset(11, -4),
      );
    });

    testWidgets('rotates per handle type and forwards taps', (tester) async {
      var taps = 0;
      await tester.pumpApp(
        Builder(
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final type in TextSelectionHandleType.values)
                controls.buildHandle(context, type, 20, () => taps++),
            ],
          ),
        ),
      );

      final turns = tester
          .widgetList<Transform>(find.byType(Transform))
          .map((t) => t.transform.getRotation().entry(1, 0))
          .toList();
      // left is a quarter turn, right is upright, collapsed is an eighth.
      expect(turns, hasLength(2));
      expect(turns.first, closeTo(1, 1e-9));
      expect(turns.last, closeTo(0.7071, 1e-4));

      await tester.tap(find.byType(GestureDetector).first);
      expect(taps, 1);
    });
  });

  group('iOS shape', () {
    test('is a bar as tall as the line plus the ball', () {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      expect(controls.getHandleSize(20), const Size(12, 30.5));
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.left, 20),
        const Offset(6, 30.5),
      );
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.right, 20),
        const Offset(6, 20),
      );
      expect(
        controls.getHandleAnchor(TextSelectionHandleType.collapsed, 20),
        const Offset(6, 25.25),
      );
    });

    testWidgets('draws no collapsed handle and flips the end handle', (
      tester,
    ) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      await tester.pumpApp(
        Builder(
          builder: (context) => Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final type in TextSelectionHandleType.values)
                controls.buildHandle(context, type, 20),
            ],
          ),
        ),
      );

      expect(find.byType(CustomPaint), findsNWidgets(2));
      expect(find.byType(Transform), findsOneWidget);
      expect(
        tester.renderObject(find.byType(CustomPaint).first),
        paints..path(color: testTheme.palette(Brightness.light).primaryControl),
      );
      debugDefaultTargetPlatformOverride = null;
    });
  });

  testWidgets('falls back to the default theme without a ZamTheme', (
    tester,
  ) async {
    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: Builder(
          builder: (context) =>
              controls.buildHandle(context, TextSelectionHandleType.right, 20),
        ),
      ),
    );

    final fallback = ZamThemeData.fallback().palette(Brightness.light);
    expect(
      tester.renderObject(find.byType(CustomPaint)),
      paints..path(color: fallback.primaryControl),
    );
  });

  test('desktop and Fuchsia use the teardrop shape', () {
    for (final platform in [
      TargetPlatform.fuchsia,
      TargetPlatform.linux,
      TargetPlatform.windows,
    ]) {
      debugDefaultTargetPlatformOverride = platform;
      expect(controls.getHandleSize(20), const Size.square(22));
    }
    debugDefaultTargetPlatformOverride = null;
  });

  testWidgets('a field shows no magnifier off iOS and Android', (
    tester,
  ) async {
    await tester.pumpApp(const ZamTextField());

    final editable = tester.widget<EditableText>(find.byType(EditableText));
    final config = editable.magnifierConfiguration;
    final context = tester.element(find.byType(EditableText));
    for (final platform in [
      TargetPlatform.fuchsia,
      TargetPlatform.linux,
      TargetPlatform.macOS,
      TargetPlatform.windows,
    ]) {
      debugDefaultTargetPlatformOverride = platform;
      expect(
        config.magnifierBuilder(
          context,
          MagnifierController(),
          ValueNotifier(MagnifierInfo.empty),
        ),
        isNull,
      );
    }
    debugDefaultTargetPlatformOverride = null;
    expect(config.shouldDisplayHandlesInMagnifier, isFalse);
  });
}
