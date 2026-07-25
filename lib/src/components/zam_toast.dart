part of '../components.dart';

/// Toast manager utility for displaying token-styled overlay notifications.
abstract final class ZamToast {
  /// Displays a toast notification with specified [variant], [title], and optional [description].
  static void show(
    BuildContext context, {
    required String title,
    ZamToastVariant variant = ZamToastVariant.info,
    Widget? description,
    Widget? action,
    Duration? duration,
    Alignment alignment = Alignment.bottomCenter,
  }) {
    final theme = context.zam;
    final style = theme.toastStyle(ShadTheme.of(context).brightness, variant);
    ShadToaster.of(context).show(
      ShadToast(
        title: ZamToastContent(
          style: style,
          title: title,
          description: description,
          action: action,
        ),
        duration: duration ?? theme.motion.toastDefault,
        alignment: alignment,
        closeIcon: const SizedBox.shrink(),
        padding: theme.insets.zero,
        border: ShadBorder.none,
        radius: theme.radius.zero,
        shadows: const [],
        backgroundColor: theme.colors.transparent,
      ),
    );
  }
}
