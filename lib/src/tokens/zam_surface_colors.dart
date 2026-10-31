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
    this.destructiveForeground,
    this.success = const Color(0xFF15803D),
    this.warning = const Color(0xFFB45309),
    this.info = const Color(0xFF1D4ED8),
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

  /// Text and icon color on [destructive]. Null picks black or white by
  /// contrast.
  final Color? destructiveForeground;

  /// Success status color. See [status].
  final Color success;

  /// Warning status color. See [status].
  final Color warning;

  /// Info status color. See [status].
  final Color info;

  /// The status roles with readable foregrounds.
  ZamStatusColors get status => ZamStatusColors.of(this);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZamSurfaceColors &&
          other.background == background &&
          other.foreground == foreground &&
          other.card == card &&
          other.muted == muted &&
          other.mutedForeground == mutedForeground &&
          other.border == border &&
          other.input == input &&
          other.destructive == destructive &&
          other.destructiveForeground == destructiveForeground &&
          other.success == success &&
          other.warning == warning &&
          other.info == info;

  @override
  int get hashCode => Object.hash(
    background,
    foreground,
    card,
    muted,
    mutedForeground,
    border,
    input,
    destructive,
    destructiveForeground,
    success,
    warning,
    info,
  );
}
