part of '../theme.dart';

/// Aggregated design system theme configuration.
///
/// Combines color tokens, typography tokens, icons, and layout scale tokens
/// into a single immutable configuration object.
class ZamThemeData {
  /// Creates a [ZamThemeData] configuration.
  ZamThemeData({
    required this.colors,
    required this.typography,
    required this.icons,
    this.spacing = const ZamSpacingTokens(),
    this.radius = const ZamRadiusTokens(),
    this.strokes = const ZamStrokeTokens(),
    this.opacities = const ZamOpacityTokens(),
    this.shadows = const ZamShadowTokens(),
    this.motion = const ZamMotionTokens(),
  })  : insets = ZamInsetsTokens(spacing),
        sizes = ZamSizeTokens(spacing),
        assert(
          typography.fontFamily.isNotEmpty,
          'fontFamily must not be empty.',
        );

  /// Creates a fallback theme configuration for testing or standalone usage.
  factory ZamThemeData.fallback() {
    return ZamThemeData(
      colors: ZamColorTokens.fromSeed(primary: const Color(0xFF06B6D4)),
      typography: const ZamTypographyTokens(
        fontFamily: 'Inter',
        monoFontFamily: 'JetBrains Mono',
      ),
      icons: const ZamIconSet(
        info: IconData(0xe88e, fontFamily: 'MaterialIcons'),
        success: IconData(0xe876, fontFamily: 'MaterialIcons'),
        warning: IconData(0xe002, fontFamily: 'MaterialIcons'),
        error: IconData(0xe000, fontFamily: 'MaterialIcons'),
        back: IconData(0xe5c4, fontFamily: 'MaterialIcons'),
        chevronRight: IconData(0xe5cc, fontFamily: 'MaterialIcons'),
      ),
    );
  }

  /// Color tokens.
  final ZamColorTokens colors;

  /// Typography tokens.
  final ZamTypographyTokens typography;

  /// Icon set mapping.
  final ZamIconSet icons;

  /// Spacing scale tokens.
  final ZamSpacingTokens spacing;

  /// Inset tokens derived from [spacing].
  final ZamInsetsTokens insets;

  /// Size tokens derived from [spacing].
  final ZamSizeTokens sizes;

  /// Corner radius tokens.
  final ZamRadiusTokens radius;

  /// Stroke thickness tokens.
  final ZamStrokeTokens strokes;

  /// Opacity tokens.
  final ZamOpacityTokens opacities;

  /// Box shadow elevation tokens.
  final ZamShadowTokens shadows;

  /// Motion and animation tokens.
  final ZamMotionTokens motion;

  /// Creates a copy of this theme configuration with optional overridden fields.
  ZamThemeData copyWith({
    ZamColorTokens? colors,
    ZamTypographyTokens? typography,
    ZamIconSet? icons,
    ZamSpacingTokens? spacing,
    ZamRadiusTokens? radius,
    ZamStrokeTokens? strokes,
    ZamOpacityTokens? opacities,
    ZamShadowTokens? shadows,
    ZamMotionTokens? motion,
  }) {
    return ZamThemeData(
      colors: colors ?? this.colors,
      typography: typography ?? this.typography,
      icons: icons ?? this.icons,
      spacing: spacing ?? this.spacing,
      radius: radius ?? this.radius,
      strokes: strokes ?? this.strokes,
      opacities: opacities ?? this.opacities,
      shadows: shadows ?? this.shadows,
      motion: motion ?? this.motion,
    );
  }

  /// Converts design tokens into a [ShadThemeData] object for a given [brightness] and optional [isOled] mode.
  ShadThemeData toShadThemeData(Brightness brightness, {bool isOled = false}) {
    final tone = colors.forBrightness(brightness, isOled: isOled);
    final primaryForeground =
        colors.primaryForeground ?? ZamColorUtils.readableOn(colors.primary);
    final secondary = ZamColorUtils.mix(
      colors.primary,
      brightness == Brightness.dark ? colors.black : colors.white,
      brightness == Brightness.dark ? 0.7 : 0.85,
    );
    final destructiveForeground = tone.destructiveForeground ??
        ZamColorUtils.readableOn(tone.destructive);

    return ShadThemeData(
      brightness: brightness,
      radius: radius.lg,
      textTheme: typography.toShadTextTheme(),
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
        selection: colors.primary.withValues(alpha: opacities.faint),
      ),
    );
  }

  /// Resolves the [ZamToastStyle] for a specific [brightness] and toast [variant].
  ZamToastStyle toastStyle(Brightness brightness, ZamToastVariant variant) {
    final shadTheme = toShadThemeData(brightness);
    final scheme = shadTheme.colorScheme;
    final baseColor = switch (variant) {
      ZamToastVariant.success => scheme.accent,
      ZamToastVariant.error => scheme.destructive,
      ZamToastVariant.info => scheme.primary,
      ZamToastVariant.warning => scheme.secondary,
      ZamToastVariant.progress => scheme.muted,
    };
    final background = scheme.background.blend(baseColor, opacities.subtleTint);
    final border = scheme.border.blend(baseColor, opacities.borderTint);
    final foreground = ZamColorUtils.readableOn(background);
    final subtleForeground = Color.alphaBlend(
      foreground.withValues(alpha: opacities.subtleTint),
      scheme.foreground.withValues(alpha: opacities.nearlyOpaque),
    );
    final icon = switch (variant) {
      ZamToastVariant.success => icons.success,
      ZamToastVariant.error => icons.error,
      ZamToastVariant.info => icons.info,
      ZamToastVariant.warning => icons.warning,
      ZamToastVariant.progress => icons.info,
    };

    return ZamToastStyle(
      variant: variant,
      background: background,
      border: border,
      foreground: foreground,
      subtleForeground: subtleForeground,
      icon: icon,
      iconForeground: ZamColorUtils.readableOn(background),
      shadowColor: baseColor.withValues(alpha: opacities.borderTint),
    );
  }
}
