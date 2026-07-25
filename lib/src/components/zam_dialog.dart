part of '../components.dart';

/// Modal dialog component with static helper methods for messages and confirmation dialogs.
class ZamDialog extends StatelessWidget {
  /// Creates a [ZamDialog].
  const ZamDialog({
    required this.title,
    required this.message,
    super.key,
    this.icon,
    this.destructive = false,
    this.actions = const [],
  });

  /// Dialog title text.
  final String title;

  /// Dialog description message text.
  final String message;

  /// Optional header icon.
  final IconData? icon;

  /// Whether the dialog represents a destructive confirmation.
  final bool destructive;

  /// List of action widgets displayed at the bottom of the dialog.
  final List<Widget> actions;

  /// Displays an informational alert dialog with an OK confirmation button.
  static Future<void> showMessage({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'OK',
  }) {
    return showShadDialog<void>(
      context: context,
      barrierColor: context.zam.colors.black.withValues(
        alpha: context.zam.opacities.strong,
      ),
      builder: (dialogContext) => ZamDialog(
        title: title,
        message: message,
        actions: [
          ZamButton(
            label: confirmText,
            isExpanded: true,
            onPressed: () => Navigator.of(dialogContext).pop(),
          ),
        ],
      ),
    );
  }

  /// Displays a boolean confirmation dialog returning `true` if confirmed or `false` if cancelled.
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String title,
    required String message,
    String confirmText = 'Confirm',
    String cancelText = 'Cancel',
    IconData? icon,
    bool destructive = false,
  }) async {
    final result = await showShadDialog<bool>(
      context: context,
      barrierDismissible: false,
      barrierColor: context.zam.colors.black.withValues(
        alpha: context.zam.opacities.strong,
      ),
      builder: (dialogContext) => ZamDialog(
        title: title,
        message: message,
        icon: icon,
        destructive: destructive,
        actions: [
          ZamButton(
            label: cancelText,
            variant: ZamButtonVariant.outline,
            isExpanded: true,
            onPressed: () => Navigator.of(dialogContext).pop(false),
          ),
          ZamButton(
            label: confirmText,
            variant: destructive
                ? ZamButtonVariant.destructive
                : ZamButtonVariant.primary,
            isExpanded: true,
            onPressed: () => Navigator.of(dialogContext).pop(true),
          ),
        ],
      ),
    );
    return result ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return Semantics(
      namesRoute: true,
      label: title,
      child: ShadDialog(
        constraints: theme.sizes.dialogConstraints,
        backgroundColor: scheme.card,
        radius: theme.radius.dialog,
        border: Border.all(color: scheme.border),
        padding: theme.insets.dialog,
        title: icon == null
            ? Text(title, style: theme.typography.title(context))
            : Row(
                children: [
                  Container(
                    width: theme.spacing.thirtyTwo,
                    height: theme.spacing.thirtyTwo,
                    decoration: BoxDecoration(
                      color: theme.opacities.apply(
                        destructive ? scheme.destructive : scheme.primary,
                        theme.opacities.subtleTint,
                      ),
                      borderRadius: theme.radius.circular(theme.radius.ten),
                    ),
                    child: Icon(
                      icon,
                      size: theme.sizes.iconSm,
                      color: destructive ? scheme.destructive : scheme.primary,
                    ),
                  ),
                  SizedBox(width: theme.spacing.twelve),
                  Expanded(child: Text(title)),
                ],
              ),
        description: Text(
          message,
          style: theme.typography.body(context, color: scheme.mutedForeground),
        ),
        actions: actions,
      ),
    );
  }
}
