// The equality tests build tokens at runtime, as apps that build a theme in
// build() do; const instances would be identical and hide missing equality.
// ignore_for_file: prefer_const_constructors

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

ZamThemeData _theme({Color primary = const Color(0xFF2F55BF)}) => ZamThemeData(
  colors: ZamColorTokens.fromSeed(primary: primary),
  typography: const ZamTypographyTokens(fontFamily: 'Test Sans'),
  icons: testTheme.icons,
);

class _Counter extends StatelessWidget {
  const _Counter(this.onBuild);

  final VoidCallback onBuild;

  @override
  Widget build(BuildContext context) {
    ZamTheme.of(context);
    onBuild();
    return const SizedBox();
  }
}

void main() {
  group('ZamThemeData equality', () {
    test('themes built from non-constant tokens are equal', () {
      ZamThemeData build() => ZamThemeData(
        colors: ZamColorTokens.fromSeed(primary: const Color(0xFF2F55BF)),
        typography: ZamTypographyTokens(fontFamily: 'Test Sans'),
        icons: ZamIconSet(
          info: testTheme.icons.info,
          success: testTheme.icons.success,
          warning: testTheme.icons.warning,
          error: testTheme.icons.error,
          back: testTheme.icons.back,
          chevronRight: testTheme.icons.chevronRight,
        ),
        radius: ZamRadiusTokens(),
        strokes: ZamStrokeTokens(),
        opacities: ZamOpacityTokens(),
        shadows: ZamShadowTokens(),
        motion: ZamMotionTokens(),
      );

      expect(build(), build());
      expect(build().hashCode, build().hashCode);
    });

    test('equal inputs are equal with equal hashCode', () {
      final a = _theme();
      final b = _theme();

      expect(a, b);
      expect(a.hashCode, b.hashCode);
    });

    test('changing one token makes themes unequal', () {
      expect(_theme(), isNot(_theme(primary: const Color(0xFF000001))));
      expect(
        _theme(),
        isNot(
          _theme().copyWith(
            typography: const ZamTypographyTokens(
              fontFamily: 'Test Sans',
              bodySize: 15,
            ),
          ),
        ),
      );
    });

    testWidgets('equal rebuilt theme does not rebuild dependents', (
      tester,
    ) async {
      var builds = 0;
      final child = _Counter(() => builds++);

      await tester.pumpWidget(ZamTheme(data: _theme(), child: child));
      expect(builds, 1);
      await tester.pumpWidget(ZamTheme(data: _theme(), child: child));
      expect(builds, 1);
      await tester.pumpWidget(
        ZamTheme(
          data: _theme(primary: const Color(0xFF000001)),
          child: child,
        ),
      );
      expect(builds, 2);
    });
  });

  group('ZamTypographyTokens scale', () {
    testWidgets('defaults are unchanged', (tester) async {
      const t = ZamTypographyTokens(fontFamily: 'x');
      expect(t.displaySize, 28);
      expect(t.bodySize, 14);
      expect(t.monoLabelSize, 10);
      expect(t.bodyLineHeight, 1.5);
      expect(t.inputLineHeight, 1.58);
      expect(t.bold, FontWeight.w700);
      expect(t.light, FontWeight.w300);
    });

    testWidgets('overrides change the matching style', (tester) async {
      late TextStyle body;
      late TextStyle display;
      final theme = testTheme.copyWith(
        typography: const ZamTypographyTokens(
          fontFamily: 'Test Sans',
          bodySize: 20,
          bold: FontWeight.w900,
        ),
      );
      await tester.pumpApp(
        Builder(
          builder: (context) {
            body = theme.typography.body(context);
            display = theme.typography.display(context);
            return const SizedBox();
          },
        ),
        theme: theme,
      );
      expect(body.fontSize, 20);
      expect(display.fontWeight, FontWeight.w900);
    });
  });

  group('toast status colors', () {
    for (final brightness in Brightness.values) {
      test('success, info, warning, error differ in $brightness', () {
        final backgrounds = [
          for (final v in [
            ZamToastVariant.success,
            ZamToastVariant.info,
            ZamToastVariant.warning,
            ZamToastVariant.error,
          ])
            testTheme.toastStyle(brightness, v).background,
        ];
        expect(backgrounds.toSet(), hasLength(4));
      });
    }

    test('dark defaults use the lighter status values', () {
      final colors = ZamColorTokens.fromSeed(primary: const Color(0xFF2F55BF));
      expect(colors.light.success, const Color(0xFF15803D));
      expect(colors.dark.success, const Color(0xFF4ADE80));
      expect(colors.oled.info, const Color(0xFF60A5FA));
    });
  });

  group('ZamDialog', () {
    testWidgets('message dialog uses ZamColorUtils.barrier', (tester) async {
      late BuildContext ctx;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
      );
      unawaited(ZamDialog.showMessage(context: ctx, title: 't', message: 'm'));
      await tester.pumpAndSettle();
      final barrier = tester.widget<ModalBarrier>(
        find.byType(ModalBarrier).last,
      );
      expect(barrier.color, ZamColorUtils.barrier);
    });

    testWidgets('confirmation dialog lays out on a wide screen', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      late BuildContext ctx;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
      );
      unawaited(
        ZamDialog.showConfirmation(context: ctx, title: 't', message: 'm'),
      );
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
      expect(find.text('Confirm'), findsOneWidget);
      expect(find.text('Cancel'), findsOneWidget);
    });
  });

  group('toast duration', () {
    Future<Duration> shown(WidgetTester tester, ZamToastVariant v) async {
      late BuildContext ctx;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            ctx = context;
            return const SizedBox();
          },
        ),
      );
      ZamToast.show(ctx, title: 'hi', variant: v);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      return tester.widget<ShadToast>(find.byType(ShadToast)).displayDuration!;
    }

    testWidgets('progress uses progressToast', (tester) async {
      expect(
        await shown(tester, ZamToastVariant.progress),
        testTheme.motion.progressToast,
      );
      await tester.pumpAndSettle(const Duration(seconds: 11));
    });

    testWidgets('others use toastDefault', (tester) async {
      expect(
        await shown(tester, ZamToastVariant.info),
        testTheme.motion.toastDefault,
      );
      await tester.pumpAndSettle(const Duration(seconds: 11));
    });
  });
}
