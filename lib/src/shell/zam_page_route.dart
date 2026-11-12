part of '../shell.dart';

/// A full-screen page route with the platform's page transition.
///
/// With [ZamPageTransition.platform], the default:
///
/// * On iOS and macOS the page slides in from the trailing edge over 500 ms
///   and the page below shifts by a third. A drag that starts in the leading
///   20 logical pixels pops the route interactively. The gesture is off for
///   the first route, for a [fullscreenDialog], when a [PopScope] blocks the
///   pop, and while another transition or gesture runs. It mirrors in
///   right-to-left layouts.
/// * On every other platform the page fades in while it slides in a short
///   distance, over 450 ms, and the system back button pops it.
///
/// [transition] forces one of these on every platform, or turns the
/// animation off. `ZamApp` builds this route for its pages unless it is given
/// a `pageRouteBuilder`.
class ZamPageRoute<T> extends PageRoute<T> {
  /// Creates a page route that builds its page with [builder].
  ZamPageRoute({
    required this.builder,
    super.settings,
    this.maintainState = true,
    super.fullscreenDialog,
    this.transition = ZamPageTransition.platform,
  });

  /// Builds the page.
  final WidgetBuilder builder;

  @override
  final bool maintainState;

  /// How the page enters and leaves the screen.
  final ZamPageTransition transition;

  // The transition this route runs on the current platform.
  ZamPageTransition get _resolved => switch (transition) {
    ZamPageTransition.platform => switch (defaultTargetPlatform) {
      TargetPlatform.iOS || TargetPlatform.macOS => ZamPageTransition.slide,
      TargetPlatform.android ||
      TargetPlatform.fuchsia ||
      TargetPlatform.linux ||
      TargetPlatform.windows => ZamPageTransition.fade,
    },
    ZamPageTransition.slide ||
    ZamPageTransition.fade ||
    ZamPageTransition.none => transition,
  };

  @override
  Duration get transitionDuration => switch (_resolved) {
    ZamPageTransition.slide => ZamDurationToken.long2.duration,
    ZamPageTransition.fade => ZamDurationToken.long1.duration,
    ZamPageTransition.platform || ZamPageTransition.none => Duration.zero,
  };

  /// While the iOS transition runs, the page below dims slightly, as it does
  /// under a `CupertinoPageRoute`.
  @override
  Color? get barrierColor =>
      _resolved == ZamPageTransition.slide && !fullscreenDialog
      ? ZamColorUtils.black.withValues(alpha: const ZamOpacityTokens().tint)
      : null;

  @override
  String? get barrierLabel => null;

  /// The page below only moves with a page that runs the same transition,
  /// and never under a fullscreen dialog.
  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) =>
      nextRoute is ZamPageRoute &&
      !nextRoute.fullscreenDialog &&
      nextRoute._resolved == _resolved &&
      _resolved != ZamPageTransition.none;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: builder(context),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    switch (_resolved) {
      case ZamPageTransition.slide:
        return _ZamSlidePageTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          fullscreenDialog: fullscreenDialog,
          // Under the finger the page follows the drag without curves.
          linear: popGestureInProgress,
          child: fullscreenDialog
              ? child
              : _ZamBackGestureDetector<T>(
                  enabledCallback: () => popGestureEnabled,
                  onStartPopGesture: _startPopGesture,
                  child: child,
                ),
        );
      case ZamPageTransition.fade:
        return _ZamFadePageTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          backgroundColor: _background(context),
          child: child,
        );
      case ZamPageTransition.platform:
      case ZamPageTransition.none:
        return child;
    }
  }

  _ZamBackGestureController<T> _startPopGesture() {
    assert(popGestureEnabled, 'The back gesture started while disabled.');
    return _ZamBackGestureController<T>(
      navigator: navigator!,
      controller: controller!,
      getIsActive: () => isActive,
      getIsCurrent: () => isCurrent,
    );
  }

  // The fill behind two fading pages, so the gap between them is never black.
  static Color _background(BuildContext context) {
    final theme = ZamTheme.maybeOf(context);
    final shad = ZamTheme.maybeShadOf(context);
    if (theme == null || shad == null) return ZamColorUtils.transparent;
    return theme.palette(shad.brightness).background;
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}
