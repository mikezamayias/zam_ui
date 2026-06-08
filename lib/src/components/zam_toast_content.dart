part of '../components.dart';

class ZamToastContent extends StatelessWidget {
  const ZamToastContent({
    required this.style,
    required this.title,
    super.key,
    this.description,
    this.action,
  });

  final ZamToastStyle style;
  final String title;
  final Widget? description;
  final Widget? action;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: style.background,
        borderRadius: theme.radius.toast,
        border: Border.fromBorderSide(theme.strokes.border(style.border)),
        boxShadow: [
          BoxShadow(
            color: style.shadowColor,
            blurRadius: theme.spacing.thirtyTwo,
            offset: Offset(theme.spacing.zero, theme.spacing.twelve),
            spreadRadius: -theme.spacing.eight,
          ),
        ],
      ),
      child: Padding(
        padding: theme.insets.toast,
        child: Row(
          children: [
            Icon(
              style.icon,
              size: theme.sizes.iconSm,
              color: style.iconForeground,
            ),
            SizedBox(width: theme.spacing.twelve),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: theme.typography.title(
                      context,
                      color: style.foreground,
                    ),
                  ),
                  if (description != null) ...[
                    SizedBox(height: theme.spacing.four),
                    DefaultTextStyle(
                      style: theme.typography.bodySmall(
                        context,
                        color: style.subtleForeground,
                      ),
                      child: description!,
                    ),
                  ],
                  if (action != null) ...[
                    SizedBox(height: theme.spacing.twelve),
                    action!,
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
