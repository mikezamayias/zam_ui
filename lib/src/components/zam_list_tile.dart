part of '../components.dart';

/// List tile component displaying leading slot, title, subtitle, trailing slot, and optional bottom divider.
class ZamListTile extends StatelessWidget {
  /// Creates a [ZamListTile].
  const ZamListTile({
    required this.title,
    super.key,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.semanticLabel,
    this.padding,
    this.showDivider = false,
    this.dense = false,
  }) : assert(
          onTap == null || semanticLabel != null,
          'Interactive ZamListTile instances must provide semanticLabel.',
        );

  /// Main title text.
  final String title;

  /// Optional subtitle text.
  final String? subtitle;

  /// Optional leading widget (icon/avatar).
  final Widget? leading;

  /// Optional trailing widget.
  final Widget? trailing;

  /// Tap callback for interactive tiles.
  final VoidCallback? onTap;

  /// Accessibility semantic label.
  final String? semanticLabel;

  /// Custom padding.
  final EdgeInsetsGeometry? padding;

  /// Whether to display a bottom divider.
  final bool showDivider;

  /// Whether to render in dense compact padding mode.
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;
    final effectivePadding =
        padding ?? (dense ? theme.insets.denseCard : theme.insets.tile);

    final content = Padding(
      padding: effectivePadding,
      child: Row(
        children: [
          if (leading != null) ...[
            leading!,
            SizedBox(width: theme.spacing.twelve),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.typography.body(context),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: theme.spacing.two),
                  Text(
                    subtitle!,
                    style: theme.typography.bodySmall(
                      context,
                      color: scheme.mutedForeground,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            SizedBox(width: theme.spacing.twelve),
            trailing!,
          ] else if (onTap != null) ...[
            SizedBox(width: theme.spacing.eight),
            Icon(
              theme.icons.chevronRight,
              size: theme.sizes.iconSm,
              color: scheme.mutedForeground,
            ),
          ],
        ],
      ),
    );

    final tile = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onTap != null)
          Semantics(
            button: true,
            label: semanticLabel,
            onTap: onTap,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: onTap,
              child: content,
            ),
          )
        else
          content,
        if (showDivider)
          ZamDivider(
            indent: leading != null
                ? (effectivePadding.resolve(TextDirection.ltr).left +
                    theme.sizes.iconMd +
                    theme.spacing.twelve)
                : effectivePadding.resolve(TextDirection.ltr).left,
          ),
      ],
    );

    return tile;
  }
}
