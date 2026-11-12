part of '../components.dart';

/// Toast manager utility for displaying token-styled overlay notifications.
abstract final class ZamToast {
  /// Displays a toast notification with specified [variant], [title], and optional [description].
  ///
  /// Screen readers hear the [title], followed by the [description] when it is
  /// a [Text].
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
    final descriptionText = description is Text ? description.data : null;
    _announce(
      context,
      [
        title,
        if (descriptionText != null && descriptionText.isNotEmpty)
          descriptionText,
      ].join('. '),
    );
    ShadToaster.of(context).show(
      ShadToast(
        title: ZamToastContent(
          style: style,
          title: title,
          description: description,
          action: action,
        ),
        displayDuration:
            duration ??
            (variant == ZamToastVariant.progress
                ? theme.motion.progressToast
                : theme.motion.toastDefault),
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

  /// Displays [content] as a toast, with none of the kit's own toast styling.
  ///
  /// The toast has no padding, border, radius, shadow, background or close
  /// icon, so [content] draws all of it. Unstyled text in [content] uses the
  /// app's default text style.
  ///
  /// [alignment] places the toast and [offset] moves it from that edge. By
  /// default it clears the safe area. [constraints] limit its size. [duration]
  /// defaults to the theme's toast duration.
  ///
  /// Nothing is announced to screen readers unless [semanticLabel] is set, so
  /// pass the words the toast shows.
  static void showCustom(
    BuildContext context, {
    required Widget content,
    Duration? duration,
    Alignment alignment = Alignment.bottomCenter,
    Offset? offset,
    BoxConstraints? constraints,
    String? semanticLabel,
  }) {
    final theme = context.zam;
    if (semanticLabel != null && semanticLabel.isNotEmpty) {
      _announce(context, semanticLabel);
    }
    ShadToaster.of(context).show(
      ShadToast.raw(
        variant: ShadToastVariant.primary,
        title: content,
        displayDuration: duration ?? theme.motion.toastDefault,
        alignment: alignment,
        offset: offset,
        constraints: constraints,
        closeIcon: const SizedBox.shrink(),
        showCloseIconOnlyWhenHovered: false,
        padding: theme.insets.zero,
        actionPadding: theme.insets.zero,
        border: ShadBorder.none,
        radius: theme.radius.zero,
        shadows: const [],
        backgroundColor: theme.colors.transparent,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.max,
        titleStyle: DefaultTextStyle.of(context).style,
      ),
    );
  }

  /// Hides the toast that is on screen.
  ///
  /// The future completes when the exit animation ends.
  static Future<void> hide(BuildContext context) =>
      ShadToaster.of(context).hide();

  /// Announces [message] to screen readers, which do not read the toast layer
  /// when a toast appears.
  static void _announce(BuildContext context, String message) {
    final view = View.maybeOf(context);
    if (view == null) return;
    SemanticsService.sendAnnouncement(
      view,
      message,
      Directionality.of(context),
    ).ignore();
  }
}
