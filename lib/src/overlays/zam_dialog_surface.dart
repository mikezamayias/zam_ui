part of '../overlays.dart';

/// The surface of a dialog, for use as the page of [showZamDialog].
///
/// It centers [child], insets it from the screen edges plus the keyboard, and
/// wraps it in a rounded, bordered card that clips its content. The inset
/// follows the keyboard with a short animation, and the keyboard inset is
/// removed from the [MediaQuery] below so content does not apply it twice.
///
/// The surface is at least 280 logical pixels wide, whatever [constraints]
/// say, unless the constraints allow less than that.
class ZamDialogSurface extends StatelessWidget {
  /// Creates a [ZamDialogSurface] around [child].
  const ZamDialogSurface({
    required this.child,
    super.key,
    this.insetPadding,
    this.backgroundColor,
    this.borderColor,
    this.radius,
    this.constraints,
    this.clipBehavior = Clip.antiAlias,
  });

  /// The dialog content.
  final Widget child;

  /// The space between the surface and the screen edges, before the keyboard
  /// inset. Defaults to the theme's dialog inset.
  final EdgeInsetsGeometry? insetPadding;

  /// The surface color. Defaults to the palette's card color.
  final Color? backgroundColor;

  /// The border color. Defaults to the palette's border color.
  final Color? borderColor;

  /// The corner radius. Defaults to the theme's dialog radius.
  final BorderRadiusGeometry? radius;

  /// Size limits for the surface, on top of the 280 pixel minimum width.
  final BoxConstraints? constraints;

  /// How [child] is clipped to the rounded corners.
  final Clip clipBehavior;

  /// The least width of the surface, in logical pixels.
  static const double minWidth = 280;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final palette = context.zamPalette;
    final viewInsets = MediaQuery.viewInsetsOf(context);
    final limits = constraints ?? const BoxConstraints();
    final least = math.min(
      math.max(limits.minWidth, minWidth),
      limits.maxWidth,
    );

    final surface = _ZamOverlaySurface(
      color: backgroundColor ?? palette.card,
      borderColor: borderColor ?? palette.border,
      foreground: palette.cardForeground,
      radius: radius ?? theme.radius.dialog,
      clipBehavior: clipBehavior,
      child: child,
    );

    return AnimatedPadding(
      padding: (insetPadding ?? theme.insets.dialogInset).add(viewInsets),
      duration: ZamDurationToken.short2.duration,
      curve: Curves.decelerate,
      child: MediaQuery.removeViewInsets(
        context: context,
        removeLeft: true,
        removeTop: true,
        removeRight: true,
        removeBottom: true,
        child: Center(
          child: ConstrainedBox(
            constraints: limits.copyWith(minWidth: least),
            child: surface,
          ),
        ),
      ),
    );
  }
}
