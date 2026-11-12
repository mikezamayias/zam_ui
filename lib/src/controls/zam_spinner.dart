part of '../controls.dart';

/// An indeterminate circular loading indicator.
///
/// It spins through shad's spinner. When the platform asks to reduce motion,
/// it draws a still arc instead, so the indicator never animates.
///
/// A spinner has no meaning for a screen reader unless it has a
/// [semanticLabel], which is then announced as a live region.
class ZamSpinner extends StatelessWidget {
  /// Creates a [ZamSpinner].
  const ZamSpinner({
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
    this.semanticLabel,
  });

  /// Diameter of the spinner.
  ///
  /// Defaults to the theme's small icon size.
  final double? size;

  /// Color of the moving arc.
  ///
  /// Defaults to the ambient icon color, then to the palette's primary.
  final Color? color;

  /// Thickness of the arc.
  ///
  /// Defaults to the theme's progress stroke.
  final double? strokeWidth;

  /// Accessible name announced while the spinner is visible.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final dimension = size ?? theme.sizes.iconSm;
    final stroke = strokeWidth ?? theme.strokes.progress;

    final Widget spinner;
    if (MediaQuery.disableAnimationsOf(context)) {
      final arcColor =
          color ?? IconTheme.of(context).color ?? context.zamPalette.primary;
      spinner = SizedBox.square(
        dimension: dimension,
        child: CustomPaint(
          painter: _ZamStaticSpinnerPainter(
            color: arcColor,
            trackColor: theme.opacities.apply(
              arcColor,
              theme.opacities.overlay,
            ),
            strokeWidth: stroke,
          ),
        ),
      );
    } else {
      spinner = ShadSpinner(size: dimension, color: color, strokeWidth: stroke);
    }

    if (semanticLabel == null) return ExcludeSemantics(child: spinner);
    return Semantics(
      role: SemanticsRole.loadingSpinner,
      label: semanticLabel,
      liveRegion: true,
      child: ExcludeSemantics(child: spinner),
    );
  }
}
