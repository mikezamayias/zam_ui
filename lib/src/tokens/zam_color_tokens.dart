part of '../tokens.dart';

class ZamColorTokens {
  const ZamColorTokens({
    required this.primary,
    required this.light,
    required this.dark,
    required this.oled,
    this.black = ZamColorUtils.black,
    this.white = ZamColorUtils.white,
    this.transparent = ZamColorUtils.transparent,
  });

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

  final Color primary;
  final ZamSurfaceColors light;
  final ZamSurfaceColors dark;
  final ZamSurfaceColors oled;
  final Color black;
  final Color white;
  final Color transparent;

  ZamSurfaceColors forBrightness(
    Brightness brightness, {
    bool isOled = false,
  }) {
    if (brightness == Brightness.light) return light;
    return isOled ? oled : dark;
  }
}
