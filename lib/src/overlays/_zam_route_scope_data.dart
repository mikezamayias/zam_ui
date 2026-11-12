part of '../overlays.dart';

/// The themes of the widget that opened an overlay, when they differ from the
/// themes the navigator sees.
///
/// A route is built under the navigator, so it sees the app-level themes and
/// not a [ZamTheme] or shad theme applied to a subtree. When the opener is
/// themed locally, `_ZamRouteScope` republishes its themes inside the route.
@immutable
class _ZamRouteScopeData {
  const _ZamRouteScopeData({this.zam, this.shad, this.opener});

  /// Captures the local themes of [opener], or nothing when the opener sees
  /// the same themes as [navigatorContext].
  factory _ZamRouteScopeData.capture(
    BuildContext opener,
    BuildContext navigatorContext,
  ) {
    final zam = opener.getInheritedWidgetOfExactType<ZamTheme>()?.data;
    final shad = ShadTheme.maybeOf(opener, listen: false);
    final zamLocal =
        zam != navigatorContext.getInheritedWidgetOfExactType<ZamTheme>()?.data;
    final shadLocal =
        shad != ShadTheme.maybeOf(navigatorContext, listen: false);
    return _ZamRouteScopeData(
      zam: zamLocal ? zam : null,
      shad: shadLocal ? shad : null,
      opener: shadLocal ? opener : null,
    );
  }

  /// The local [ZamThemeData], or null when the app-level one applies.
  final ZamThemeData? zam;

  /// The local shad theme, or null when the app-level one applies.
  final ShadThemeData? shad;

  /// The opener, read again for the shad theme while it is still mounted.
  final BuildContext? opener;
}
