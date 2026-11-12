part of '../theme.dart';

/// Which theme [ZamApp] uses: [ZamApp.theme] or [ZamApp.darkTheme].
enum ZamThemeMode {
  /// Follows the platform brightness.
  system,

  /// Always uses the light theme.
  light,

  /// Always uses the dark theme.
  dark,
}
