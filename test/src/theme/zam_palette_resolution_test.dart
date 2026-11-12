import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

/// zam_ui 0.3.0's `ZamThemeData.toShadThemeData`, copied as the reference
/// that a theme without optional roles must still match.
ShadThemeData _v030ShadThemeData(
  ZamThemeData theme,
  Brightness brightness, {
  bool isOled = false,
}) {
  final colors = theme.colors;
  final tone = colors.forBrightness(brightness, isOled: isOled);
  final primaryForeground =
      colors.primaryForeground ?? ZamColorUtils.readableOn(colors.primary);
  final secondary = ZamColorUtils.mix(
    colors.primary,
    brightness == Brightness.dark ? colors.black : colors.white,
    brightness == Brightness.dark ? 0.7 : 0.85,
  );
  final destructiveForeground =
      tone.destructiveForeground ?? ZamColorUtils.readableOn(tone.destructive);
  final destructiveHover = tone.destructive.withValues(
    alpha: theme.opacities.nearlyOpaque,
  );
  return ShadThemeData(
    brightness: brightness,
    radius: theme.radius.lg,
    spacing: theme.spacing.toShadSpacing(),
    textTheme: ShadTextTheme(family: theme.typography.fontFamily),
    destructiveButtonTheme: ShadButtonTheme(
      backgroundColor: tone.destructive,
      hoverBackgroundColor: destructiveHover,
      pressedBackgroundColor: destructiveHover,
      foregroundColor: destructiveForeground,
      hoverForegroundColor: destructiveForeground,
      pressedForegroundColor: destructiveForeground,
    ),
    colorScheme: ShadColorScheme(
      background: tone.background,
      foreground: tone.foreground,
      card: tone.card,
      cardForeground: tone.foreground,
      popover: tone.card,
      popoverForeground: tone.foreground,
      primary: colors.primary,
      primaryForeground: primaryForeground,
      secondary: secondary,
      secondaryForeground: ZamColorUtils.readableOn(secondary),
      muted: tone.muted,
      mutedForeground: tone.mutedForeground,
      accent: colors.primary,
      accentForeground: primaryForeground,
      destructive: tone.destructive,
      destructiveForeground: destructiveForeground,
      border: tone.border,
      input: tone.input,
      ring: colors.primary,
      selection: colors.primary.withValues(alpha: theme.opacities.faint),
    ),
  );
}

String _hex(Color color) => color.toARGB32().toRadixString(16);

ZamThemeData _themeFor(ZamColorTokens colors, {bool oled = false}) =>
    ZamThemeData(
      colors: colors,
      typography: testTheme.typography,
      icons: testTheme.icons,
      oled: oled,
    );

ZamSurfaceColors _withRoles(ZamSurfaceColors base) => ZamSurfaceColors(
  background: base.background,
  foreground: base.foreground,
  card: base.card,
  muted: base.muted,
  mutedForeground: base.mutedForeground,
  border: base.border,
  input: base.input,
  destructive: base.destructive,
  destructiveForeground: base.destructiveForeground,
  success: base.success,
  warning: base.warning,
  info: base.info,
  cardForeground: const Color(0xFF010101),
  popover: const Color(0xFF020202),
  popoverForeground: const Color(0xFF030303),
  secondary: const Color(0xFF040404),
  secondaryForeground: const Color(0xFF050505),
  accent: const Color(0xFF060606),
  accentForeground: const Color(0xFF070707),
  ring: const Color(0xFF080808),
  selection: const Color(0x33090909),
  primaryText: const Color(0xFF0A0A0A),
  primaryControl: const Color(0xFF0B0B0B),
  mutedControl: const Color(0xFF0C0C0C),
  placeholderText: const Color(0xFF0D0D0D),
  destructiveText: const Color(0xFF0E0E0E),
);

ZamSurfaceColors _withAccent(ZamSurfaceColors base, Color accent) =>
    ZamSurfaceColors(
      background: base.background,
      foreground: base.foreground,
      card: base.card,
      muted: base.muted,
      mutedForeground: base.mutedForeground,
      border: base.border,
      input: base.input,
      destructive: base.destructive,
      accent: accent,
      secondary: accent,
    );

void main() {
  final seeds = <ZamColorTokens>[
    ZamColorTokens.fromSeed(primary: const Color(0xFF2F55BF)),
    ZamColorTokens.fromSeed(primary: const Color(0xFF7FB2E5)),
    ZamColorTokens.fromSeed(primary: const Color(0xFFFFD60A)),
    () {
      final base = ZamColorTokens.fromSeed(primary: const Color(0xFF5FA88E));
      return ZamColorTokens(
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
    }(),
  ];

  group('a theme without optional roles matches 0.3.0', () {
    for (final colors in seeds) {
      final theme = _themeFor(colors);
      for (final (brightness, isOled) in [
        (Brightness.light, false),
        (Brightness.dark, false),
        (Brightness.dark, true),
      ]) {
        final label = '${_hex(colors.primary)} $brightness oled $isOled';

        test('ShadColorScheme for $label', () {
          expect(
            theme.toShadThemeData(brightness, isOled: isOled).colorScheme,
            _v030ShadThemeData(
              theme,
              brightness,
              isOled: isOled,
            ).colorScheme,
          );
        });

        test('ShadThemeData, checkbox included, for $label', () {
          final actual = theme.toShadThemeData(brightness, isOled: isOled);
          final expected = _v030ShadThemeData(
            theme,
            brightness,
            isOled: isOled,
          );
          expect(actual.checkboxTheme, expected.checkboxTheme);
          expect(actual, expected);
        });
      }

      test('palette roles fall back to 0.3.0 values for '
          '${_hex(colors.primary)}', () {
        for (final brightness in Brightness.values) {
          final palette = theme.palette(brightness);
          final scheme = _v030ShadThemeData(theme, brightness).colorScheme;
          expect(palette.brightness, brightness);
          expect(palette.background, scheme.background);
          expect(palette.foreground, scheme.foreground);
          expect(palette.card, scheme.card);
          expect(palette.cardForeground, scheme.cardForeground);
          expect(palette.popover, scheme.popover);
          expect(palette.popoverForeground, scheme.popoverForeground);
          expect(palette.primary, scheme.primary);
          expect(palette.primaryForeground, scheme.primaryForeground);
          expect(palette.secondary, scheme.secondary);
          expect(palette.secondaryForeground, scheme.secondaryForeground);
          expect(palette.muted, scheme.muted);
          expect(palette.mutedForeground, scheme.mutedForeground);
          expect(palette.accent, scheme.accent);
          expect(palette.accentForeground, scheme.accentForeground);
          expect(palette.destructive, scheme.destructive);
          expect(palette.destructiveForeground, scheme.destructiveForeground);
          expect(palette.border, scheme.border);
          expect(palette.input, scheme.input);
          expect(palette.ring, scheme.ring);
          expect(palette.selection, scheme.selection);
          expect(palette.primaryText, scheme.primary);
          expect(palette.primaryControl, scheme.primary);
          expect(palette.mutedControl, scheme.mutedForeground);
          expect(palette.placeholderText, scheme.mutedForeground);
          expect(palette.destructiveText, scheme.destructive);
          expect(
            palette.status,
            colors.forBrightness(brightness).status,
          );
        }
      });
    }
  });

  group('explicit roles', () {
    final base = ZamColorTokens.fromSeed(primary: const Color(0xFF2F55BF));
    final colors = ZamColorTokens(
      primary: base.primary,
      light: _withRoles(base.light),
      dark: _withRoles(base.dark),
      oled: _withRoles(base.oled),
    );
    final theme = _themeFor(colors);

    test('reach the palette unchanged', () {
      for (final brightness in Brightness.values) {
        final palette = theme.palette(brightness);
        expect(palette.cardForeground, const Color(0xFF010101));
        expect(palette.popover, const Color(0xFF020202));
        expect(palette.popoverForeground, const Color(0xFF030303));
        expect(palette.secondary, const Color(0xFF040404));
        expect(palette.secondaryForeground, const Color(0xFF050505));
        expect(palette.accent, const Color(0xFF060606));
        expect(palette.accentForeground, const Color(0xFF070707));
        expect(palette.ring, const Color(0xFF080808));
        expect(palette.selection, const Color(0x33090909));
        expect(palette.primaryText, const Color(0xFF0A0A0A));
        expect(palette.primaryControl, const Color(0xFF0B0B0B));
        expect(palette.mutedControl, const Color(0xFF0C0C0C));
        expect(palette.placeholderText, const Color(0xFF0D0D0D));
        expect(palette.destructiveText, const Color(0xFF0E0E0E));
      }
    });

    test('reach the shad color scheme', () {
      for (final brightness in Brightness.values) {
        final palette = theme.palette(brightness);
        final scheme = theme.toShadThemeData(brightness).colorScheme;
        expect(scheme.cardForeground, palette.cardForeground);
        expect(scheme.popover, palette.popover);
        expect(scheme.popoverForeground, palette.popoverForeground);
        expect(scheme.secondary, palette.secondary);
        expect(scheme.secondaryForeground, palette.secondaryForeground);
        expect(scheme.accent, palette.accent);
        expect(scheme.accentForeground, palette.accentForeground);
        expect(scheme.ring, palette.ring);
        expect(scheme.selection, palette.selection);
      }
    });

    test('theme the checkbox from the control roles', () {
      final checkbox = theme.toShadThemeData(Brightness.light).checkboxTheme;
      expect(checkbox.color, const Color(0xFF0B0B0B));
      expect(
        checkbox.decoration?.border?.top?.color,
        const Color(0xFF0A0A0A),
      );
      // The palette's edge color replaces shad's input edge without losing
      // shad's checkbox radius or edge width.
      final shadDefault = _v030ShadThemeData(
        theme,
        Brightness.light,
      ).checkboxTheme;
      expect(
        checkbox.decoration?.border?.radius,
        shadDefault.decoration?.border?.radius,
      );
      expect(
        checkbox.decoration?.border?.top?.width,
        shadDefault.decoration?.border?.top?.width,
      );
    });

    test('a theme without control roles keeps the input edge', () {
      final checkbox = testTheme
          .toShadThemeData(Brightness.light)
          .checkboxTheme;
      expect(checkbox.color, testTheme.colors.primary);
      expect(
        checkbox.decoration?.border?.top?.color,
        testTheme.colors.light.input,
      );
    });

    test('derived foregrounds follow an explicit fill', () {
      const accent = Color(0xFF111111);
      final tokens = ZamColorTokens(
        primary: const Color(0xFFFFD60A),
        light: _withAccent(base.light, accent),
        dark: base.dark,
        oled: base.oled,
      );
      final palette = _themeFor(tokens).palette(Brightness.light);
      expect(palette.accent, accent);
      expect(palette.accentForeground, ZamColorUtils.readableOn(accent));
      expect(palette.secondary, accent);
      expect(palette.secondaryForeground, ZamColorUtils.readableOn(accent));
      expect(
        palette.primaryForeground,
        isNot(palette.accentForeground),
        reason: 'a dark accent on a yellow primary needs its own foreground',
      );
    });
  });

  group('oled', () {
    final colors = ZamColorTokens.fromSeed(primary: const Color(0xFF2F55BF));
    final dark = _themeFor(colors);
    final oled = _themeFor(colors, oled: true);

    test('defaults to false', () {
      expect(testTheme.oled, isFalse);
    });

    test('resolves dark to the OLED surfaces', () {
      expect(oled.palette(Brightness.dark).background, colors.oled.background);
      expect(oled.palette(Brightness.dark).card, colors.oled.card);
      expect(dark.palette(Brightness.dark).background, colors.dark.background);
      expect(oled.palette(Brightness.light), dark.palette(Brightness.light));
    });

    test('is the default for toShadThemeData, and isOled overrides it', () {
      expect(
        oled.toShadThemeData(Brightness.dark).colorScheme.background,
        colors.oled.background,
      );
      expect(
        oled
            .toShadThemeData(Brightness.dark, isOled: false)
            .colorScheme
            .background,
        colors.dark.background,
      );
      expect(
        dark
            .toShadThemeData(Brightness.dark, isOled: true)
            .colorScheme
            .background,
        colors.oled.background,
      );
    });

    test('takes part in copyWith and equality', () {
      expect(dark.copyWith(oled: true), oled);
      expect(dark.copyWith(oled: true).hashCode, oled.hashCode);
      expect(oled.copyWith().oled, isTrue);
      expect(dark, isNot(oled));
    });

    test('drives the toast surfaces', () {
      Color background(ZamThemeData theme, Brightness brightness) =>
          theme.toastStyle(brightness, ZamToastVariant.info).background;

      expect(
        background(oled, Brightness.dark),
        isNot(background(dark, Brightness.dark)),
      );
      expect(
        background(oled, Brightness.light),
        background(dark, Brightness.light),
      );
    });

    testWidgets('ZamApp installs the OLED surfaces in dark mode', (
      tester,
    ) async {
      late ZamPalette palette;
      await tester.pumpWidget(
        ZamApp(
          theme: oled,
          themeMode: ZamThemeMode.dark,
          home: Builder(
            builder: (context) {
              palette = context.zamPalette;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(palette, oled.palette(Brightness.dark));
      expect(palette.background, colors.oled.background);
    });
  });

  test('palette is resolved once per theme instance', () {
    final theme = _themeFor(seeds.first);
    expect(
      theme.palette(Brightness.light),
      same(theme.palette(Brightness.light)),
    );
    expect(
      theme.palette(Brightness.dark),
      same(theme.palette(Brightness.dark)),
    );
  });

  for (final mode in [ZamThemeMode.light, ZamThemeMode.dark]) {
    testWidgets('context.zamPalette follows $mode', (tester) async {
      late ZamPalette palette;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          themeMode: mode,
          home: Builder(
            builder: (context) {
              palette = context.zamPalette;
              return const SizedBox();
            },
          ),
        ),
      );

      final brightness = mode == ZamThemeMode.dark
          ? Brightness.dark
          : Brightness.light;
      expect(palette, testTheme.palette(brightness));
    });
  }
}
