part of '../components.dart';

/// Icon button component requiring semantic labels for interactive instances.
class ZamIconButton extends StatelessWidget {
  /// Creates a [ZamIconButton].
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

  /// Icon widget to display.
  final Widget icon;

  /// Callback executed when pressed.
  final VoidCallback? onPressed;

  /// Visual variant style.
  final ZamButtonVariant variant;

  /// Custom dimension (width and height).
  final double? size;

  /// Accessibility semantic label.
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
      ZamButtonVariant.link => ShadButtonVariant.link,
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
