part of '../controls.dart';

/// A linear progress bar, determinate or indeterminate.
///
/// It draws through shad's progress bar. The fill defaults to the palette's
/// `primaryControl` and the track to its `secondary`. Under reduced motion an
/// indeterminate bar is a still segment, so it never animates.
///
/// The bar is one semantics node with [semanticLabel] and a value. The value
/// is [semanticValue], or the rounded percentage when [value] is set.
class ZamProgress extends StatelessWidget {
  /// Creates a [ZamProgress].
  const ZamProgress({
    super.key,
    this.value,
    this.color,
    this.backgroundColor,
    this.minHeight,
    this.borderRadius,
    this.semanticLabel,
    this.semanticValue,
  });

  /// Filled fraction from 0 to 1, clamped. Null means indeterminate.
  final double? value;

  /// Color of the fill.
  final Color? color;

  /// Color of the track behind the fill.
  final Color? backgroundColor;

  /// Height of the bar.
  ///
  /// Defaults to the theme's medium spacing step.
  final double? minHeight;

  /// Corner radius of the bar.
  ///
  /// Defaults to the theme's pill radius.
  final BorderRadius? borderRadius;

  /// Accessible name of the bar.
  final String? semanticLabel;

  /// Accessible value of the bar, such as a localized percentage.
  final String? semanticValue;

  /// Fraction of the track a still indeterminate bar covers.
  static const _stillSegment = 0.35;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final palette = context.zamPalette;
    final fraction = value?.clamp(0.0, 1.0);
    final shown =
        fraction ??
        (MediaQuery.disableAnimationsOf(context) ? _stillSegment : null);
    final spoken =
        semanticValue ??
        (fraction == null ? null : '${(fraction * 100).round()}%');

    return Semantics(
      container: true,
      label: semanticLabel,
      value: spoken,
      child: ExcludeSemantics(
        child: ShadProgress(
          value: shown,
          color: color ?? palette.primaryControl,
          backgroundColor: backgroundColor ?? palette.secondary,
          minHeight: minHeight ?? theme.spacing.md,
          borderRadius: borderRadius ?? theme.radius.pill,
        ),
      ),
    );
  }
}
