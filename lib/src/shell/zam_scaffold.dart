part of '../shell.dart';

/// A screen frame: a background, a body and an optional bar at the bottom.
///
/// It does what apps use from Material's `Scaffold` without a Material
/// ancestor:
///
/// * It fills its box with [backgroundColor].
/// * It places [bottomBar] at the bottom at its own height and gives [body]
///   the rest of the box.
/// * With [resizeToAvoidBottomInset], the body and the bar sit above the
///   keyboard, and the [MediaQuery] they see has the bottom view inset
///   removed.
/// * With a [bottomBar], the body's [MediaQuery] has the bottom padding
///   removed and the bar receives it. The bar's [MediaQuery] has the top
///   padding removed.
/// * On iOS and macOS a tap on the status bar scrolls the
///   [PrimaryScrollController] of the enclosing route to the top.
///
/// It adds no semantics node and no text style, so the root
/// [DefaultTextStyle] of `ZamApp` reaches the body unchanged.
class ZamScaffold extends StatelessWidget {
  /// Creates a screen frame around [body].
  const ZamScaffold({
    required this.body,
    this.bottomBar,
    this.backgroundColor,
    this.resizeToAvoidBottomInset = true,
    super.key,
  });

  /// The primary content of the screen.
  ///
  /// It receives tight constraints for the area above [bottomBar].
  final Widget body;

  /// A widget shown below [body] at its own height, such as a navigation bar.
  final Widget? bottomBar;

  /// The fill behind [body] and [bottomBar].
  ///
  /// Defaults to the active palette's background.
  final Color? backgroundColor;

  /// Whether [body] and [bottomBar] move up when the keyboard opens.
  ///
  /// When true, the bottom view inset is applied as padding and removed from
  /// the [MediaQuery] below. When false, the keyboard covers the bottom of
  /// the screen and the body still sees the inset.
  final bool resizeToAvoidBottomInset;

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context);
    final keyboardInset = resizeToAvoidBottomInset
        ? media.viewInsets.bottom
        : 0.0;
    final contentMedia = resizeToAvoidBottomInset
        ? media.removeViewInsets(removeBottom: true)
        : media;
    final bar = bottomBar;

    Widget content = MediaQuery(
      data: bar == null
          ? contentMedia
          : contentMedia.removePadding(removeBottom: true),
      child: body,
    );
    if (bar != null) {
      content = Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: content),
          // The bar sits at the bottom, so it never sees the status bar.
          MediaQuery(
            data: contentMedia.removePadding(removeTop: true),
            child: bar,
          ),
        ],
      );
    }
    content = Padding(
      padding: EdgeInsets.only(bottom: keyboardInset),
      child: content,
    );

    final handlesStatusBarTap = switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.macOS => true,
      TargetPlatform.android ||
      TargetPlatform.fuchsia ||
      TargetPlatform.linux ||
      TargetPlatform.windows => false,
    };
    if (handlesStatusBarTap) {
      content = Stack(
        fit: StackFit.expand,
        children: [
          content,
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: media.padding.top,
            child: const _ZamStatusBarTapTarget(),
          ),
        ],
      );
    }

    return ColoredBox(
      color: backgroundColor ?? context.zamPalette.background,
      child: SizedBox.expand(child: content),
    );
  }
}
