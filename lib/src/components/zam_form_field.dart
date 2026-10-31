part of '../components.dart';

/// Form field layout wrapper managing label text, required indicator, description, and error messaging around an input child.
class ZamFormField extends StatelessWidget {
  /// Creates a [ZamFormField].
  const ZamFormField({
    required this.label,
    required this.child,
    super.key,
    this.description,
    this.error,
    this.isRequired = false,
  });

  /// Field label text.
  final String label;

  /// Input child widget.
  final Widget child;

  /// Optional helper description text.
  final String? description;

  /// Optional validation error text.
  final String? error;

  /// Whether to display a required asterisk indicator.
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
            Flexible(
              child: Text(label, style: theme.typography.label(context)),
            ),
            if (isRequired) ...[
              SizedBox(width: theme.spacing(0.5)),
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
        SizedBox(height: theme.spacing(1.5)),
        child,
        if (description != null && !hasError) ...[
          SizedBox(height: theme.spacing.xs),
          Text(
            description!,
            style: theme.typography.caption(
              context,
              color: scheme.mutedForeground,
            ),
          ),
        ],
        if (hasError) ...[
          SizedBox(height: theme.spacing.xs),
          Text(
            error!,
            style: theme.typography.caption(context, color: scheme.destructive),
          ),
        ],
      ],
    );
  }
}
