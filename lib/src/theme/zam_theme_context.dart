part of '../theme.dart';

/// Extension methods on [BuildContext] for convenient theme and token access.
extension ZamThemeContext on BuildContext {
  /// Convenient getter for [ZamThemeData] from [context].
  ZamThemeData get zam => ZamTheme.of(this);

  /// Convenient getter for active [ZamColorTokens].
  ZamColorTokens get zamColors => zam.colors;

  /// Convenient getter for active [ZamTypographyTokens].
  ZamTypographyTokens get zamTypography => zam.typography;

  /// The active theme's extension of type [T], or null when it has none.
  ///
  /// See [ZamThemeData.extension].
  T? zamExtension<T>() => zam.extension<T>();

  /// Convenient getter for active [ZamIconSet].
  ZamIconSet get zamIcons => zam.icons;

  /// Every color role for the active brightness.
  ZamPalette get zamPalette => zam.palette(ShadTheme.of(this).brightness);

  /// Status colors for the active brightness, with readable foregrounds.
  ZamStatusColors get zamStatus => zamPalette.status;
}
