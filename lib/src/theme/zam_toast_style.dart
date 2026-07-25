part of '../theme.dart';

/// Style configuration for toast notifications.
class ZamToastStyle {
  /// Creates a [ZamToastStyle] mapping toast visual attributes.
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

  /// The toast variant role.
  final ZamToastVariant variant;

  /// Background color.
  final Color background;

  /// Border stroke color.
  final Color border;

  /// Primary text color.
  final Color foreground;

  /// Secondary description text color.
  final Color subtleForeground;

  /// Icon data for the toast.
  final IconData icon;

  /// Icon foreground color.
  final Color iconForeground;

  /// Drop shadow color.
  final Color shadowColor;
}
