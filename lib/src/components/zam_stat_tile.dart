part of '../components.dart';

class ZamStatTile extends StatelessWidget {
  const ZamStatTile({
    required this.label,
    required this.value,
    super.key,
    this.valueColor,
  });

  final String label;
  final String value;
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
