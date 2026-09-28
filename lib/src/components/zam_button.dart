part of '../components.dart';

/// Primary button component supporting multiple variants, sizes, loading states, and leading/trailing slots.
class ZamButton extends StatelessWidget {
  /// Creates a standard [ZamButton].
  const ZamButton({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.variant = ZamButtonVariant.primary,
    this.size = ZamButtonSize.medium,
    this.leading,
    this.trailing,
    this.isExpanded = false,
    this.isLoading = false,
    this.enabled,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.pressedBackgroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderRadius,
    this.textStyle,
  })  : assert(
          label != null || child != null,
          'ZamButton requires either label or child.',
        ),
        assert(
          label != null ||
              (disabledBackgroundColor == null &&
                  disabledForegroundColor == null),
          'ZamButton needs a label to draw disabled colors, so a screen reader '
          'hears it as disabled.',
        );

  /// Creates an outlined variant [ZamButton].
  const ZamButton.outline({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.size = ZamButtonSize.medium,
    this.leading,
    this.trailing,
    this.isExpanded = false,
    this.isLoading = false,
    this.enabled,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.pressedBackgroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderRadius,
    this.textStyle,
  })  : assert(
          label != null || child != null,
          'ZamButton.outline requires either label or child.',
        ),
        assert(
          label != null ||
              (disabledBackgroundColor == null &&
                  disabledForegroundColor == null),
          'ZamButton.outline needs a label to draw disabled colors, so a screen '
          'reader hears it as disabled.',
        ),
        variant = ZamButtonVariant.outline;

  /// Creates a destructive variant [ZamButton].
  const ZamButton.destructive({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.size = ZamButtonSize.medium,
    this.leading,
    this.trailing,
    this.isExpanded = false,
    this.isLoading = false,
    this.enabled,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.pressedBackgroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderRadius,
    this.textStyle,
  })  : assert(
          label != null || child != null,
          'ZamButton.destructive requires either label or child.',
        ),
        assert(
          label != null ||
              (disabledBackgroundColor == null &&
                  disabledForegroundColor == null),
          'ZamButton.destructive needs a label to draw disabled colors, so a screen '
          'reader hears it as disabled.',
        ),
        variant = ZamButtonVariant.destructive;

  /// Creates a link variant [ZamButton].
  const ZamButton.link({
    super.key,
    this.label,
    this.child,
    this.onPressed,
    this.size = ZamButtonSize.medium,
    this.leading,
    this.trailing,
    this.isExpanded = false,
    this.isLoading = false,
    this.enabled,
    this.width,
    this.height,
    this.padding,
    this.backgroundColor,
    this.foregroundColor,
    this.pressedBackgroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.borderRadius,
    this.textStyle,
  })  : assert(
          label != null || child != null,
          'ZamButton.link requires either label or child.',
        ),
        assert(
          label != null ||
              (disabledBackgroundColor == null &&
                  disabledForegroundColor == null),
          'ZamButton.link needs a label to draw disabled colors, so a screen '
          'reader hears it as disabled.',
        ),
        variant = ZamButtonVariant.link;

  /// Button text label.
  final String? label;

  /// Custom child widget.
  final Widget? child;

  /// Callback executed when the button is pressed.
  final VoidCallback? onPressed;

  /// Visual variant style.
  final ZamButtonVariant variant;

  /// Size configuration.
  final ZamButtonSize size;

  /// Optional leading widget (icon/avatar).
  final Widget? leading;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Whether the button should expand to fill horizontal width.
  final bool isExpanded;

  /// Whether to display a loading indicator.
  final bool isLoading;

  /// Explicit enable/disable state override.
  final bool? enabled;

  /// Custom width.
  final double? width;

  /// Custom height.
  final double? height;

  /// Custom padding.
  final EdgeInsetsGeometry? padding;

  /// Fill in the default, hovered, and focused states.
  final Color? backgroundColor;

  /// Label and icon color in the default, hovered, and pressed states.
  final Color? foregroundColor;

  /// Fill while pressed, such as the fill with a state layer composited.
  final Color? pressedBackgroundColor;

  /// Fill while disabled.
  ///
  /// When this or [disabledForegroundColor] is set, a disabled button draws
  /// the disabled colors at full opacity instead of fading to 50%, and it
  /// needs a [label].
  final Color? disabledBackgroundColor;

  /// Label and icon color while disabled.
  ///
  /// When this or [disabledBackgroundColor] is set, a disabled button draws
  /// the disabled colors at full opacity instead of fading to 50%, and it
  /// needs a [label].
  final Color? disabledForegroundColor;

  /// Corner radius, such as a pill. The focus ring follows it.
  final BorderRadius? borderRadius;

  /// Label style; the foreground color still applies on top of it.
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final hasAction = onPressed != null;
    final effectiveEnabled = (enabled ?? hasAction) && hasAction && !isLoading;
    final effectiveLabel = label ?? '';
    final shadVariant = switch (variant) {
      ZamButtonVariant.primary => ShadButtonVariant.primary,
      ZamButtonVariant.secondary => ShadButtonVariant.secondary,
      ZamButtonVariant.outline => ShadButtonVariant.outline,
      ZamButtonVariant.ghost => ShadButtonVariant.ghost,
      ZamButtonVariant.destructive => ShadButtonVariant.destructive,
      ZamButtonVariant.link => ShadButtonVariant.link,
    };
    final shadSize = switch (size) {
      ZamButtonSize.small || ZamButtonSize.sm => ShadButtonSize.sm,
      ZamButtonSize.medium || ZamButtonSize.regular => ShadButtonSize.regular,
      ZamButtonSize.large || ZamButtonSize.lg => ShadButtonSize.lg,
    };

    // With a disabled color set, ShadButton stays enabled so it skips its
    // 50% fade; the pointer, focus, and semantics are disabled here instead.
    final drawsDisabledColors = !effectiveEnabled &&
        (disabledBackgroundColor != null || disabledForegroundColor != null);
    final fill = drawsDisabledColors
        ? disabledBackgroundColor ?? backgroundColor
        : backgroundColor;
    final foreground = drawsDisabledColors
        ? disabledForegroundColor ?? foregroundColor
        : foregroundColor;
    final radius = borderRadius;
    final focusRing = ShadTheme.of(context).decoration.secondaryFocusedBorder;

    Widget button = ShadButton.raw(
      variant: shadVariant,
      size: shadSize,
      enabled: effectiveEnabled || drawsDisabledColors,
      canRequestFocus: effectiveEnabled,
      onPressed: effectiveEnabled ? onPressed : null,
      leading: isLoading ? const _ZamLoadingDot() : leading,
      trailing: trailing,
      width: isExpanded ? double.infinity : width,
      height: height ?? theme.sizes.buttonLargeHeight,
      padding: padding,
      gap: theme.spacing.eight,
      backgroundColor: fill,
      hoverBackgroundColor: fill,
      pressedBackgroundColor:
          drawsDisabledColors ? fill : pressedBackgroundColor,
      foregroundColor: foreground,
      hoverForegroundColor: foreground,
      pressedForegroundColor: foreground,
      textStyle: textStyle,
      decoration: radius == null
          ? null
          : ShadDecoration(
              border: ShadBorder(radius: radius),
              secondaryFocusedBorder: focusRing?.copyWith(
                radius: radius + BorderRadius.circular(focusRing.offset ?? 0),
              ),
            ),
      child: child ?? Text(effectiveLabel),
    );

    if (drawsDisabledColors) {
      button = IgnorePointer(child: button);
    }

    // Without a label, ShadButton's own container node reads the child.
    // The constructor asserts a label for disabled colors, because that node
    // would report enabled while ShadButton stays enabled to draw them.
    if (label == null) return button;

    // With a label, this container replaces ShadButton's node, so a screen
    // reader finds one stop and a disabled label never merges upward.
    return Semantics(
      container: true,
      button: true,
      enabled: effectiveEnabled,
      focusable: effectiveEnabled,
      label: label,
      onTap: effectiveEnabled ? onPressed : null,
      excludeSemantics: true,
      child: button,
    );
  }
}
