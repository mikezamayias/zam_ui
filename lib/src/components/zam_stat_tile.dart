part of '../components.dart';

/// Stat tile component displaying a metric label and value inside a surface card.
class ZamStatTile extends StatelessWidget {
  /// Creates a [ZamStatTile].
  const ZamStatTile({
    required this.label,
    required this.value,
    super.key,
    this.valueColor,
  });

  /// Metric label text (rendered in uppercase monospace caps).
  final String label;

  /// Metric value text.
  final String value;

  /// Optional custom color for metric value text.
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return ZamSurface(
      padding: theme.insets.smallTile,
      radius: theme.radius.lg,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.typography.monoCaps(context)),
          SizedBox(height: theme.spacing.four),
          Text(
            value,
            style: theme.typography.title(
              context,
              color: valueColor ?? scheme.foreground,
            ),
          ),
        ],
      ),
    );
  }
}
