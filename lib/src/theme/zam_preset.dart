part of '../theme.dart';

/// Contract for app-owned brand presets.
///
/// Consuming apps implement this to define their brand identity.
/// The library never ships concrete presets — apps own their
/// colors, fonts, and icons.
///
/// ```dart
/// class MyAppPreset implements ZamPreset {
///   @override
///   String get name => 'My App';
///
///   @override
///   ZamThemeData get light => ZamThemeData(
///     colors: ZamColorTokens.fromSeed(primary: Color(0xFF06B6D4)),
///     typography: const ZamTypographyTokens(
///       fontFamily: 'Inter',
///       monoFontFamily: 'JetBrains Mono',
///     ),
///     icons: myIcons,
///   );
///
///   @override
///   ZamThemeData get dark => light;
/// }
/// ```
abstract interface class ZamPreset {
  /// Human-readable preset name (e.g., 'Healpen', 'Peakward').
  String get name;

  /// Theme data for light mode.
  ZamThemeData get light;

  /// Theme data for dark mode. Defaults to [light] if identical.
  ZamThemeData get dark;
}
