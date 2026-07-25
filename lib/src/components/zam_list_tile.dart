part of '../components.dart';

class ZamListTile extends StatelessWidget {
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

  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final String? semanticLabel;
  final EdgeInsetsGeometry? padding;
  final bool showDivider;
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
