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
      margin: onTap == null ? margin : null,
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

    final pressable = Semantics(
      button: true,
      label: semanticLabel,
      onTap: onTap,
      child: _ZamPressable(
        onTap: onTap!,
        radius: radius ?? theme.radius.xl,
        child: surface,
      ),
    );
    return margin == null
        ? pressable
        : Padding(padding: margin!, child: pressable);
  }
}

/// Keyboard-focusable, hoverable pressable with an overlay and a focus ring.
class _ZamPressable extends StatefulWidget {
  const _ZamPressable({
    required this.onTap,
    required this.radius,
    required this.child,
  });

  final VoidCallback onTap;
  final BorderRadiusGeometry radius;
  final Widget child;

  @override
  State<_ZamPressable> createState() => _ZamPressableState();
}

class _ZamPressableState extends State<_ZamPressable> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  void _set(VoidCallback update) => setState(update);

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;
    final overlay = _pressed
        ? theme.opacities.apply(scheme.foreground, theme.opacities.pressed)
        : _hovered
        ? theme.opacities.apply(scheme.foreground, theme.opacities.whisper)
        : theme.colors.transparent;

    return FocusableActionDetector(
      onShowFocusHighlight: (value) => _set(() => _focused = value),
      // Web maps Enter to ButtonActivateIntent and Space to ActivateIntent.
      actions: {
        ActivateIntent: CallbackAction<ActivateIntent>(
          onInvoke: (_) {
            widget.onTap();
            return null;
          },
        ),
        ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
          onInvoke: (_) {
            widget.onTap();
            return null;
          },
        ),
      },
      // Hover is tracked here, not through the detector's hover highlight,
      // because that one only fires in keyboard-driven highlight mode.
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => _set(() => _hovered = true),
        onExit: (_) => _set(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.onTap,
          onTapDown: (_) => _set(() => _pressed = true),
          onTapUp: (_) => _set(() => _pressed = false),
          onTapCancel: () => _set(() => _pressed = false),
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              color: overlay,
              borderRadius: widget.radius,
              border: _focused
                  ? Border.fromBorderSide(
                      BorderSide(
                        color: scheme.ring,
                        width: theme.strokes.focusRing,
                      ),
                    )
                  : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
