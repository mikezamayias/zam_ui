part of '../overlays.dart';

/// The modal popup route behind [showZamDialog] and [showZamSheet].
///
/// It is a `PopupRoute`, so the barrier, the focus scope, the back action and
/// the focus restoration come from the framework. Focus stays inside the
/// route (a closed loop), and the page is a semantics scope that screen
/// readers announce as a new route.
class _ZamOverlayRoute<T> extends PopupRoute<T> {
  _ZamOverlayRoute({
    required this.pageBuilder,
    required this.barrierDismissible,
    required this.barrierColor,
    required this.barrierLabel,
    required this.transitionDuration,
    required this.reverseTransitionDuration,
    this.transitionBuilder,
    super.settings,
    super.filter,
  }) : super(traversalEdgeBehavior: TraversalEdgeBehavior.closedLoop);

  final WidgetBuilder pageBuilder;

  /// Wraps the page for the enter and exit animation, or null when the page
  /// animates itself.
  final RouteTransitionsBuilder? transitionBuilder;

  /// The controller behind the route animation, which a sheet drives while it
  /// is dragged.
  AnimationController? get dragController => controller;

  @override
  final bool barrierDismissible;

  @override
  final Color barrierColor;

  @override
  final String barrierLabel;

  @override
  final Duration transitionDuration;

  @override
  final Duration reverseTransitionDuration;

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: DisplayFeatureSubScreen(child: pageBuilder(context)),
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    return transitionBuilder?.call(
          context,
          animation,
          secondaryAnimation,
          child,
        ) ??
        child;
  }
}
