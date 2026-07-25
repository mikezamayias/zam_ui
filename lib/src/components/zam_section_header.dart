part of '../components.dart';

/// Section header component for grouping content blocks with title, subtitle, and optional trailing widget.
class ZamSectionHeader extends StatelessWidget {
  /// Creates a [ZamSectionHeader].
  const ZamSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
  });

  /// Main section title.
  final String title;

  /// Optional section subtitle.
  final String? subtitle;

  /// Optional trailing action widget.
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: theme.typography.title(context)),
              if (subtitle != null) ...[
                SizedBox(height: theme.spacing.two),
                Text(subtitle!, style: theme.typography.bodySmall(context)),
              ],
            ],
          ),
        ),
        if (trailing != null) ...[
          SizedBox(width: theme.spacing.twelve),
          trailing!,
        ],
      ],
    );
  }
}
