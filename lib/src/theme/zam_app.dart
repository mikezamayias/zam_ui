part of '../theme.dart';

/// Top-level app wrapper configuring [ZamTheme] and underlying [ShadApp].
class ZamApp extends StatelessWidget {
  /// Creates a standard [ZamApp] with imperative navigation.
  const ZamApp({
    super.key,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.navigatorKey,
    this.onGenerateRoute,
    this.onGenerateInitialRoutes,
    this.onUnknownRoute,
    this.navigatorObservers = const <NavigatorObserver>[],
    this.initialRoute,
    this.home,
    this.routes = const <String, WidgetBuilder>{},
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.backgroundColor,
  })  : routerConfig = null,
        _router = false;

  /// Creates a declarative router-based [ZamApp].
  const ZamApp.router({
    super.key,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.routerConfig,
    this.builder,
    this.title = '',
    this.onGenerateTitle,
    this.color,
    this.locale,
    this.localizationsDelegates,
    this.localeListResolutionCallback,
    this.localeResolutionCallback,
    this.supportedLocales = const <Locale>[Locale('en', 'US')],
    this.showPerformanceOverlay = false,
    this.showSemanticsDebugger = false,
    this.debugShowCheckedModeBanner = false,
    this.shortcuts,
    this.actions,
    this.restorationScopeId,
    this.backgroundColor,
  })  : navigatorKey = null,
        onGenerateRoute = null,
        onGenerateInitialRoutes = null,
        onUnknownRoute = null,
        navigatorObservers = null,
        initialRoute = null,
        home = null,
        routes = null,
        _router = true;

  /// Light mode design system theme configuration.
  final ZamThemeData? theme;

  /// Dark mode design system theme configuration.
  final ZamThemeData? darkTheme;

  /// Explicit theme mode (system, light, or dark).
  final ThemeMode? themeMode;

  /// Global navigator key.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Route factory for dynamic routing.
  final RouteFactory? onGenerateRoute;

  /// Route factory for initial route list.
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// Unknown route fallback handler.
  final RouteFactory? onUnknownRoute;

  /// List of navigator observers.
  final List<NavigatorObserver>? navigatorObservers;

  /// Initial route path.
  final String? initialRoute;

  /// Home screen widget.
  final Widget? home;

  /// Named route mapping.
  final Map<String, WidgetBuilder>? routes;

  /// App widget builder wrapper.
  final TransitionBuilder? builder;

  /// Application title.
  final String title;

  /// Dynamic title generator callback.
  final GenerateAppTitle? onGenerateTitle;

  /// Primary application color.
  final Color? color;

  /// Primary locale.
  final Locale? locale;

  /// Localization delegates.
  final Iterable<LocalizationsDelegate<dynamic>>? localizationsDelegates;

  /// Locale resolution callback for locale list.
  final LocaleListResolutionCallback? localeListResolutionCallback;

  /// Locale resolution callback for single locale.
  final LocaleResolutionCallback? localeResolutionCallback;

  /// Supported locales.
  final Iterable<Locale> supportedLocales;

  /// Whether to display performance overlay.
  final bool showPerformanceOverlay;

  /// Whether to display semantics debugger overlay.
  final bool showSemanticsDebugger;

  /// Whether to display debug banner.
  final bool debugShowCheckedModeBanner;

  /// Keyboard shortcut activators mapping.
  final Map<ShortcutActivator, Intent>? shortcuts;

  /// Intent actions mapping.
  final Map<Type, Action<Intent>>? actions;

  /// Restoration scope identifier.
  final String? restorationScopeId;

  /// Window background color.
  final Color? backgroundColor;

  /// Declarative router configuration.
  final RouterConfig<Object>? routerConfig;

  final bool _router;

  @override
  Widget build(BuildContext context) {
    final effectiveTheme = theme ?? ZamThemeData.fallback();
    final lightData = effectiveTheme.toShadThemeData(Brightness.light);
    final darkData = (darkTheme ?? effectiveTheme).toShadThemeData(
      Brightness.dark,
    );

    final app = _router
        ? ShadApp.router(
            title: title,
            onGenerateTitle: onGenerateTitle,
            color: color,
            locale: locale,
            localizationsDelegates: localizationsDelegates,
            localeListResolutionCallback: localeListResolutionCallback,
            localeResolutionCallback: localeResolutionCallback,
            supportedLocales: supportedLocales,
            showPerformanceOverlay: showPerformanceOverlay,
            showSemanticsDebugger: showSemanticsDebugger,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            shortcuts: shortcuts,
            actions: actions,
            restorationScopeId: restorationScopeId,
            backgroundColor: backgroundColor,
            themeMode: themeMode,
            theme: lightData,
            darkTheme: darkData,
            routerConfig: routerConfig,
            builder: builder,
          )
        : ShadApp(
            navigatorKey: navigatorKey,
            onGenerateRoute: onGenerateRoute,
            onGenerateInitialRoutes: onGenerateInitialRoutes,
            onUnknownRoute: onUnknownRoute,
            navigatorObservers:
                navigatorObservers ?? const <NavigatorObserver>[],
            initialRoute: initialRoute,
            home: home,
            routes: routes ?? const <String, WidgetBuilder>{},
            builder: builder,
            title: title,
            onGenerateTitle: onGenerateTitle,
            color: color,
            locale: locale,
            localizationsDelegates: localizationsDelegates,
            localeListResolutionCallback: localeListResolutionCallback,
            localeResolutionCallback: localeResolutionCallback,
            supportedLocales: supportedLocales,
            showPerformanceOverlay: showPerformanceOverlay,
            showSemanticsDebugger: showSemanticsDebugger,
            debugShowCheckedModeBanner: debugShowCheckedModeBanner,
            shortcuts: shortcuts,
            actions: actions,
            restorationScopeId: restorationScopeId,
            backgroundColor: backgroundColor,
            themeMode: themeMode,
            theme: lightData,
            darkTheme: darkData,
          );

    return ZamTheme(data: effectiveTheme, child: app);
  }
}
