part of '../components.dart';

class _ZamLoadingDot extends StatelessWidget {
  const _ZamLoadingDot();

  @override
  Widget build(BuildContext context) {
    final scheme = ShadTheme.of(context).colorScheme;
    final theme = context.zam;
    return SizedBox(
      width: theme.spacing.twelve,
      height: theme.spacing.twelve,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: scheme.primaryForeground.withValues(
            alpha: theme.opacities.secondary,
          ),
          borderRadius: theme.radius.pill,
        ),
      ),
    );
  }
}
