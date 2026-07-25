part of '../theme.dart';

/// InheritedWidget providing [ZamThemeData] to descendant widgets in the widget tree.
class ZamTheme extends InheritedWidget {
  /// Creates a [ZamTheme] providing [data] to descendant widgets.
  const ZamTheme({
    required this.data,
    required super.child,
    super.key,
  });

  /// The active design system theme configuration.
  final ZamThemeData data;

  /// Retrieves the nearest [ZamThemeData] ancestor from [context].
  ///
  /// Throws a [FlutterError] if no [ZamTheme] is found in the ancestor tree.
  static ZamThemeData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ZamTheme>();
    if (scope == null) {
      throw FlutterError('No ZamTheme found in the widget tree.');
    }
    return scope.data;
  }

  /// Optional lookup for [ZamThemeData] from [context], returning `null` if not found.
  static ZamThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ZamTheme>()?.data;
  }

  /// Retrieves the resolved [ShadThemeData] from [context].
  static ZamResolvedThemeData shadOf(BuildContext context) {
    return ShadTheme.of(context);
  }

  /// Optional lookup for resolved [ShadThemeData] from [context].
  static ZamResolvedThemeData? maybeShadOf(BuildContext context) {
    return ShadTheme.maybeOf(context);
  }

  @override
  bool updateShouldNotify(ZamTheme oldWidget) => data != oldWidget.data;
}
