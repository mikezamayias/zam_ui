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
    this.displaySize = 28,
    this.screenTitleSize = 24,
    this.emptyTitleSize = 20,
    this.titleSize = 18,
    this.bodySize = 14,
    this.bodyLargeSize = 16,
    this.bodySmallSize = 13,
    this.labelSize = 12,
    this.captionSize = 11,
    this.monoLabelSize = 10,
    this.bodyLineHeight = 1.5,
    this.inputLineHeight = 1.58,
    this.regular = FontWeight.w400,
    this.medium = FontWeight.w500,
    this.semibold = FontWeight.w600,
    this.bold = FontWeight.w700,
    this.extraBold = FontWeight.w800,
    this.light = FontWeight.w300,
    this.fontFamilyFallback = const <String>[],
  });

  /// Primary app font family name.
  final String fontFamily;

  /// Monospace app font family name.
  final String monoFontFamily;

  /// Families tried, in order, for characters the font has no glyph for.
  ///
  /// The consuming app loads these fonts too. Empty leaves the fallback to
  /// the platform.
  final List<String> fontFamilyFallback;

  /// Large display heading font size (28).
  final double displaySize;

  /// Top-level screen title font size (24).
  final double screenTitleSize;

  /// Empty state title font size (20).
  final double emptyTitleSize;

  /// Section heading font size (18).
  final double titleSize;

  /// Regular body text font size (14).
  final double bodySize;

  /// Large body text font size (16).
  final double bodyLargeSize;

  /// Small body text font size (13).
  final double bodySmallSize;

  /// Label font size (12).
  final double labelSize;

  /// Secondary caption font size (11).
  final double captionSize;

  /// Monospace label font size (10).
  final double monoLabelSize;

  /// Standard line height multiplier for body text (1.5).
  final double bodyLineHeight;

  /// Standard line height multiplier for form inputs (1.58).
  final double inputLineHeight;

  /// Regular font weight (w400).
  final FontWeight regular;

  /// Medium font weight (w500).
  final FontWeight medium;

  /// Semibold font weight (w600).
  final FontWeight semibold;

  /// Bold font weight (w700).
  final FontWeight bold;

  /// Extra bold font weight (w800).
  final FontWeight extraBold;

  /// Light font weight (w300).
  final FontWeight light;

  /// Returns [TextStyle] for large display headings.
  TextStyle display(BuildContext context, {Color? color}) =>
      _base(context).h1.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallback,
        fontSize: displaySize,
        fontWeight: bold,
        letterSpacing: 0,
        color: color ?? ShadTheme.of(context).colorScheme.foreground,
      );

  /// Returns [TextStyle] for main screen headers.
  TextStyle screenTitle(BuildContext context, {Color? color}) =>
      _base(context).h2.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallback,
        fontSize: screenTitleSize,
        fontWeight: bold,
        letterSpacing: 0,
        color: color ?? ShadTheme.of(context).colorScheme.foreground,
      );

  /// Returns [TextStyle] for empty state titles.
  TextStyle emptyTitle(BuildContext context, {Color? color}) =>
      _base(context).h3.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallback,
        fontSize: emptyTitleSize,
        fontWeight: semibold,
        letterSpacing: 0,
        color: color ?? ShadTheme.of(context).colorScheme.foreground,
      );

  /// Returns [TextStyle] for card and section titles.
  TextStyle title(BuildContext context, {Color? color}) =>
      _base(context).large.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallback,
        fontSize: titleSize,
        fontWeight: semibold,
        color: color ?? ShadTheme.of(context).colorScheme.foreground,
      );

  /// Returns standard body [TextStyle].
  TextStyle body(BuildContext context, {Color? color}) =>
      _base(context).p.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallback,
        fontSize: bodySize,
        color: color ?? ShadTheme.of(context).colorScheme.foreground,
      );

  /// Returns large body [TextStyle].
  TextStyle bodyLarge(BuildContext context, {Color? color}) =>
      _base(context).p.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallback,
        fontSize: bodyLargeSize,
        color: color ?? ShadTheme.of(context).colorScheme.foreground,
      );

  /// Returns small body [TextStyle].
  TextStyle bodySmall(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallback,
        fontSize: bodySmallSize,
        color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
      );

  /// Returns label [TextStyle].
  TextStyle label(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallback,
        fontSize: labelSize,
        fontWeight: semibold,
        color: color ?? ShadTheme.of(context).colorScheme.foreground,
      );

  /// Returns secondary caption [TextStyle].
  TextStyle caption(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
        fontFamily: fontFamily,
        fontFamilyFallback: _fallback,
        fontSize: captionSize,
        color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
      );

  /// Returns monospace caption [TextStyle].
  TextStyle monoCaption(BuildContext context, {Color? color}) => TextStyle(
    fontFamily: monoFontFamily,
    fontFamilyFallback: _fallback,
    fontSize: captionSize,
    color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
  );

  /// Returns uppercase monospace label [TextStyle].
  TextStyle monoCaps(BuildContext context, {Color? color}) => TextStyle(
    fontFamily: monoFontFamily,
    fontFamilyFallback: _fallback,
    fontSize: monoLabelSize,
    fontWeight: semibold,
    letterSpacing: 0,
    color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZamTypographyTokens &&
          other.runtimeType == runtimeType &&
          other.fontFamily == fontFamily &&
          other.monoFontFamily == monoFontFamily &&
          other.displaySize == displaySize &&
          other.screenTitleSize == screenTitleSize &&
          other.emptyTitleSize == emptyTitleSize &&
          other.titleSize == titleSize &&
          other.bodySize == bodySize &&
          other.bodyLargeSize == bodyLargeSize &&
          other.bodySmallSize == bodySmallSize &&
          other.labelSize == labelSize &&
          other.captionSize == captionSize &&
          other.monoLabelSize == monoLabelSize &&
          other.bodyLineHeight == bodyLineHeight &&
          other.inputLineHeight == inputLineHeight &&
          other.regular == regular &&
          other.medium == medium &&
          other.semibold == semibold &&
          other.bold == bold &&
          other.extraBold == extraBold &&
          other.light == light &&
          listEquals(other.fontFamilyFallback, fontFamilyFallback);

  @override
  int get hashCode => Object.hashAll([
    fontFamily,
    monoFontFamily,
    displaySize,
    screenTitleSize,
    emptyTitleSize,
    titleSize,
    bodySize,
    bodyLargeSize,
    bodySmallSize,
    labelSize,
    captionSize,
    monoLabelSize,
    bodyLineHeight,
    inputLineHeight,
    regular,
    medium,
    semibold,
    bold,
    extraBold,
    light,
    Object.hashAll(fontFamilyFallback),
  ]);

  /// Converts typography tokens into a [ShadTextTheme] with [fontFamily] and
  /// [fontFamilyFallback] on every style.
  ShadTextTheme toShadTextTheme() {
    final theme = ShadTextTheme(family: fontFamily);
    if (fontFamilyFallback.isEmpty) return theme;
    return theme.apply(fontFamilyFallback: fontFamilyFallback);
  }

  // Null keeps the base style's fallback, so an empty list changes nothing.
  List<String>? get _fallback =>
      fontFamilyFallback.isEmpty ? null : fontFamilyFallback;

  ShadTextTheme _base(BuildContext context) => ShadTheme.of(context).textTheme;
}
