part of '../tokens.dart';

/// Color tokens defining primary brand colors, surface palettes, and utility colors.
class ZamColorTokens {
  /// Creates a set of [ZamColorTokens] with explicit surface configurations.
  const ZamColorTokens({
    required this.primary,
    required this.light,
    required this.dark,
    required this.oled,
    this.primaryForeground,
    this.black = ZamColorUtils.black,
    this.white = ZamColorUtils.white,
    this.transparent = ZamColorUtils.transparent,
  });

  /// Generates a complete [ZamColorTokens] set from a primary seed color.
  ///
  /// Surfaces default to a neutral zinc palette, the neutrals shadcn/ui uses.
  factory ZamColorTokens.fromSeed({
    required Color primary,
    Color lightBackground = const Color(0xFFFFFFFF),
    Color darkBackground = const Color(0xFF09090B),
    Color oledBackground = const Color(0xFF000000),
    Color lightCard = const Color(0xFFFFFFFF),
    Color darkCard = const Color(0xFF18181B),
    Color oledCard = const Color(0xFF09090B),
    Color lightMuted = const Color(0xFFF4F4F5),
    Color darkMuted = const Color(0xFF27272A),
    Color lightMutedForeground = const Color(0xFF71717A),
    Color darkMutedForeground = const Color(0xFFA1A1AA),
    Color lightBorder = const Color(0xFFE4E4E7),
    Color darkBorder = const Color(0xFF27272A),
    Color lightDestructive = const Color(0xFFDC2626),
    Color darkDestructive = const Color(0xFFEF4444),
    Color lightSuccess = const Color(0xFF15803D),
    Color darkSuccess = const Color(0xFF4ADE80),
    Color lightWarning = const Color(0xFFB45309),
    Color darkWarning = const Color(0xFFFBBF24),
    Color lightInfo = const Color(0xFF1D4ED8),
    Color darkInfo = const Color(0xFF60A5FA),
  }) {
    return ZamColorTokens(
      primary: primary,
      light: ZamSurfaceColors(
        background: lightBackground,
        foreground: const Color(0xFF09090B),
        card: lightCard,
        muted: lightMuted,
        mutedForeground: lightMutedForeground,
        border: lightBorder,
        input: lightMuted,
        destructive: lightDestructive,
        success: lightSuccess,
        warning: lightWarning,
        info: lightInfo,
      ),
      dark: ZamSurfaceColors(
        background: darkBackground,
        foreground: ZamColorUtils.white,
        card: darkCard,
        muted: darkMuted,
        mutedForeground: darkMutedForeground,
        border: darkBorder,
        input: darkMuted,
        destructive: darkDestructive,
        success: darkSuccess,
        warning: darkWarning,
        info: darkInfo,
      ),
      oled: ZamSurfaceColors(
        background: oledBackground,
        foreground: ZamColorUtils.white,
        card: oledCard,
        muted: darkMuted,
        mutedForeground: darkMutedForeground,
        border: darkBorder,
        input: darkMuted,
        destructive: darkDestructive,
        success: darkSuccess,
        warning: darkWarning,
        info: darkInfo,
      ),
    );
  }

  /// Primary brand color.
  final Color primary;

  /// Text and icon color on [primary]. Null picks black or white by
  /// contrast.
  final Color? primaryForeground;

  /// Light mode surface colors.
  final ZamSurfaceColors light;

  /// Dark mode surface colors.
  final ZamSurfaceColors dark;

  /// Pure black OLED mode surface colors.
  final ZamSurfaceColors oled;

  /// Absolute black color.
  final Color black;

  /// Absolute white color.
  final Color white;

  /// Fully transparent color.
  final Color transparent;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZamColorTokens &&
          other.primary == primary &&
          other.primaryForeground == primaryForeground &&
          other.light == light &&
          other.dark == dark &&
          other.oled == oled &&
          other.black == black &&
          other.white == white &&
          other.transparent == transparent;

  @override
  int get hashCode => Object.hash(
    primary,
    primaryForeground,
    light,
    dark,
    oled,
    black,
    white,
    transparent,
  );

  /// Returns the corresponding [ZamSurfaceColors] for a given [brightness] and optional [isOled] mode.
  ZamSurfaceColors forBrightness(Brightness brightness, {bool isOled = false}) {
    if (brightness == Brightness.light) return light;
    return isOled ? oled : dark;
  }
}
