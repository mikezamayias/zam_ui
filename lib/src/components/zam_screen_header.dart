part of '../components.dart';

class ZamScreenHeader extends StatelessWidget {
  const ZamScreenHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.onBack,
    this.trailing,
    this.padding,
    this.compact = false,
    this.backLabel = 'Back',
  });

  final String title;
  final String? subtitle;
  final VoidCallback? onBack;
  final Widget? trailing;
  final EdgeInsetsGeometry? padding;
  final bool compact;
  final String backLabel;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return Padding(
      padding: padding ?? theme.insets.screenHeader,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onBack != null)
            Padding(
              padding: theme.insets.only(bottom: theme.spacing.eight),
              child: Semantics(
                button: true,
                label: backLabel,
                onTap: onBack,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onBack,
                  child: ConstrainedBox(
                    constraints: theme.sizes.minTapTargetConstraints,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          theme.icons.back,
                          size: theme.sizes.iconLg,
                          color: scheme.foreground,
                        ),
                        SizedBox(width: theme.spacing.four),
                        Text(
                          backLabel,
                          style: theme.typography.label(
                            context,
                            color: scheme.foreground,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: compact
                          ? theme.typography.emptyTitle(context)
                          : theme.typography.screenTitle(context),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: theme.spacing.two),
                      Text(
                        subtitle!,
                        style: theme.typography.bodySmall(context),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: theme.spacing.twelve),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
