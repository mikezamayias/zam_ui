import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

final _ios = TargetPlatformVariant.only(TargetPlatform.iOS);
final _android = TargetPlatformVariant.only(TargetPlatform.android);

Widget _page(String label) => ColoredBox(
  color: const Color(0xFFFFFFFF),
  child: Center(child: Text(label)),
);

void main() {
  late GlobalKey<NavigatorState> navigatorKey;

  setUp(() => navigatorKey = GlobalKey<NavigatorState>());

  NavigatorState navigator() => navigatorKey.currentState!;

  Future<void> pumpHome(
    WidgetTester tester, {
    TextDirection textDirection = TextDirection.ltr,
    Widget? home,
  }) async {
    await tester.pumpWidget(
      ZamApp(
        theme: testTheme,
        themeMode: ZamThemeMode.light,
        navigatorKey: navigatorKey,
        builder: (context, child) =>
            Directionality(textDirection: textDirection, child: child!),
        home: home ?? _page('home'),
      ),
    );
  }

  Future<T?> push<T>(
    WidgetTester tester, {
    String label = 'next',
    ZamPageTransition transition = ZamPageTransition.platform,
    bool fullscreenDialog = false,
    WidgetBuilder? builder,
  }) {
    final result = navigator().push<T>(
      ZamPageRoute<T>(
        builder: builder ?? (_) => _page(label),
        transition: transition,
        fullscreenDialog: fullscreenDialog,
      ),
    );
    return result;
  }

  double leftOf(WidgetTester tester, String label) =>
      tester.getTopLeft(find.byWidget(_findPage(tester, label))).dx;

  double topOf(WidgetTester tester, String label) =>
      tester.getTopLeft(find.byWidget(_findPage(tester, label))).dy;

  group('ZamPageRoute transitions', () {
    testWidgets('iOS slides the page in from the trailing edge over 500 ms', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      final width = tester.getSize(find.byType(Navigator)).width;
      final nextLeft = leftOf(tester, 'next');
      final homeLeft = leftOf(tester, 'home');
      expect(nextLeft, inExclusiveRange(0, width));
      expect(homeLeft, inExclusiveRange(-width / 3, 0));

      await tester.pump(const Duration(milliseconds: 250));
      expect(leftOf(tester, 'next'), 0);
      // The covered page goes offstage once the transition ends.
      await tester.pumpAndSettle();
      expect(find.text('home'), findsNothing);
    }, variant: _ios);

    testWidgets('iOS mirrors the slide in right-to-left layouts', (
      tester,
    ) async {
      await pumpHome(tester, textDirection: TextDirection.rtl);
      unawaited(push<void>(tester));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(leftOf(tester, 'next'), lessThan(0));
      expect(leftOf(tester, 'home'), greaterThan(0));
      await tester.pumpAndSettle();
    }, variant: _ios);

    testWidgets('iOS dims the page below while the page slides in', (
      tester,
    ) async {
      final route = ZamPageRoute<void>(builder: (_) => _page('next'));
      final dialog = ZamPageRoute<void>(
        builder: (_) => _page('dialog'),
        fullscreenDialog: true,
      );

      expect(route.barrierColor, isNotNull);
      expect(route.barrierColor!.a, closeTo(0.1, 0.001));
      expect(dialog.barrierColor, isNull);
      expect(route.barrierLabel, isNull);
      expect(route.transitionDuration, const Duration(milliseconds: 500));
    }, variant: _ios);

    testWidgets('iOS slides a fullscreen dialog up and keeps the page below', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester, label: 'dialog', fullscreenDialog: true));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      final height = tester.getSize(find.byType(Navigator)).height;
      expect(leftOf(tester, 'dialog'), 0);
      expect(topOf(tester, 'dialog'), inExclusiveRange(0, height));
      expect(leftOf(tester, 'home'), 0);
      await tester.pumpAndSettle();
      expect(topOf(tester, 'dialog'), 0);
    }, variant: _ios);

    testWidgets('macOS uses the iOS slide', (tester) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(leftOf(tester, 'next'), greaterThan(0));
      await tester.pumpAndSettle();
    }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

    testWidgets('Android fades the page in while it slides a short distance', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      final width = tester.getSize(find.byType(Navigator)).width;
      expect(leftOf(tester, 'next'), inExclusiveRange(0, width / 4));
      expect(_opacityOf(tester, 'next'), inExclusiveRange(0, 1));
      // The covered page fades out while it slides towards the leading edge.
      expect(leftOf(tester, 'home'), inExclusiveRange(-width / 4, 0));
      expect(_opacityOf(tester, 'home'), lessThan(1));
      // The fill behind the two pages is the palette background, not black.
      expect(
        tester
            .widgetList<ColoredBox>(find.byType(ColoredBox))
            .map((box) => box.color),
        contains(testTheme.palette(Brightness.light).background),
      );

      await tester.pump(const Duration(milliseconds: 300));
      expect(leftOf(tester, 'next'), 0);
      expect(_opacityOf(tester, 'next'), 1);
      await tester.pumpAndSettle();
      expect(find.text('home'), findsNothing);
    }, variant: _android);

    testWidgets('Android reverses the fade when the route pops', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      navigator().pop();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));
      expect(leftOf(tester, 'next'), greaterThan(0));
      expect(_opacityOf(tester, 'next'), lessThan(1));
      await tester.pumpAndSettle();
      expect(find.text('next'), findsNothing);
      expect(leftOf(tester, 'home'), 0);
    }, variant: _android);

    testWidgets('Android has no barrier and runs over 450 ms', (tester) async {
      final route = ZamPageRoute<void>(builder: (_) => _page('next'));

      expect(route.barrierColor, isNull);
      expect(route.transitionDuration, const Duration(milliseconds: 450));
    }, variant: _android);

    testWidgets('a forced slide runs on Android', (tester) async {
      await pumpHome(tester);
      unawaited(push<void>(tester, transition: ZamPageTransition.slide));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));

      expect(leftOf(tester, 'next'), greaterThan(0));
      expect(_opacityOf(tester, 'next'), 1);
      await tester.pumpAndSettle();
    }, variant: _android);

    testWidgets('a forced fade runs on iOS', (tester) async {
      await pumpHome(tester);
      unawaited(push<void>(tester, transition: ZamPageTransition.fade));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 150));

      expect(_opacityOf(tester, 'next'), lessThan(1));
      // A fade route does not move the slide route below it.
      expect(leftOf(tester, 'home'), 0);
      await tester.pumpAndSettle();
    }, variant: _ios);

    testWidgets('none shows and removes the page at once', (tester) async {
      await pumpHome(tester);
      unawaited(push<void>(tester, transition: ZamPageTransition.none));
      await tester.pump();

      expect(leftOf(tester, 'next'), 0);
      expect(_opacityOf(tester, 'next'), 1);
      await tester.pump();
      expect(find.text('home'), findsNothing);

      navigator().pop();
      await tester.pump();
      await tester.pump();
      expect(find.text('next'), findsNothing);
      expect(
        ZamPageRoute<void>(
          builder: (_) => _page('x'),
          transition: ZamPageTransition.none,
        ).transitionDuration,
        Duration.zero,
      );
    }, variant: _ios);

    testWidgets('the page scopes a route semantics node', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      final semantics = tester.widget<Semantics>(
        find
            .ancestor(of: find.text('next'), matching: find.byType(Semantics))
            .first,
      );
      expect(semantics.properties.scopesRoute, isTrue);
      expect(semantics.explicitChildNodes, isTrue);
      handle.dispose();
    });

    testWidgets('keeps its settings, state and debug label', (tester) async {
      final route = ZamPageRoute<void>(
        builder: (_) => _page('x'),
        settings: const RouteSettings(name: '/x'),
        maintainState: false,
        fullscreenDialog: true,
      );

      expect(route.settings.name, '/x');
      expect(route.maintainState, isFalse);
      expect(route.fullscreenDialog, isTrue);
      expect(route.transition, ZamPageTransition.platform);
      expect(route.debugLabel, endsWith('(/x)'));
    });
  });

  group('ZamPageRoute back gesture', () {
    testWidgets('a slow drag past half the width pops the route', (
      tester,
    ) async {
      await pumpHome(tester);
      String? result = 'unset';
      unawaited(push<String>(tester).then((value) => result = value));
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(5, 300));
      await gesture.moveBy(const Offset(500, 0));
      await tester.pump();
      expect(navigator().userGestureInProgress, isTrue);
      // The page follows the finger, less the drag slop.
      expect(leftOf(tester, 'next'), inInclusiveRange(450, 500));
      expect(find.text('home'), findsOneWidget);

      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('next'), findsNothing);
      expect(result, isNull);
      expect(navigator().userGestureInProgress, isFalse);
    }, variant: _ios);

    testWidgets('a short drag released slowly settles the page back', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(5, 300));
      await gesture.moveBy(const Offset(200, 0));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(leftOf(tester, 'next'), 0);
      expect(find.text('home'), findsNothing);
      expect(navigator().userGestureInProgress, isFalse);
    }, variant: _ios);

    testWidgets('a fling from the edge pops even when short', (tester) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      await tester.flingFrom(const Offset(5, 300), const Offset(150, 0), 1500);
      await tester.pumpAndSettle();

      expect(find.text('next'), findsNothing);
      expect(find.text('home'), findsOneWidget);
    }, variant: _ios);

    testWidgets('a fling back towards the edge keeps the page', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      // Slowly past half the width, then fast back towards the edge.
      final gesture = await tester.createGesture();
      await gesture.down(const Offset(5, 300));
      for (var step = 1; step <= 30; step++) {
        await gesture.moveBy(
          const Offset(20, 0),
          timeStamp: Duration(milliseconds: step * 20),
        );
      }
      for (var step = 1; step <= 5; step++) {
        await gesture.moveBy(
          const Offset(-30, 0),
          timeStamp: Duration(milliseconds: 600 + step * 8),
        );
      }
      await tester.pump();
      // Past half: released slowly here, the page would pop.
      expect(leftOf(tester, 'next'), greaterThan(400));
      await gesture.up(timeStamp: const Duration(milliseconds: 645));
      await tester.pumpAndSettle();

      expect(find.text('next'), findsOneWidget);
      expect(leftOf(tester, 'next'), 0);
    }, variant: _ios);

    testWidgets('a drag that starts away from the edge does nothing', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(40, 300), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.text('next'), findsOneWidget);
      expect(leftOf(tester, 'next'), 0);
    }, variant: _ios);

    testWidgets('the edge widens to the leading safe area padding', (
      tester,
    ) async {
      tester.view.padding = const FakeViewPadding(left: 120);
      addTearDown(tester.view.resetPadding);
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      final ratio = tester.view.devicePixelRatio;
      await tester.dragFrom(Offset(120 / ratio - 2, 300), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.text('next'), findsNothing);
    }, variant: _ios);

    testWidgets('right-to-left drags from the right edge to the left', (
      tester,
    ) async {
      await pumpHome(tester, textDirection: TextDirection.rtl);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      // The left edge is the trailing edge here.
      await tester.dragFrom(const Offset(5, 300), const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.text('next'), findsOneWidget);

      final width = tester.getSize(find.byType(Navigator)).width;
      await tester.dragFrom(Offset(width - 5, 300), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text('next'), findsNothing);
    }, variant: _ios);

    testWidgets('the first route has no back gesture', (tester) async {
      await pumpHome(tester);

      await tester.dragFrom(const Offset(5, 300), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.text('home'), findsOneWidget);
      expect(navigator().userGestureInProgress, isFalse);
    }, variant: _ios);

    testWidgets('a fullscreen dialog has no back gesture', (tester) async {
      await pumpHome(tester);
      unawaited(push<void>(tester, label: 'dialog', fullscreenDialog: true));
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(5, 300), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.text('dialog'), findsOneWidget);
    }, variant: _ios);

    testWidgets('a PopScope that blocks the pop disables the gesture', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(
        push<void>(
          tester,
          builder: (_) => PopScope(canPop: false, child: _page('guarded')),
        ),
      );
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(5, 300), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.text('guarded'), findsOneWidget);
      expect(leftOf(tester, 'guarded'), 0);
    }, variant: _ios);

    testWidgets('the gesture is off while the page is still sliding in', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // The edge strip moves with the page.
      final gesture = await tester.startGesture(
        Offset(leftOf(tester, 'next') + 5, 300),
      );
      await gesture.moveBy(const Offset(500, 0));
      await tester.pump();
      expect(navigator().userGestureInProgress, isFalse);
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('next'), findsOneWidget);
    }, variant: _ios);

    testWidgets('a pop during the drag still removes the page', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(5, 300));
      await gesture.moveBy(const Offset(50, 0));
      await tester.pump();
      navigator().pop();
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.text('next'), findsNothing);
      expect(navigator().userGestureInProgress, isFalse);
    }, variant: _ios);

    testWidgets('a page removed mid-drag ends the gesture', (tester) async {
      await pumpHome(tester);
      final route = ZamPageRoute<void>(builder: (_) => _page('next'));
      navigator().push(route);
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(5, 300));
      await gesture.moveBy(const Offset(50, 0));
      await tester.pump();
      expect(navigator().userGestureInProgress, isTrue);

      navigator().removeRoute(route);
      await tester.pump();
      await tester.pump();
      expect(navigator().userGestureInProgress, isFalse);
      await gesture.up();
      await tester.pumpAndSettle();
      expect(find.text('next'), findsNothing);
    }, variant: _ios);

    testWidgets('a tap at the edge neither pops nor starts a gesture', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(5, 300));
      await tester.pumpAndSettle();

      expect(find.text('next'), findsOneWidget);
      expect(navigator().userGestureInProgress, isFalse);
    }, variant: _ios);

    testWidgets('a vertical scroll that starts at the edge wins', (
      tester,
    ) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await pumpHome(tester);
      unawaited(
        push<void>(
          tester,
          builder: (_) => ListView(
            controller: controller,
            children: [
              for (var i = 0; i < 50; i++)
                SizedBox(height: 50, child: Text('row $i')),
            ],
          ),
        ),
      );
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(5, 300), const Offset(0, -200));
      await tester.pumpAndSettle();

      expect(controller.offset, greaterThan(0));
      expect(find.text('row 0'), findsNothing);
      expect(find.byType(ListView), findsOneWidget);
      expect(navigator().userGestureInProgress, isFalse);
    }, variant: _ios);

    testWidgets('an app torn down mid-drag does not throw', (tester) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      final gesture = await tester.startGesture(const Offset(5, 300));
      await gesture.moveBy(const Offset(50, 0));
      await tester.pump();
      await tester.pumpWidget(const SizedBox());
      await tester.pump();
      await gesture.up();

      expect(tester.takeException(), isNull);
    }, variant: _ios);

    testWidgets('Android has no edge swipe; the back button pops', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester));
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(5, 300), const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.text('next'), findsOneWidget);

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(find.text('next'), findsNothing);
    }, variant: _android);

    testWidgets('a forced slide has the edge swipe on Android', (
      tester,
    ) async {
      await pumpHome(tester);
      unawaited(push<void>(tester, transition: ZamPageTransition.slide));
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(5, 300), const Offset(500, 0));
      await tester.pumpAndSettle();

      expect(find.text('next'), findsNothing);
    }, variant: _android);
  });

  group('ZamApp default route', () {
    testWidgets('named routes slide on iOS and swipe back', (tester) async {
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          navigatorKey: navigatorKey,
          routes: {
            '/': (_) => _page('home'),
            '/next': (_) => _page('next'),
          },
        ),
      );
      navigator().pushNamed('/next');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 250));
      expect(leftOf(tester, 'next'), greaterThan(0));
      await tester.pumpAndSettle();

      await tester.dragFrom(const Offset(5, 300), const Offset(500, 0));
      await tester.pumpAndSettle();
      expect(find.text('next'), findsNothing);
    }, variant: _ios);
  });
}

// The page's root widget, found from its label.
Widget _findPage(WidgetTester tester, String label) => tester
    .widgetList<ColoredBox>(
      find.ancestor(of: find.text(label), matching: find.byType(ColoredBox)),
    )
    .firstWhere((box) => box.color == const Color(0xFFFFFFFF));

double _opacityOf(WidgetTester tester, String label) {
  var opacity = 1.0;
  for (final transition in tester.widgetList<FadeTransition>(
    find.ancestor(of: find.text(label), matching: find.byType(FadeTransition)),
  )) {
    opacity *= transition.opacity.value;
  }
  return opacity;
}
