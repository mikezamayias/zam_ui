part of '../tokens.dart';

class ZamTypographyTokens {
  const ZamTypographyTokens({
    required this.fontFamily,
    this.monoFontFamily = 'monospace',
  });

  final String fontFamily;
  final String monoFontFamily;

  double get displaySize => 28;
  double get screenTitleSize => 24;
  double get emptyTitleSize => 20;
  double get titleSize => 18;
  double get bodySize => 14;
  double get bodyLargeSize => 16;
  double get bodySmallSize => 13;
  double get labelSize => 12;
  double get captionSize => 11;
  double get monoLabelSize => 10;
  double get bodyLineHeight => 1.5;
  double get inputLineHeight => 1.58;

  FontWeight get regular => FontWeight.w400;
  FontWeight get medium => FontWeight.w500;
  FontWeight get semibold => FontWeight.w600;
  FontWeight get bold => FontWeight.w700;

  TextStyle display(BuildContext context, {Color? color}) =>
      _base(context).h1.copyWith(
            fontFamily: fontFamily,
            fontSize: displaySize,
            fontWeight: bold,
            letterSpacing: 0,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle screenTitle(BuildContext context, {Color? color}) =>
      _base(context).h2.copyWith(
            fontFamily: fontFamily,
            fontSize: screenTitleSize,
            fontWeight: bold,
            letterSpacing: 0,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle emptyTitle(BuildContext context, {Color? color}) =>
      _base(context).h3.copyWith(
            fontFamily: fontFamily,
            fontSize: emptyTitleSize,
            fontWeight: semibold,
            letterSpacing: 0,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle title(BuildContext context, {Color? color}) =>
      _base(context).large.copyWith(
            fontFamily: fontFamily,
            fontSize: titleSize,
            fontWeight: semibold,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle body(BuildContext context, {Color? color}) =>
      _base(context).p.copyWith(
            fontFamily: fontFamily,
            fontSize: bodySize,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle bodyLarge(BuildContext context, {Color? color}) =>
      _base(context).p.copyWith(
            fontFamily: fontFamily,
            fontSize: bodyLargeSize,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle bodySmall(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
            fontFamily: fontFamily,
            fontSize: bodySmallSize,
            color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
          );

  TextStyle label(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
            fontFamily: fontFamily,
            fontSize: labelSize,
            fontWeight: semibold,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle caption(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
            fontFamily: fontFamily,
            fontSize: captionSize,
            color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
          );

  TextStyle monoCaption(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: monoFontFamily,
        fontSize: captionSize,
        color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
      );

  TextStyle monoCaps(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: monoFontFamily,
        fontSize: monoLabelSize,
        fontWeight: semibold,
        letterSpacing: 0,
        color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
      );

  ShadTextTheme toShadTextTheme() => ShadTextTheme(family: fontFamily);

  ShadTextTheme _base(BuildContext context) => ShadTheme.of(context).textTheme;
}
