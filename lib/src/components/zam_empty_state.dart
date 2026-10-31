part of '../components.dart';

/// Empty state placeholder component displaying an icon container, title, message, and optional action button.
class ZamEmptyState extends StatelessWidget {
  /// Creates a [ZamEmptyState].
  const ZamEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.action,
  });

  /// Icon data for empty state graphic.
  final IconData icon;

  /// Main empty state title.
  final String title;

  /// Explanatory empty state message.
  final String message;

  /// Optional call-to-action button.
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: theme.insets.symmetric(
          horizontal: theme.spacing.md,
          vertical: theme.spacing(5),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: theme.sizes.emptyIconContainer,
              height: theme.sizes.emptyIconContainer,
              decoration: BoxDecoration(
                color: theme.opacities.apply(
                  scheme.primary,
                  theme.opacities.tint,
                ),
                borderRadius: theme.radius.dialog,
              ),
              child: Icon(
                icon,
                size: theme.sizes.iconHero,
                color: theme.opacities.apply(
                  scheme.primary,
                  theme.opacities.iconEmphasis,
                ),
              ),
            ),
            SizedBox(height: theme.spacing.md),
            Text(
              title,
              style: theme.typography.emptyTitle(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: theme.spacing(1.5)),
            ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: theme.sizes.emptyMessageWidth,
              ),
              child: Text(
                message,
                style: theme.typography
                    .bodySmall(context, color: scheme.mutedForeground)
                    .copyWith(height: theme.typography.bodyLineHeight),
                textAlign: TextAlign.center,
              ),
            ),
            if (action != null) ...[
              SizedBox(height: theme.spacing(4.5)),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
