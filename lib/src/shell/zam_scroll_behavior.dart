part of '../shell.dart';

/// The scroll behavior `ZamApp` installs by default.
///
/// It keeps the platform physics of [ScrollBehavior]: a bounce on iOS and
/// macOS, a clamp on Android. Vertical scrollables get a [ZamScrollbar] on
/// every platform except Android and Fuchsia, where the platform shows none.
/// Horizontal scrollables get no scrollbar.
class ZamScrollBehavior extends ScrollBehavior {
  /// Creates the default Zam scroll behavior.
  const ZamScrollBehavior();

  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    if (axisDirectionToAxis(details.direction) == Axis.horizontal) {
      return child;
    }
    return switch (getPlatform(context)) {
      TargetPlatform.android || TargetPlatform.fuchsia => child,
      TargetPlatform.iOS ||
      TargetPlatform.macOS ||
      TargetPlatform.linux ||
      TargetPlatform.windows => ZamScrollbar(
        controller: details.controller,
        child: child,
      ),
    };
  }
}
