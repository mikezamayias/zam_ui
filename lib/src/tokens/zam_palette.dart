part of '../tokens.dart';

/// Every color role of one brightness, resolved to a non-null [Color].
///
/// `ZamThemeData.palette` builds it from [ZamColorTokens] and the
/// [ZamSurfaceColors] of that brightness, and `context.zamPalette` reads it
/// for the active brightness. The shad color scheme that `ZamApp` installs
/// is built from the same palette.
@immutable
class ZamPalette {
  /// Creates a [ZamPalette] with every role set.
  const ZamPalette({
    required this.brightness,
    required this.background,
    required this.foreground,
    required this.card,
    required this.cardForeground,
    required this.popover,
    required this.popoverForeground,
    required this.primary,
    required this.primaryForeground,
    required this.secondary,
    required this.secondaryForeground,
    required this.muted,
    required this.mutedForeground,
    required this.accent,
    required this.accentForeground,
    required this.destructive,
    required this.destructiveForeground,
    required this.border,
    required this.input,
    required this.ring,
    required this.selection,
    required this.primaryText,
    required this.primaryControl,
    required this.mutedControl,
    required this.placeholderText,
    required this.destructiveText,
    required this.status,
  });

  /// The brightness these roles were resolved for.
  final Brightness brightness;

  /// Main background color.
  final Color background;

  /// Main text and icon color.
  final Color foreground;

  /// Card surface color.
  final Color card;

  /// Text and icon color on [card].
  final Color cardForeground;

  /// Popover and menu surface color.
  final Color popover;

  /// Text and icon color on [popover].
  final Color popoverForeground;

  /// Primary brand color.
  final Color primary;

  /// Text and icon color on [primary].
  final Color primaryForeground;

  /// Secondary fill color.
  final Color secondary;

  /// Text and icon color on [secondary].
  final Color secondaryForeground;

  /// Muted fill color.
  final Color muted;

  /// Secondary text color.
  final Color mutedForeground;

  /// Accent fill color.
  final Color accent;

  /// Text and icon color on [accent].
  final Color accentForeground;

  /// Destructive action color.
  final Color destructive;

  /// Text and icon color on [destructive].
  final Color destructiveForeground;

  /// Border line color.
  final Color border;

  /// Input fill color.
  final Color input;

  /// Focus ring color.
  final Color ring;

  /// Text selection highlight color.
  final Color selection;

  /// The accent as drawn as text and icons on the surfaces.
  final Color primaryText;

  /// The accent for the parts of a control that show its state.
  final Color primaryControl;

  /// The neutral for the parts of a control that carry no accent.
  final Color mutedControl;

  /// Placeholder and hint text color.
  final Color placeholderText;

  /// The destructive color as drawn as text.
  final Color destructiveText;

  /// The status roles with readable foregrounds.
  final ZamStatusColors status;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZamPalette &&
          other.brightness == brightness &&
          other.background == background &&
          other.foreground == foreground &&
          other.card == card &&
          other.cardForeground == cardForeground &&
          other.popover == popover &&
          other.popoverForeground == popoverForeground &&
          other.primary == primary &&
          other.primaryForeground == primaryForeground &&
          other.secondary == secondary &&
          other.secondaryForeground == secondaryForeground &&
          other.muted == muted &&
          other.mutedForeground == mutedForeground &&
          other.accent == accent &&
          other.accentForeground == accentForeground &&
          other.destructive == destructive &&
          other.destructiveForeground == destructiveForeground &&
          other.border == border &&
          other.input == input &&
          other.ring == ring &&
          other.selection == selection &&
          other.primaryText == primaryText &&
          other.primaryControl == primaryControl &&
          other.mutedControl == mutedControl &&
          other.placeholderText == placeholderText &&
          other.destructiveText == destructiveText &&
          other.status == status;

  @override
  int get hashCode => Object.hashAll([
    brightness,
    background,
    foreground,
    card,
    cardForeground,
    popover,
    popoverForeground,
    primary,
    primaryForeground,
    secondary,
    secondaryForeground,
    muted,
    mutedForeground,
    accent,
    accentForeground,
    destructive,
    destructiveForeground,
    border,
    input,
    ring,
    selection,
    primaryText,
    primaryControl,
    mutedControl,
    placeholderText,
    destructiveText,
    status,
  ]);
}
