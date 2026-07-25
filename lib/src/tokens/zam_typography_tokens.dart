part of '../tokens.dart';

/// Typography tokens for app-owned font families and text scale values.
///
/// `zam_ui` only consumes the [fontFamily] and [monoFontFamily] names. The
/// consuming app must load or register those fonts itself, usually through the
/// app's `flutter.fonts` entries in `pubspec.yaml`.
class ZamTypographyTokens {
  /// Creates a set of [ZamTypographyTokens] with required [fontFamily].
  const ZamTypographyTokens({
    required this.fontFamily,
    this.monoFontFamily = 'monospace',
  });

  /// Primary app font family name.
  final String fontFamily;

  /// Monospace app font family name.
  final String monoFontFamily;

  /// Large display heading font size (28).
  double get displaySize => 28;

  /// Top-level screen title font size (24).
  double get screenTitleSize => 24;

  /// Empty state title font size (20).
  double get emptyTitleSize => 20;

  /// Section heading font size (18).
  double get titleSize => 18;

  /// Regular body text font size (14).
  double get bodySize => 14;

  /// Large body text font size (16).
  double get bodyLargeSize => 16;

  /// Small body text font size (13).
  double get bodySmallSize => 13;

  /// Label font size (12).
  double get labelSize => 12;

  /// Secondary caption font size (11).
  double get captionSize => 11;

  /// Monospace label font size (10).
  double get monoLabelSize => 10;

  /// Standard line height multiplier for body text (1.5).
  double get bodyLineHeight => 1.5;

  /// Standard line height multiplier for form inputs (1.58).
  double get inputLineHeight => 1.58;

  /// Regular font weight (w400).
  FontWeight get regular => FontWeight.w400;

  /// Medium font weight (w500).
  FontWeight get medium => FontWeight.w500;

  /// Semibold font weight (w600).
  FontWeight get semibold => FontWeight.w600;

  /// Bold font weight (w700).
  FontWeight get bold => FontWeight.w700;

  /// Extra bold font weight (w800).
  FontWeight get extraBold => FontWeight.w800;

  /// Light font weight (w300).
  FontWeight get light => FontWeight.w300;

  /// Returns [TextStyle] for large display headings.
  TextStyle display(BuildContext context, {Color? color}) =>
      _base(context).h1.copyWith(
            fontFamily: fontFamily,
            fontSize: displaySize,
            fontWeight: bold,
            letterSpacing: 0,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  /// Returns [TextStyle] for main screen headers.
  TextStyle screenTitle(BuildContext context, {Color? color}) =>
      _base(context).h2.copyWith(
            fontFamily: fontFamily,
            fontSize: screenTitleSize,
            fontWeight: bold,
            letterSpacing: 0,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  /// Returns [TextStyle] for empty state titles.
  TextStyle emptyTitle(BuildContext context, {Color? color}) =>
      _base(context).h3.copyWith(
            fontFamily: fontFamily,
            fontSize: emptyTitleSize,
            fontWeight: semibold,
            letterSpacing: 0,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  /// Returns [TextStyle] for card and section titles.
  TextStyle title(BuildContext context, {Color? color}) =>
      _base(context).large.copyWith(
            fontFamily: fontFamily,
            fontSize: titleSize,
            fontWeight: semibold,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  /// Returns standard body [TextStyle].
  TextStyle body(BuildContext context, {Color? color}) =>
      _base(context).p.copyWith(
            fontFamily: fontFamily,
            fontSize: bodySize,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  /// Returns large body [TextStyle].
  TextStyle bodyLarge(BuildContext context, {Color? color}) =>
      _base(context).p.copyWith(
            fontFamily: fontFamily,
            fontSize: bodyLargeSize,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  /// Returns small body [TextStyle].
  TextStyle bodySmall(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
            fontFamily: fontFamily,
            fontSize: bodySmallSize,
            color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
          );

  /// Returns label [TextStyle].
  TextStyle label(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
            fontFamily: fontFamily,
            fontSize: labelSize,
            fontWeight: semibold,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  /// Returns secondary caption [TextStyle].
  TextStyle caption(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
            fontFamily: fontFamily,
            fontSize: captionSize,
            color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
          );

  /// Returns monospace caption [TextStyle].
  TextStyle monoCaption(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: monoFontFamily,
        fontSize: captionSize,
        color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
      );

  /// Returns uppercase monospace label [TextStyle].
  TextStyle monoCaps(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: monoFontFamily,
        fontSize: monoLabelSize,
        fontWeight: semibold,
        letterSpacing: 0,
        color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
      );

  /// Converts typography tokens into a [ShadTextTheme].
  ShadTextTheme toShadTextTheme() => ShadTextTheme(family: fontFamily);

  ShadTextTheme _base(BuildContext context) => ShadTheme.of(context).textTheme;
}
