part of '../components.dart';

class ZamSurface extends StatelessWidget {
  const ZamSurface({
    required this.child,
    super.key,
    this.padding,
    this.margin,
    this.backgroundColor,
    this.borderColor,
    this.radius,
    this.withShadow = false,
    this.onTap,
    this.semanticLabel,
  }) : assert(
          onTap == null || semanticLabel != null,
          'Interactive ZamSurface instances must provide semanticLabel.',
        );

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? radius;
  final bool withShadow;
  final VoidCallback? onTap;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final shad = ShadTheme.of(context);
    final scheme = shad.colorScheme;
    final surface = Container(
      margin: margin,
      padding: padding ?? theme.insets.card,
      decoration: BoxDecoration(
        color: backgroundColor ?? scheme.card,
        borderRadius: radius ?? theme.radius.xl,
        border: Border.fromBorderSide(
          theme.strokes.border(borderColor ?? scheme.border),
        ),
        boxShadow: withShadow ? theme.shadows.card(shad.brightness) : null,
      ),
      child: child,
    );

    if (onTap == null) return surface;

    return Semantics(
      button: true,
      label: semanticLabel,
      onTap: onTap,
      child: GestureDetector(onTap: onTap, child: surface),
    );
  }
}
