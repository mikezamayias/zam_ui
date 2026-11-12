part of '../overlays.dart';

/// Republishes the local themes of the widget that opened an overlay.
class _ZamRouteScope extends StatelessWidget {
  const _ZamRouteScope({required this.data, required this.child});

  final _ZamRouteScopeData data;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    var result = child;
    final opener = data.opener;
    final shad = data.shad;
    if (shad != null) {
      result = ShadThemeScope(
        data: opener != null && opener.mounted
            ? ShadTheme.of(opener, listen: false)
            : shad,
        child: result,
      );
    }
    final zam = data.zam;
    if (zam != null) {
      result = ZamTheme(data: zam, child: result);
    }
    return result;
  }
}
