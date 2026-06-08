part of '../components.dart';

class ZamIconButton extends StatelessWidget {
  const ZamIconButton({
    required this.icon,
    super.key,
    this.onPressed,
    this.variant = ZamButtonVariant.ghost,
    this.size,
    this.semanticLabel,
  }) : assert(
          onPressed == null || semanticLabel != null,
          'Interactive ZamIconButton instances must provide semanticLabel.',
        );

  final Widget icon;
  final VoidCallback? onPressed;
  final ZamButtonVariant variant;
  final double? size;
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final dimension = size ?? theme.sizes.minTapTarget;
    final shadVariant = switch (variant) {
      ZamButtonVariant.primary => ShadButtonVariant.primary,
      ZamButtonVariant.secondary => ShadButtonVariant.secondary,
      ZamButtonVariant.outline => ShadButtonVariant.outline,
      ZamButtonVariant.ghost => ShadButtonVariant.ghost,
      ZamButtonVariant.destructive => ShadButtonVariant.destructive,
    };

    return Semantics(
      button: true,
      label: semanticLabel,
      onTap: onPressed,
      child: ShadButton.raw(
        variant: shadVariant,
        enabled: onPressed != null,
        onPressed: onPressed,
        width: dimension,
        height: dimension,
        padding: theme.insets.zero,
        child: icon,
      ),
    );
  }
}
