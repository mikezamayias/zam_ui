part of '../theme.dart';

extension ZamThemeContext on BuildContext {
  ZamThemeData get zam => ZamTheme.of(this);
  ZamColorTokens get zamColors => zam.colors;
  ZamTypographyTokens get zamTypography => zam.typography;
  ZamIconSet get zamIcons => zam.icons;
}
