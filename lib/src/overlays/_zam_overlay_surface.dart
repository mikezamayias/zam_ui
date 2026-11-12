part of '../overlays.dart';

/// The filled, bordered and clipped surface of a dialog or a sheet.
///
/// The border is painted above the content, as a Material surface does, so
/// content that fills the surface cannot cover it. Text below it takes
/// [foreground] as its color.
class _ZamOverlaySurface extends StatelessWidget {
  const _ZamOverlaySurface({
    required this.color,
    required this.borderColor,
    required this.foreground,
    required this.radius,
    required this.clipBehavior,
    required this.child,
  });

  final Color color;
  final Color borderColor;
  final Color foreground;
  final BorderRadiusGeometry radius;
  final Clip clipBehavior;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;

    return ClipRRect(
      borderRadius: radius,
      clipBehavior: clipBehavior,
      child: DecoratedBox(
        position: DecorationPosition.foreground,
        decoration: BoxDecoration(
          borderRadius: radius,
          border: Border.fromBorderSide(theme.strokes.border(borderColor)),
        ),
        child: ColoredBox(
          color: color,
          child: DefaultTextStyle.merge(
            style: TextStyle(color: foreground),
            child: child,
          ),
        ),
      ),
    );
  }
}
