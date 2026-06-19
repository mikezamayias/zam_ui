part of '../theme.dart';

class ZamTheme extends InheritedWidget {
  const ZamTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final ZamThemeData data;

  static ZamThemeData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ZamTheme>();
    if (scope == null) {
      throw FlutterError('No ZamTheme found in the widget tree.');
    }
    return scope.data;
  }

  static ZamThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ZamTheme>()?.data;
  }

  static ZamResolvedThemeData shadOf(BuildContext context) {
    return ShadTheme.of(context);
  }

  static ZamResolvedThemeData? maybeShadOf(BuildContext context) {
    return ShadTheme.maybeOf(context);
  }

  @override
  bool updateShouldNotify(ZamTheme oldWidget) => data != oldWidget.data;
}
