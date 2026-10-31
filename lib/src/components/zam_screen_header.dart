part of '../components.dart';

/// Screen header component providing title, optional subtitle, back navigation, and trailing actions.
class ZamScreenHeader extends StatelessWidget {
  /// Creates a [ZamScreenHeader].
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

  /// Main screen title text.
  final String title;

  /// Optional secondary subtitle text.
  final String? subtitle;

  /// Optional back button action callback.
  final VoidCallback? onBack;

  /// Optional trailing action widget.
  final Widget? trailing;

  /// Custom padding around header.
  final EdgeInsetsGeometry? padding;

  /// Whether to render a compact header title style.
  final bool compact;

  /// Accessibility semantic label for back action button.
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
              padding: theme.insets.only(bottom: theme.spacing.sm),
              child: Semantics(
                button: true,
                label: backLabel,
                onTap: onBack,
                child: _ZamPressable(
                  onTap: onBack!,
                  radius: theme.radius.md,
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
                        SizedBox(width: theme.spacing.xs),
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
                      SizedBox(height: theme.spacing(0.5)),
                      Text(
                        subtitle!,
                        style: theme.typography.bodySmall(context),
                      ),
                    ],
                  ],
                ),
              ),
              if (trailing != null) ...[
                SizedBox(width: theme.spacing(3)),
                trailing!,
              ],
            ],
          ),
        ],
      ),
    );
  }
}
