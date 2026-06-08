part of '../components.dart';

class ZamButton extends StatelessWidget {
  const ZamButton({
    required this.label,
    super.key,
    this.onPressed,
    this.variant = ZamButtonVariant.primary,
    this.size = ZamButtonSize.medium,
    this.leading,
    this.isExpanded = false,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback? onPressed;
  final ZamButtonVariant variant;
  final ZamButtonSize size;
  final Widget? leading;
  final bool isExpanded;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final enabled = onPressed != null && !isLoading;
    final shadVariant = switch (variant) {
      ZamButtonVariant.primary => ShadButtonVariant.primary,
      ZamButtonVariant.secondary => ShadButtonVariant.secondary,
      ZamButtonVariant.outline => ShadButtonVariant.outline,
      ZamButtonVariant.ghost => ShadButtonVariant.ghost,
      ZamButtonVariant.destructive => ShadButtonVariant.destructive,
    };
    final shadSize = switch (size) {
      ZamButtonSize.small => ShadButtonSize.sm,
      ZamButtonSize.medium => ShadButtonSize.regular,
      ZamButtonSize.large => ShadButtonSize.lg,
    };

    return Semantics(
      button: true,
      label: label,
      onTap: enabled ? onPressed : null,
      child: ShadButton.raw(
        variant: shadVariant,
        size: shadSize,
        enabled: enabled,
        onPressed: enabled ? onPressed : null,
        leading: isLoading ? const _ZamLoadingDot() : leading,
        width: isExpanded ? double.infinity : null,
        height: theme.sizes.buttonLargeHeight,
        gap: theme.spacing.eight,
        child: Text(label),
      ),
    );
  }
}
