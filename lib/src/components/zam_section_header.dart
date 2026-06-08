part of '../components.dart';

class ZamSectionHeader extends StatelessWidget {
  const ZamSectionHeader({
    required this.title,
    super.key,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
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
