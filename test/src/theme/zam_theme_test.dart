import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  const primary = Color(0xFF5FA88E);

  group('ZamThemeData', () {
    test('creates configurable color tokens from a seed color', () {
      final colors = ZamColorTokens.fromSeed(primary: primary);

      expect(colors.primary, primary);
      expect(colors.light.background, const Color(0xFFFFFFFF));
      expect(colors.dark.background, const Color(0xFF09090B));
      expect(colors.oled.background, const Color(0xFF000000));
      expect(
        colors.forBrightness(Brightness.light).card,
        const Color(0xFFFFFFFF),
      );
      expect(
        colors.forBrightness(Brightness.dark).card,
        const Color(0xFF18181B),
      );
    });

    test('status colors pair each role with a readable foreground', () {
      for (final surface in [
        testTheme.colors.light,
        testTheme.colors.dark,
        testTheme.colors.oled,
      ]) {
        final status = surface.status;
        for (final (color, on) in [
          (status.success, status.onSuccess),
          (status.warning, status.onWarning),
          (status.info, status.onInfo),
          (status.error, status.onError),
        ]) {
          expect(on, ZamColorUtils.readableOn(color));
        }
        expect(status.error, surface.destructive);
      }
    });

    testWidgets('context.zamStatus follows the active brightness', (
      tester,
    ) async {
      late ZamStatusColors status;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          themeMode: ZamThemeMode.dark,
          home: Builder(
            builder: (context) {
              status = context.zamStatus;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(status, testTheme.colors.dark.status);
      expect(status, isNot(testTheme.colors.light.status));
    });

    test('builds shadcn theme data from configured tokens', () {
      final light = testTheme.toShadThemeData(Brightness.light);
      final dark = testTheme.toShadThemeData(Brightness.dark, isOled: true);

      expect(light.colorScheme.primary, testTheme.colors.primary);
      expect(light.colorScheme.background, testTheme.colors.light.background);
      expect(dark.colorScheme.background, testTheme.colors.oled.background);
      expect(light.brightness, Brightness.light);
      expect(dark.brightness, Brightness.dark);
    });

    test('copyWith preserves unchanged fields', () {
      final copy = testTheme.copyWith();

      expect(copy.colors, same(testTheme.colors));
      expect(copy.typography, same(testTheme.typography));
      expect(copy.icons, same(testTheme.icons));
      expect(copy.spacing, same(testTheme.spacing));
      expect(copy.radius, same(testTheme.radius));
      expect(copy.strokes, same(testTheme.strokes));
      expect(copy.opacities, same(testTheme.opacities));
      expect(copy.shadows, same(testTheme.shadows));
      expect(copy.motion, same(testTheme.motion));
    });

    test('copyWith replaces specified fields', () {
      final newColors = ZamColorTokens.fromSeed(
        primary: const Color(0xFF5FA88E),
      );
      final copy = testTheme.copyWith(colors: newColors);

      expect(copy.colors, same(newColors));
      expect(copy.colors.primary, const Color(0xFF5FA88E));
      expect(copy.typography, same(testTheme.typography));
    });

    test('copyWith recomputes derived insets and sizes', () {
      const newSpacing = ZamSpacingTokens(step: 5);
      final copy = testTheme.copyWith(spacing: newSpacing);

      expect(copy.spacing.md, 20);
      expect(copy.insets.screen.left, 20);
      expect(copy.sizes.iconSm, copy.spacing.md);
    });

    test('explicit foregrounds override the computed ones', () {
      final base = ZamColorTokens.fromSeed(primary: const Color(0xFF7FB2E5));
      final tokens = ZamColorTokens(
        primary: base.primary,
        primaryForeground: const Color(0xFF0B0E14),
        light: base.light,
        dark: ZamSurfaceColors(
          background: base.dark.background,
          foreground: base.dark.foreground,
          card: base.dark.card,
          muted: base.dark.muted,
          mutedForeground: base.dark.mutedForeground,
          border: base.dark.border,
          input: base.dark.input,
          destructive: const Color(0xFFF07A6A),
          destructiveForeground: const Color(0xFF0B0E14),
        ),
        oled: base.oled,
      );
      final scheme = ZamThemeData(
        colors: tokens,
        typography: const ZamTypographyTokens(fontFamily: 'Test Sans'),
        icons: testTheme.icons,
      ).toShadThemeData(Brightness.dark).colorScheme;

      expect(scheme.primaryForeground, const Color(0xFF0B0E14));
      expect(scheme.destructiveForeground, const Color(0xFF0B0E14));
    });
  });

  group('ZamTheme Context', () {
    testWidgets('provides theme data through ZamTheme context extensions', (
      tester,
    ) async {
      await tester.pumpApp(
        Builder(
          builder: (context) {
            return Text(
              context.zamTypography.fontFamily,
              style: context.zamTypography.body(context),
            );
          },
        ),
      );

      expect(find.text('Test Sans'), findsOneWidget);
    });

    testWidgets("zam_ui exports keep Flutter's TextDirection", (tester) async {
      await tester.pumpApp(
        const Directionality(
          textDirection: TextDirection.rtl,
          child: Text('RTL'),
        ),
      );

      expect(
        tester.widget<Directionality>(find.byType(Directionality).last),
        isA<Directionality>().having(
          (d) => d.textDirection,
          'textDirection',
          TextDirection.rtl,
        ),
      );
    });

    testWidgets('ZamApp wires ZamTheme and ShadApp theme data', (tester) async {
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          home: Builder(
            builder: (context) {
              return Text(
                context.zamTypography.fontFamily,
                style: context.zamTypography.body(context),
              );
            },
          ),
        ),
      );

      final shadTheme = tester.widget<ShadApp>(find.byType(ShadApp));

      expect(find.text('Test Sans'), findsOneWidget);
      expect(shadTheme.theme!.colorScheme.primary, testTheme.colors.primary);
    });

    testWidgets('ZamApp scopes the dark ZamThemeData in dark mode', (
      tester,
    ) async {
      final darkTheme = testTheme.copyWith(
        typography: const ZamTypographyTokens(fontFamily: 'Dark Sans'),
      );
      String? builderFamily;

      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          darkTheme: darkTheme,
          themeMode: ZamThemeMode.dark,
          builder: (context, child) {
            builderFamily = context.zamTypography.fontFamily;
            return child!;
          },
          home: Builder(
            builder: (context) => Text(context.zamTypography.fontFamily),
          ),
        ),
      );

      expect(find.text('Dark Sans'), findsOneWidget);
      expect(builderFamily, 'Dark Sans');
    });
  });
}
