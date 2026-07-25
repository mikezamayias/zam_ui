part of '../tokens.dart';

/// Surface colors for background, foreground, card, and state palette roles.
class ZamSurfaceColors {
  /// Creates a [ZamSurfaceColors] set mapping specific color roles.
  const ZamSurfaceColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.muted,
    required this.mutedForeground,
    required this.border,
    required this.input,
    required this.destructive,
  });

  /// Main background color.
  final Color background;

  /// Main foreground/text color.
  final Color foreground;

  /// Card surface color.
  final Color card;

  /// Muted background color.
  final Color muted;

  /// Muted foreground/secondary text color.
  final Color mutedForeground;

  /// Border line color.
  final Color border;

  /// Input background color.
  final Color input;

  /// Destructive action color.
  final Color destructive;
}
