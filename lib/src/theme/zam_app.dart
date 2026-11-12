part of '../theme.dart';

/// Top-level app wrapper configuring [ZamTheme] and underlying [ShadApp].
///
/// It builds a widgets-layer app: no Material theme, no Material
/// localizations and no Material page route. Apps that still use Material
/// widgets wrap them in `ZamMaterial` from `package:zam_ui/material.dart`.
///
/// Below the [ShadApp] it scopes the [ZamThemeData] for the active
/// brightness and a [DefaultTextStyle] with the theme's font family, font
/// family fallback and foreground color, so unstyled [Text] uses the app
/// font rather than the platform font.
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
    this.onNavigationNotification,
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
    this.pageRouteBuilder,
    this.scrollBehavior = const ShadScrollBehavior(),
  }) : routerConfig = null,
       _router = false;

  /// Creates a declarative router-based [ZamApp].
  const ZamApp.router({
    super.key,
    this.theme,
    this.darkTheme,
    this.themeMode,
    this.routerConfig,
    this.builder,
    this.onNavigationNotification,
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
    this.scrollBehavior = const ShadScrollBehavior(),
  }) : navigatorKey = null,
       onGenerateRoute = null,
       onGenerateInitialRoutes = null,
       onUnknownRoute = null,
       navigatorObservers = null,
       initialRoute = null,
       home = null,
       routes = null,
       pageRouteBuilder = null,
       _router = true;

  /// Light mode design system theme configuration.
  final ZamThemeData? theme;

  /// Dark mode design system theme configuration.
  final ZamThemeData? darkTheme;

  /// Explicit theme mode (system, light, or dark).
  ///
  /// When null, the app follows the platform brightness.
  final ZamThemeMode? themeMode;

  /// Global navigator key.
  final GlobalKey<NavigatorState>? navigatorKey;

  /// Route factory for dynamic routing.
  final RouteFactory? onGenerateRoute;

  /// Route factory for initial route list.
  final InitialRouteListFactory? onGenerateInitialRoutes;

  /// Unknown route fallback handler.
  final RouteFactory? onUnknownRoute;

  /// Called for each [NavigationNotification] that bubbles up to the app.
  ///
  /// See [WidgetsApp.onNavigationNotification].
  final NotificationListenerCallback<NavigationNotification>?
  onNavigationNotification;

  /// Builds the page route for [home], [routes] and named routes.
  ///
  /// When null, pages use [ShadPageRoute], a fade with no back gesture.
  /// Always null for [ZamApp.router].
  final PageRouteFactory? pageRouteBuilder;

  /// How scrollables below the app scroll and which scrollbar they draw.
  final ScrollBehavior scrollBehavior;

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
    final effectiveDarkTheme = darkTheme ?? effectiveTheme;
    final lightData = effectiveTheme.toShadThemeData(Brightness.light);
    final darkData = effectiveDarkTheme.toShadThemeData(Brightness.dark);

    // ShadApp resolves the theme mode above its builder, so the builder reads
    // the active brightness and scopes the matching ZamThemeData, which also
    // covers the toaster and sonner that ShadApp places inside it.
    Widget scopedBuilder(BuildContext context, Widget? child) {
      final shadTheme = ShadTheme.of(context);
      final isDark = shadTheme.brightness == Brightness.dark;
      return ZamTheme(
        data: isDark ? effectiveDarkTheme : effectiveTheme,
        // ShadApp sets only the text color, so without this an unstyled Text
        // would use the platform font.
        child: DefaultTextStyle.merge(
          style: TextStyle(
            fontFamily: shadTheme.textTheme.family,
            fontFamilyFallback: shadTheme.textTheme.p.fontFamilyFallback,
            color: shadTheme.colorScheme.foreground,
          ),
          child: Builder(
            builder: (context) =>
                builder?.call(context, child) ??
                child ??
                const SizedBox.shrink(),
          ),
        ),
      );
    }

    final shadThemeMode = switch (themeMode) {
      null => null,
      ZamThemeMode.system => ShadThemeMode.system,
      ZamThemeMode.light => ShadThemeMode.light,
      ZamThemeMode.dark => ShadThemeMode.dark,
    };

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
            themeMode: shadThemeMode,
            theme: lightData,
            darkTheme: darkData,
            routerConfig: routerConfig,
            onNavigationNotification: onNavigationNotification,
            scrollBehavior: scrollBehavior,
            builder: scopedBuilder,
          )
        : ShadApp(
            navigatorKey: navigatorKey,
            onGenerateRoute: onGenerateRoute,
            onGenerateInitialRoutes: onGenerateInitialRoutes,
            onUnknownRoute: onUnknownRoute,
            onNavigationNotification: onNavigationNotification,
            navigatorObservers:
                navigatorObservers ?? const <NavigatorObserver>[],
            initialRoute: initialRoute,
            home: home,
            routes: routes ?? const <String, WidgetBuilder>{},
            pageRouteBuilder:
                pageRouteBuilder ??
                <T>(settings, builder) =>
                    ShadPageRoute<T>(settings: settings, builder: builder),
            scrollBehavior: scrollBehavior,
            builder: scopedBuilder,
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
            themeMode: shadThemeMode,
            theme: lightData,
            darkTheme: darkData,
          );

    return app;
  }
}
