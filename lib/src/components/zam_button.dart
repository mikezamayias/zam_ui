part of '../components.dart';

class ZamButton extends StatelessWidget {
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
  }) : assert(
          label != null || child != null,
          'ZamButton requires either label or child.',
        );

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
  })  : assert(
          label != null || child != null,
          'ZamButton.outline requires either label or child.',
        ),
        variant = ZamButtonVariant.outline;

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
  })  : assert(
          label != null || child != null,
          'ZamButton.destructive requires either label or child.',
        ),
        variant = ZamButtonVariant.destructive;

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
  })  : assert(
          label != null || child != null,
          'ZamButton.link requires either label or child.',
        ),
        variant = ZamButtonVariant.link;

  final String? label;
  final Widget? child;
  final VoidCallback? onPressed;
  final ZamButtonVariant variant;
  final ZamButtonSize size;
  final Widget? leading;
  final Widget? trailing;
  final bool isExpanded;
  final bool isLoading;
  final bool? enabled;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;

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

    return Semantics(
      button: true,
      label: label,
      onTap: effectiveEnabled ? onPressed : null,
      child: ShadButton.raw(
        variant: shadVariant,
        size: shadSize,
        enabled: effectiveEnabled,
        onPressed: effectiveEnabled ? onPressed : null,
        leading: isLoading ? const _ZamLoadingDot() : leading,
        trailing: trailing,
        width: isExpanded ? double.infinity : width,
        height: height ?? theme.sizes.buttonLargeHeight,
        padding: padding,
        gap: theme.spacing.eight,
        child: child ?? Text(effectiveLabel),
      ),
    );
  }
}
