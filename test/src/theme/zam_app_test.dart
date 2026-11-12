import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

class _HomeDelegate extends RouterDelegate<Object> with ChangeNotifier {
  _HomeDelegate(this.home);

  final Widget home;

  @override
  Widget build(BuildContext context) => home;

  @override
  Future<bool> popRoute() => SynchronousFuture(false);

  @override
  Future<void> setNewRoutePath(Object configuration) => SynchronousFuture(null);
}

class _TestScrollBehavior extends ScrollBehavior {
  const _TestScrollBehavior();
}

void main() {
  final darkTheme = testTheme.copyWith(
    typography: const ZamTypographyTokens(fontFamily: 'Dark Sans'),
  );

  Widget probe(void Function(BuildContext context) onBuild) => Builder(
    builder: (context) {
      onBuild(context);
      return const SizedBox();
    },
  );

  group('ZamApp themeMode', () {
    for (final (mode, family) in [
      (ZamThemeMode.light, 'Test Sans'),
      (ZamThemeMode.dark, 'Dark Sans'),
    ]) {
      testWidgets('$mode scopes the matching theme', (tester) async {
        late Brightness brightness;
        late String scoped;
        await tester.pumpWidget(
          ZamApp(
            theme: testTheme,
            darkTheme: darkTheme,
            themeMode: mode,
            home: probe((context) {
              brightness = ShadTheme.of(context).brightness;
              scoped = context.zamTypography.fontFamily;
            }),
          ),
        );

        expect(
          brightness,
          mode == ZamThemeMode.dark ? Brightness.dark : Brightness.light,
        );
        expect(scoped, family);
      });
    }

    testWidgets('system follows the platform brightness', (tester) async {
      tester.platformDispatcher.platformBrightnessTestValue = Brightness.dark;
      addTearDown(tester.platformDispatcher.clearPlatformBrightnessTestValue);
      late String scoped;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          darkTheme: darkTheme,
          themeMode: ZamThemeMode.system,
          home: probe((context) => scoped = context.zamTypography.fontFamily),
        ),
      );

      expect(scoped, 'Dark Sans');
    });
  });

  group('ZamApp default text style', () {
    for (final brightness in Brightness.values) {
      testWidgets('unstyled text takes the theme font and foreground in '
          '$brightness', (tester) async {
        await tester.pumpWidget(
          ZamApp(
            theme: testTheme,
            darkTheme: darkTheme,
            themeMode: brightness == Brightness.dark
                ? ZamThemeMode.dark
                : ZamThemeMode.light,
            home: const Text('plain'),
          ),
        );

        final style = DefaultTextStyle.of(
          tester.element(find.text('plain')),
        ).style;
        final theme = brightness == Brightness.dark ? darkTheme : testTheme;
        expect(style.fontFamily, theme.typography.fontFamily);
        expect(
          style.color,
          theme.toShadThemeData(brightness).colorScheme.foreground,
        );
        expect(style.fontFamilyFallback, isNull);
      });
    }

    testWidgets('the app builder sees the theme and the text style', (
      tester,
    ) async {
      String? builderFamily;
      String? builderTextFamily;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          builder: (context, child) {
            builderFamily = context.zamTypography.fontFamily;
            builderTextFamily = DefaultTextStyle.of(context).style.fontFamily;
            return child!;
          },
          home: const SizedBox(),
        ),
      );

      expect(builderFamily, 'Test Sans');
      expect(builderTextFamily, 'Test Sans');
    });
  });

  group('ZamApp routes', () {
    testWidgets('pages use ShadPageRoute by default', (tester) async {
      late ModalRoute<Object?>? route;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          home: probe((context) => route = ModalRoute.of(context)),
        ),
      );

      expect(route, isA<ShadPageRoute<void>>());
    });

    testWidgets('pageRouteBuilder builds every page', (tester) async {
      // A page can build more than once during its transition.
      final routes = <ModalRoute<Object?>?>{};
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          navigatorKey: navigatorKey,
          pageRouteBuilder: <T>(settings, builder) => PageRouteBuilder<T>(
            settings: settings,
            pageBuilder: (context, _, _) => builder(context),
          ),
          routes: {
            '/': (_) => probe((context) => routes.add(ModalRoute.of(context))),
            '/next': (_) =>
                probe((context) => routes.add(ModalRoute.of(context))),
          },
        ),
      );
      navigatorKey.currentState!.pushNamed('/next');
      await tester.pumpAndSettle();

      expect(routes, hasLength(2));
      expect(routes, everyElement(isA<PageRouteBuilder<Object?>>()));
      expect(routes.last!.settings.name, '/next');
    });
  });

  group('ZamApp scrolling and navigation notifications', () {
    testWidgets('uses ShadScrollBehavior by default', (tester) async {
      late ScrollBehavior behavior;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          home: probe((context) => behavior = ScrollConfiguration.of(context)),
        ),
      );

      expect(behavior, isA<ShadScrollBehavior>());
    });

    testWidgets('passes scrollBehavior to the app', (tester) async {
      late ScrollBehavior behavior;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          scrollBehavior: const _TestScrollBehavior(),
          home: probe((context) => behavior = ScrollConfiguration.of(context)),
        ),
      );

      expect(behavior, isA<_TestScrollBehavior>());
    });

    testWidgets('reports navigation notifications', (tester) async {
      final received = <NavigationNotification>[];
      late BuildContext homeContext;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          onNavigationNotification: (notification) {
            received.add(notification);
            return true;
          },
          home: probe((context) => homeContext = context),
        ),
      );
      received.clear();
      const NavigationNotification(canHandlePop: true).dispatch(homeContext);

      expect(received.single.canHandlePop, isTrue);
    });
  });

  group('ZamApp.router', () {
    testWidgets('scopes the theme, text style and scroll behavior', (
      tester,
    ) async {
      final received = <NavigationNotification>[];
      final delegate = _HomeDelegate(const Text('routed'));
      addTearDown(delegate.dispose);
      await tester.pumpWidget(
        ZamApp.router(
          theme: testTheme,
          darkTheme: darkTheme,
          themeMode: ZamThemeMode.dark,
          routerConfig: RouterConfig(routerDelegate: delegate),
          scrollBehavior: const _TestScrollBehavior(),
          onNavigationNotification: (notification) {
            received.add(notification);
            return true;
          },
        ),
      );

      final context = tester.element(find.text('routed'));
      expect(context.zamTypography.fontFamily, 'Dark Sans');
      expect(DefaultTextStyle.of(context).style.fontFamily, 'Dark Sans');
      expect(ScrollConfiguration.of(context), isA<_TestScrollBehavior>());

      received.clear();
      const NavigationNotification(canHandlePop: false).dispatch(context);
      expect(received.single.canHandlePop, isFalse);
    });
  });
}
