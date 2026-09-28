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
    this.style,
  }) : assert(
          label != null || child != null,
          'ZamButton requires either label or child.',
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
    this.style,
  })  : assert(
          label != null || child != null,
          'ZamButton.outline requires either label or child.',
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
    this.style,
  })  : assert(
          label != null || child != null,
          'ZamButton.destructive requires either label or child.',
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
    this.style,
  })  : assert(
          label != null || child != null,
          'ZamButton.link requires either label or child.',
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

  /// Style overrides; null keeps the variant's theme look.
  final ZamButtonStyle? style;

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

    final overrides = style ?? const ZamButtonStyle();
    assert(
      label != null || !overrides.hasDisabledColors,
      'ZamButton needs a label to draw disabled colors, so a screen reader '
      'hears it as disabled.',
    );
    // With a disabled color set, ShadButton stays enabled so it skips its
    // 50% fade; the pointer, focus, and semantics are disabled here instead.
    final drawsDisabledColors =
        !effectiveEnabled && overrides.hasDisabledColors;
    final fill = drawsDisabledColors
        ? overrides.disabledBackgroundColor ?? overrides.backgroundColor
        : overrides.backgroundColor;
    final foreground = drawsDisabledColors
        ? overrides.disabledForegroundColor ?? overrides.foregroundColor
        : overrides.foregroundColor;
    final radius = overrides.radius;
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
          drawsDisabledColors ? fill : overrides.pressedBackgroundColor,
      foregroundColor: foreground,
      hoverForegroundColor: foreground,
      pressedForegroundColor: foreground,
      textStyle: overrides.textStyle,
      decoration: radius == null
          ? null
          : ShadDecoration(
              border: ShadBorder(radius: radius),
              secondaryFocusedBorder: focusRing?.copyWith(
                radius:
                    radius.add(BorderRadius.circular(focusRing.offset ?? 0)),
              ),
            ),
      child: child ?? Text(effectiveLabel),
    );

    if (drawsDisabledColors) {
      button = IgnorePointer(child: button);
    }

    // Without a label, ShadButton's own container node reads the child.
    // Disabled colors need a label (asserted above), because that node
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
