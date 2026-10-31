part of '../theme.dart';

/// Extension methods on [BuildContext] for convenient theme and token access.
extension ZamThemeContext on BuildContext {
  /// Convenient getter for [ZamThemeData] from [context].
  ZamThemeData get zam => ZamTheme.of(this);

  /// Convenient getter for active [ZamColorTokens].
  ZamColorTokens get zamColors => zam.colors;

  /// Convenient getter for active [ZamTypographyTokens].
  ZamTypographyTokens get zamTypography => zam.typography;

  /// Convenient getter for active [ZamIconSet].
  ZamIconSet get zamIcons => zam.icons;

  /// Status colors for the active brightness, with readable foregrounds.
  ZamStatusColors get zamStatus =>
      zamColors.forBrightness(ShadTheme.of(this).brightness).status;
}
