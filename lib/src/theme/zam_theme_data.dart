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
    this.oled = false,
  }) : insets = ZamInsetsTokens(spacing),
       sizes = ZamSizeTokens(spacing),
       assert(
         typography.fontFamily.isNotEmpty,
         'fontFamily must not be empty.',
       );

  /// Creates a fallback theme configuration for testing or standalone usage.
  factory ZamThemeData.fallback() {
    return ZamThemeData(
      colors: ZamColorTokens.fromSeed(primary: const Color(0xFF2F55BF)),
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

  /// Whether dark mode uses the pure black [ZamColorTokens.oled] surfaces
  /// instead of [ZamColorTokens.dark].
  final bool oled;

  late final ZamPalette _lightPalette = _resolvePalette(
    Brightness.light,
    isOled: false,
  );

  late final ZamPalette _darkPalette = _resolvePalette(
    Brightness.dark,
    isOled: false,
  );

  late final ZamPalette _oledPalette = _resolvePalette(
    Brightness.dark,
    isOled: true,
  );

  /// Every color role for [brightness], resolved once per theme instance.
  ///
  /// Dark resolves to [ZamColorTokens.oled] when [oled] is true. A role the
  /// surface leaves null takes the value documented on [ZamSurfaceColors].
  ZamPalette palette(Brightness brightness) =>
      _paletteFor(brightness, isOled: oled);

  ZamPalette _paletteFor(Brightness brightness, {required bool isOled}) {
    if (brightness == Brightness.light) return _lightPalette;
    return isOled ? _oledPalette : _darkPalette;
  }

  ZamPalette _resolvePalette(Brightness brightness, {required bool isOled}) {
    final tone = colors.forBrightness(brightness, isOled: isOled);
    final primary = colors.primary;
    final primaryForeground =
        colors.primaryForeground ?? ZamColorUtils.readableOn(primary);
    final secondary =
        tone.secondary ??
        ZamColorUtils.mix(
          primary,
          brightness == Brightness.dark ? colors.black : colors.white,
          brightness == Brightness.dark ? 0.7 : 0.85,
        );
    final accent = tone.accent ?? primary;
    return ZamPalette(
      brightness: brightness,
      background: tone.background,
      foreground: tone.foreground,
      card: tone.card,
      cardForeground: tone.cardForeground ?? tone.foreground,
      popover: tone.popover ?? tone.card,
      popoverForeground: tone.popoverForeground ?? tone.foreground,
      primary: primary,
      primaryForeground: primaryForeground,
      secondary: secondary,
      secondaryForeground:
          tone.secondaryForeground ?? ZamColorUtils.readableOn(secondary),
      muted: tone.muted,
      mutedForeground: tone.mutedForeground,
      accent: accent,
      accentForeground:
          tone.accentForeground ??
          (tone.accent == null
              ? primaryForeground
              : ZamColorUtils.readableOn(accent)),
      destructive: tone.destructive,
      destructiveForeground:
          tone.destructiveForeground ??
          ZamColorUtils.readableOn(tone.destructive),
      border: tone.border,
      input: tone.input,
      ring: tone.ring ?? primary,
      selection: tone.selection ?? primary.withValues(alpha: opacities.faint),
      primaryText: tone.primaryText ?? primary,
      primaryControl: tone.primaryControl ?? primary,
      mutedControl: tone.mutedControl ?? tone.mutedForeground,
      placeholderText: tone.placeholderText ?? tone.mutedForeground,
      destructiveText: tone.destructiveText ?? tone.destructive,
      status: tone.status,
    );
  }

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
    bool? oled,
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
      oled: oled ?? this.oled,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZamThemeData &&
          other.colors == colors &&
          other.typography == typography &&
          other.icons == icons &&
          other.spacing == spacing &&
          other.radius == radius &&
          other.strokes == strokes &&
          other.opacities == opacities &&
          other.shadows == shadows &&
          other.motion == motion &&
          other.oled == oled;

  @override
  int get hashCode => Object.hash(
    colors,
    typography,
    icons,
    spacing,
    radius,
    strokes,
    opacities,
    shadows,
    motion,
    oled,
  );

  /// Converts design tokens into a [ShadThemeData] object for a given
  /// [brightness].
  ///
  /// The color scheme comes from [palette]. [isOled] picks the dark surfaces
  /// and defaults to [oled].
  ShadThemeData toShadThemeData(Brightness brightness, {bool? isOled}) {
    final effectiveOled = isOled ?? oled;
    final palette = _paletteFor(brightness, isOled: effectiveOled);
    final tone = colors.forBrightness(brightness, isOled: effectiveOled);

    final destructiveHover = palette.destructive.withValues(
      alpha: opacities.nearlyOpaque,
    );

    return ShadThemeData(
      brightness: brightness,
      radius: radius.lg,
      spacing: spacing.toShadSpacing(),
      textTheme: typography.toShadTextTheme(),
      // shad tints destructive buttons; a solid fill keeps a strong danger
      // signal and a readable label on any brand's destructive color.
      destructiveButtonTheme: ShadButtonTheme(
        backgroundColor: palette.destructive,
        hoverBackgroundColor: destructiveHover,
        pressedBackgroundColor: destructiveHover,
        foregroundColor: palette.destructiveForeground,
        hoverForegroundColor: palette.destructiveForeground,
        pressedForegroundColor: palette.destructiveForeground,
      ),
      // shad fills a checked box with primary and edges it with input. An
      // unset primaryControl is primary, and the edge changes only when the
      // surface sets primaryText, so a theme without them keeps shad's box.
      checkboxTheme: ShadCheckboxTheme(
        color: palette.primaryControl,
        decoration: tone.primaryText == null
            ? null
            : ShadDecoration(
                border: ShadBorder.all(color: palette.primaryText),
              ),
      ),
      colorScheme: ShadColorScheme(
        background: palette.background,
        foreground: palette.foreground,
        card: palette.card,
        cardForeground: palette.cardForeground,
        popover: palette.popover,
        popoverForeground: palette.popoverForeground,
        primary: palette.primary,
        primaryForeground: palette.primaryForeground,
        secondary: palette.secondary,
        secondaryForeground: palette.secondaryForeground,
        muted: palette.muted,
        mutedForeground: palette.mutedForeground,
        accent: palette.accent,
        accentForeground: palette.accentForeground,
        destructive: palette.destructive,
        destructiveForeground: palette.destructiveForeground,
        border: palette.border,
        input: palette.input,
        ring: palette.ring,
        selection: palette.selection,
      ),
    );
  }

  /// Resolves the [ZamToastStyle] for a specific [brightness] and toast [variant].
  ZamToastStyle toastStyle(Brightness brightness, ZamToastVariant variant) {
    final scheme = palette(brightness);
    final baseColor = switch (variant) {
      ZamToastVariant.success => scheme.status.success,
      ZamToastVariant.error => scheme.destructive,
      ZamToastVariant.info => scheme.status.info,
      ZamToastVariant.warning => scheme.status.warning,
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
