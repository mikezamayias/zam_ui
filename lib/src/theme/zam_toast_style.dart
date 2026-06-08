part of '../theme.dart';

class ZamToastStyle {
  const ZamToastStyle({
    required this.variant,
    required this.background,
    required this.border,
    required this.foreground,
    required this.subtleForeground,
    required this.icon,
    required this.iconForeground,
    required this.shadowColor,
  });

  final ZamToastVariant variant;
  final Color background;
  final Color border;
  final Color foreground;
  final Color subtleForeground;
  final IconData icon;
  final Color iconForeground;
  final Color shadowColor;
}
