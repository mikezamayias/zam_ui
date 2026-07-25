part of '../components.dart';

/// Elevated card or container surface component with token-driven borders, shadows, and padding.
class ZamSurface extends StatelessWidget {
  /// Creates a [ZamSurface].
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

  /// Inner child content.
  final Widget child;

  /// Custom padding.
  final EdgeInsetsGeometry? padding;

  /// Custom margin.
  final EdgeInsetsGeometry? margin;

  /// Surface background color override.
  final Color? backgroundColor;

  /// Border color override.
  final Color? borderColor;

  /// Border radius override.
  final BorderRadiusGeometry? radius;

  /// Whether to render elevation shadow.
  final bool withShadow;

  /// Optional tap callback.
  final VoidCallback? onTap;

  /// Accessibility semantic label when interactive.
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
