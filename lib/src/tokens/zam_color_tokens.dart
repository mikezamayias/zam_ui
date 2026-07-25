part of '../tokens.dart';

/// Color tokens defining primary brand colors, surface palettes, and utility colors.
class ZamColorTokens {
  /// Creates a set of [ZamColorTokens] with explicit surface configurations.
  const ZamColorTokens({
    required this.primary,
    required this.light,
    required this.dark,
    required this.oled,
    this.black = ZamColorUtils.black,
    this.white = ZamColorUtils.white,
    this.transparent = ZamColorUtils.transparent,
  });

  /// Generates a complete [ZamColorTokens] set from a primary seed color.
  factory ZamColorTokens.fromSeed({
    required Color primary,
    Color lightBackground = const Color(0xFFFAF9F7),
    Color darkBackground = const Color(0xFF09090B),
    Color oledBackground = const Color(0xFF000000),
    Color lightCard = const Color(0xFFFFFFFF),
    Color darkCard = const Color(0xFF1A1A1C),
    Color oledCard = const Color(0xFF0A0A0A),
    Color lightMuted = const Color(0xFFF0EEEA),
    Color darkMuted = const Color(0xFF27272A),
    Color lightMutedForeground = const Color(0xFF73706A),
    Color darkMutedForeground = const Color(0xFFA1A1AA),
    Color lightBorder = const Color(0xFFE4E0D9),
    Color darkBorder = const Color(0xFF27272A),
    Color lightDestructive = const Color(0xFFFF3B30),
    Color darkDestructive = const Color(0xFFD92D20),
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
      ),
    );
  }

  /// Primary brand color.
  final Color primary;

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

  /// Returns the corresponding [ZamSurfaceColors] for a given [brightness] and optional [isOled] mode.
  ZamSurfaceColors forBrightness(
    Brightness brightness, {
    bool isOled = false,
  }) {
    if (brightness == Brightness.light) return light;
    return isOled ? oled : dark;
  }
}
