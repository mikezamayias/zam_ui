part of '../components.dart';

class ZamEmptyState extends StatelessWidget {
  const ZamEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    super.key,
    this.action,
  });

  final IconData icon;
  final String title;
  final String message;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return Center(
      child: SingleChildScrollView(
        padding: theme.insets.symmetric(
          horizontal: theme.spacing.sixteen,
          vertical: theme.spacing.twenty,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: theme.sizes.emptyIconContainer,
              height: theme.sizes.emptyIconContainer,
              decoration: BoxDecoration(
                color:
                    theme.opacities.apply(scheme.primary, theme.opacities.tint),
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
            SizedBox(height: theme.spacing.sixteen),
            Text(
              title,
              style: theme.typography.emptyTitle(context),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: theme.spacing.six),
            ConstrainedBox(
              constraints:
                  BoxConstraints(maxWidth: theme.sizes.emptyMessageWidth),
              child: Text(
                message,
                style: theme.typography
                    .bodySmall(context, color: scheme.mutedForeground)
                    .copyWith(height: theme.typography.bodyLineHeight),
                textAlign: TextAlign.center,
              ),
            ),
            if (action != null) ...[
              SizedBox(height: theme.spacing.eighteen),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
