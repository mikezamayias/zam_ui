part of '../components.dart';

abstract final class ZamToast {
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
