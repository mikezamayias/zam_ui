part of '../components.dart';

class ZamFormField extends StatelessWidget {
  const ZamFormField({
    required this.label,
    required this.child,
    super.key,
    this.description,
    this.error,
    this.isRequired = false,
  });

  final String label;
  final Widget child;
  final String? description;
  final String? error;
  final bool isRequired;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;
    final hasError = error != null && error!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Text(
              label,
              style: theme.typography.label(context),
            ),
            if (isRequired) ...[
              SizedBox(width: theme.spacing.two),
              Text(
                '*',
                style: theme.typography.label(
                  context,
                  color: scheme.destructive,
                ),
              ),
            ],
          ],
        ),
        SizedBox(height: theme.spacing.six),
        child,
        if (description != null && !hasError) ...[
          SizedBox(height: theme.spacing.four),
          Text(
            description!,
            style: theme.typography.caption(
              context,
              color: scheme.mutedForeground,
            ),
          ),
        ],
        if (hasError) ...[
          SizedBox(height: theme.spacing.four),
          Text(
            error!,
            style: theme.typography.caption(
              context,
              color: scheme.destructive,
            ),
          ),
        ],
      ],
    );
  }
}
