part of '../tokens.dart';

/// Surface colors for background, foreground, card, and state palette roles.
///
/// The optional roles let an app store colors it computed itself. A role
/// left null resolves in `ZamThemeData.palette` to the value zam_ui derives
/// from the required roles and the primary color.
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
    this.cardForeground,
    this.popover,
    this.popoverForeground,
    this.secondary,
    this.secondaryForeground,
    this.accent,
    this.accentForeground,
    this.ring,
    this.selection,
    this.primaryText,
    this.primaryControl,
    this.mutedControl,
    this.placeholderText,
    this.destructiveText,
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

  /// Text and icon color on [card]. Null uses [foreground].
  final Color? cardForeground;

  /// Popover and menu surface color. Null uses [card].
  final Color? popover;

  /// Text and icon color on [popover]. Null uses [foreground].
  final Color? popoverForeground;

  /// Secondary fill color. Null mixes the primary color toward white in
  /// light mode and toward black in dark mode.
  final Color? secondary;

  /// Text and icon color on [secondary]. Null picks black or white by
  /// contrast with the resolved secondary color.
  final Color? secondaryForeground;

  /// Accent fill color. Null uses the primary color.
  final Color? accent;

  /// Text and icon color on [accent]. Null uses the primary foreground when
  /// [accent] is null too, and otherwise picks black or white by contrast
  /// with [accent].
  final Color? accentForeground;

  /// Focus ring color. Null uses the primary color.
  final Color? ring;

  /// Text selection highlight color. Null uses the primary color at the
  /// theme's faint opacity.
  final Color? selection;

  /// The accent as drawn as text and icons on the surfaces, meant to reach
  /// 4.5:1 on them. Null uses the primary color.
  final Color? primaryText;

  /// The accent for the parts of a control that show its state, such as a
  /// checked fill, meant to reach 3:1 on the surfaces. Null uses the primary
  /// color.
  final Color? primaryControl;

  /// The neutral for the parts of a control that carry no accent, such as an
  /// unchecked edge, meant to reach 3:1 on the surfaces. Null uses
  /// [mutedForeground].
  final Color? mutedControl;

  /// Placeholder and hint text, meant to reach 4.5:1 on the surfaces. Null
  /// uses [mutedForeground].
  final Color? placeholderText;

  /// The destructive color as drawn as text, meant to reach 4.5:1 on the
  /// surfaces. Null uses [destructive].
  final Color? destructiveText;

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
          other.info == info &&
          other.cardForeground == cardForeground &&
          other.popover == popover &&
          other.popoverForeground == popoverForeground &&
          other.secondary == secondary &&
          other.secondaryForeground == secondaryForeground &&
          other.accent == accent &&
          other.accentForeground == accentForeground &&
          other.ring == ring &&
          other.selection == selection &&
          other.primaryText == primaryText &&
          other.primaryControl == primaryControl &&
          other.mutedControl == mutedControl &&
          other.placeholderText == placeholderText &&
          other.destructiveText == destructiveText;

  @override
  int get hashCode => Object.hashAll([
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
    cardForeground,
    popover,
    popoverForeground,
    secondary,
    secondaryForeground,
    accent,
    accentForeground,
    ring,
    selection,
    primaryText,
    primaryControl,
    mutedControl,
    placeholderText,
    destructiveText,
  ]);
}
