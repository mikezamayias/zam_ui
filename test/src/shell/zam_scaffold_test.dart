import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

const _barKey = Key('bar');
const _barHeight = 56.0;

class _Probe extends StatelessWidget {
  const _Probe(this.onBuild, {super.key});

  final void Function(BuildContext context) onBuild;

  @override
  Widget build(BuildContext context) {
    onBuild(context);
    return const SizedBox.expand();
  }
}

Future<void> _sendStatusBarTap(WidgetTester tester) {
  return tester.binding.defaultBinaryMessenger.handlePlatformMessage(
    'flutter/status_bar',
    const JSONMethodCodec().encodeMethodCall(
      const MethodCall('handleScrollToTop'),
    ),
    (_) {},
  );
}

void main() {
  late MediaQueryData bodyMedia;
  late MediaQueryData barMedia;

  Widget probeBody() => _Probe((context) => bodyMedia = MediaQuery.of(context));

  Widget bar() => _Probe(
    (context) => barMedia = MediaQuery.of(context),
    key: _barKey,
  );

  Widget sizedBar() => SizedBox(height: _barHeight, child: bar());

  // Physical pixels for a logical value on the test view.
  double physical(WidgetTester tester, double logical) =>
      logical * tester.view.devicePixelRatio;

  group('ZamScaffold layout', () {
    testWidgets('fills its box with the palette background', (tester) async {
      await tester.pumpApp(const ZamScaffold(body: Text('body')));

      final box = tester.widget<ColoredBox>(
        find
            .descendant(
              of: find.byType(ZamScaffold),
              matching: find.byType(ColoredBox),
            )
            .first,
      );
      expect(box.color, testTheme.palette(Brightness.light).background);
      expect(
        tester.getSize(find.byType(ZamScaffold)),
        tester.getSize(find.byType(Navigator)),
      );
    });

    testWidgets('takes an explicit background colour', (tester) async {
      const color = Color(0xFF123456);
      await tester.pumpApp(
        const ZamScaffold(body: Text('body'), backgroundColor: color),
      );

      expect(
        tester
            .widgetList<ColoredBox>(
              find.descendant(
                of: find.byType(ZamScaffold),
                matching: find.byType(ColoredBox),
              ),
            )
            .first
            .color,
        color,
      );
    });

    testWidgets('gives the body the whole box without a bar', (tester) async {
      await tester.pumpApp(ZamScaffold(body: probeBody()));

      expect(
        tester.getSize(find.byType(_Probe)),
        tester.getSize(find.byType(ZamScaffold)),
      );
    });

    testWidgets('places the bar at the bottom and the body above it', (
      tester,
    ) async {
      await tester.pumpApp(
        ZamScaffold(body: probeBody(), bottomBar: sizedBar()),
      );

      final screen = tester.getRect(find.byType(ZamScaffold));
      final barRect = tester.getRect(find.byKey(_barKey));
      final bodyRect = tester.getRect(find.byType(_Probe).first);
      expect(barRect.height, _barHeight);
      expect(barRect.bottom, screen.bottom);
      expect(barRect.width, screen.width);
      expect(bodyRect.top, screen.top);
      expect(bodyRect.bottom, barRect.top);
    });

    testWidgets('moves the bottom padding from the body to the bar', (
      tester,
    ) async {
      tester.view.padding = FakeViewPadding(bottom: physical(tester, 34));
      addTearDown(tester.view.resetPadding);
      await tester.pumpApp(
        ZamScaffold(body: probeBody(), bottomBar: sizedBar()),
      );

      expect(bodyMedia.padding.bottom, 0);
      expect(barMedia.padding.bottom, 34);
    });

    testWidgets('keeps the top padding for the body only', (tester) async {
      tester.view.padding = FakeViewPadding(top: physical(tester, 59));
      addTearDown(tester.view.resetPadding);
      await tester.pumpApp(
        ZamScaffold(body: probeBody(), bottomBar: sizedBar()),
      );

      expect(bodyMedia.padding.top, 59);
      expect(barMedia.padding.top, 0);
    });

    testWidgets('keeps the bottom padding for the body without a bar', (
      tester,
    ) async {
      tester.view.padding = FakeViewPadding(bottom: physical(tester, 34));
      addTearDown(tester.view.resetPadding);
      await tester.pumpApp(ZamScaffold(body: probeBody()));

      expect(bodyMedia.padding.bottom, 34);
    });

    testWidgets('adds no semantics node and no text style', (tester) async {
      late TextStyle outside;
      late TextStyle inside;
      await tester.pumpApp(
        _Probe((context) => outside = DefaultTextStyle.of(context).style),
      );
      await tester.pumpApp(
        ZamScaffold(
          body: _Probe(
            (context) => inside = DefaultTextStyle.of(context).style,
          ),
        ),
      );

      expect(inside, outside);
      expect(
        find.descendant(
          of: find.byType(ZamScaffold),
          matching: find.byType(Semantics),
        ),
        findsNothing,
      );
    });
  });

  group('ZamScaffold keyboard', () {
    testWidgets('lifts the body and the bar above the keyboard', (
      tester,
    ) async {
      tester.view.viewInsets = FakeViewPadding(bottom: physical(tester, 300));
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpApp(
        ZamScaffold(body: probeBody(), bottomBar: sizedBar()),
      );

      final screen = tester.getRect(find.byType(ZamScaffold));
      final barRect = tester.getRect(find.byKey(_barKey));
      expect(barRect.bottom, screen.bottom - 300);
      expect(tester.getRect(find.byType(_Probe).first).bottom, barRect.top);
      expect(bodyMedia.viewInsets.bottom, 0);
      expect(barMedia.viewInsets.bottom, 0);
    });

    testWidgets('lifts the body above the keyboard without a bar', (
      tester,
    ) async {
      tester.view.viewInsets = FakeViewPadding(bottom: physical(tester, 300));
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpApp(ZamScaffold(body: probeBody()));

      final screen = tester.getRect(find.byType(ZamScaffold));
      expect(tester.getRect(find.byType(_Probe)).bottom, screen.bottom - 300);
      expect(bodyMedia.viewInsets.bottom, 0);
    });

    testWidgets('lets the keyboard cover the screen when not resizing', (
      tester,
    ) async {
      tester.view.viewInsets = FakeViewPadding(bottom: physical(tester, 300));
      addTearDown(tester.view.resetViewInsets);
      await tester.pumpApp(
        ZamScaffold(
          body: probeBody(),
          bottomBar: sizedBar(),
          resizeToAvoidBottomInset: false,
        ),
      );

      final screen = tester.getRect(find.byType(ZamScaffold));
      expect(tester.getRect(find.byKey(_barKey)).bottom, screen.bottom);
      expect(bodyMedia.viewInsets.bottom, 300);
    });
  });

  group('ZamScaffold status bar tap', () {
    final controllers = <ScrollController>[];

    Widget list(String label, {bool? primary}) => ZamScaffold(
      body: Builder(
        builder: (context) {
          controllers.add(PrimaryScrollController.of(context));
          return ListView(
            primary: primary,
            children: [
              for (var i = 0; i < 100; i++)
                SizedBox(height: 50, child: Text('$label $i')),
            ],
          );
        },
      ),
    );

    setUp(controllers.clear);

    Future<void> setStatusBar(WidgetTester tester) async {
      tester.view.padding = FakeViewPadding(top: physical(tester, 47));
      addTearDown(tester.view.resetPadding);
    }

    testWidgets('scrolls the primary scroll view to the top on iOS', (
      tester,
    ) async {
      await setStatusBar(tester);
      await tester.pumpApp(list('row'));
      await tester.drag(find.byType(ListView), const Offset(0, -1500));
      await tester.pumpAndSettle();
      expect(controllers.last.offset, greaterThan(0));

      await _sendStatusBarTap(tester);
      await tester.pumpAndSettle();

      expect(controllers.last.offset, 0);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('scrolls on macOS too', (tester) async {
      await setStatusBar(tester);
      // Desktop scroll views take the primary controller only when asked.
      await tester.pumpApp(list('row', primary: true));
      controllers.last.jumpTo(800);
      await tester.pump();

      await _sendStatusBarTap(tester);
      await tester.pumpAndSettle();

      expect(controllers.last.offset, 0);
    }, variant: TargetPlatformVariant.only(TargetPlatform.macOS));

    testWidgets(
      'does nothing on other platforms',
      (tester) async {
        await setStatusBar(tester);
        await tester.pumpApp(list('row', primary: true));
        await tester.drag(find.byType(ListView), const Offset(0, -1500));
        await tester.pumpAndSettle();
        final offset = controllers.last.offset;
        expect(offset, greaterThan(0));

        await _sendStatusBarTap(tester);
        await tester.pumpAndSettle();

        expect(controllers.last.offset, offset);
      },
      variant: const TargetPlatformVariant({
        TargetPlatform.android,
        TargetPlatform.fuchsia,
        TargetPlatform.linux,
        TargetPlatform.windows,
      }),
    );

    testWidgets('only the foreground page scrolls', (tester) async {
      await setStatusBar(tester);
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          navigatorKey: navigatorKey,
          home: list('first'),
        ),
      );
      final first = controllers.last;
      first.jumpTo(800);
      navigatorKey.currentState!.push(
        ZamPageRoute<void>(builder: (_) => list('second')),
      );
      await tester.pumpAndSettle();
      final second = controllers.last;
      second.jumpTo(600);
      await tester.pump();

      await _sendStatusBarTap(tester);
      await tester.pumpAndSettle();

      expect(second.offset, 0);
      expect(first.offset, 800);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('does nothing without a status bar area', (tester) async {
      await tester.pumpApp(list('row'));
      controllers.last.jumpTo(800);
      await tester.pump();

      await _sendStatusBarTap(tester);
      await tester.pumpAndSettle();

      expect(controllers.last.offset, 800);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('does nothing without a scroll view', (tester) async {
      await setStatusBar(tester);
      await tester.pumpApp(const ZamScaffold(body: Text('plain')));

      await _sendStatusBarTap(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('stops listening once removed', (tester) async {
      await setStatusBar(tester);
      await tester.pumpApp(list('row'));
      await tester.pumpApp(const SizedBox());

      await _sendStatusBarTap(tester);
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  });
}
