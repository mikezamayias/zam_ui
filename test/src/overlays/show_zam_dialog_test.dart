import 'dart:async';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';
import 'overlay_test_support.dart';

const _content = Key('dialog-content');

Widget _dialog(BuildContext context) => const ZamDialogSurface(
  child: SizedBox(key: _content, width: 200, height: 100),
);

void main() {
  group('showZamDialog', () {
    testWidgets('opens the dialog above the page and fades it in', (
      tester,
    ) async {
      final host = OverlayHost(tester);
      await host.pump();

      unawaited(showZamDialog<void>(context: host.context, builder: _dialog));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final fade = tester.widget<FadeTransition>(
        find.ancestor(
          of: find.byKey(_content),
          matching: find.byType(FadeTransition),
        ),
      );
      expect(fade.opacity.value, inExclusiveRange(0, 1));

      await tester.pumpAndSettle();
      expect(find.byKey(_content), findsOneWidget);
      expect(find.text('page'), findsOneWidget);
    });

    testWidgets('uses the tokenized scrim and no blur by default', (
      tester,
    ) async {
      final host = OverlayHost(tester);
      await host.pump();

      unawaited(showZamDialog<void>(context: host.context, builder: _dialog));
      await tester.pumpAndSettle();

      final barrier = tester.widget<ModalBarrier>(
        find.byType(ModalBarrier).last,
      );
      expect(barrier.color, ZamColorUtils.barrier);
      expect(find.byType(BackdropFilter), findsNothing);
    });

    testWidgets('blurs what is behind the barrier when asked to', (
      tester,
    ) async {
      final host = OverlayHost(tester);
      await host.pump();

      unawaited(
        showZamDialog<void>(
          context: host.context,
          builder: _dialog,
          barrierBlurSigma: 4,
        ),
      );
      await tester.pumpAndSettle();

      expect(find.byType(BackdropFilter), findsOneWidget);
      final filter = tester.widget<BackdropFilter>(
        find.byType(BackdropFilter),
      );
      expect(filter.filter, ui.ImageFilter.blur(sigmaX: 4, sigmaY: 4));
    });

    testWidgets('a barrier tap completes the future with null', (
      tester,
    ) async {
      final host = OverlayHost(tester);
      await host.pump();

      var completed = false;
      String? result = 'unset';
      unawaited(
        showZamDialog<String>(context: host.context, builder: _dialog).then((
          value,
        ) {
          completed = true;
          result = value;
        }),
      );
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(result, isNull);
      expect(find.byKey(_content), findsNothing);
    });

    testWidgets('a barrier tap is ignored when not dismissible', (
      tester,
    ) async {
      final host = OverlayHost(tester);
      await host.pump();

      unawaited(
        showZamDialog<void>(
          context: host.context,
          builder: _dialog,
          barrierDismissible: false,
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsOneWidget);
    });

    testWidgets('the system back action closes the dialog with null', (
      tester,
    ) async {
      final host = OverlayHost(tester);
      await host.pump();

      var completed = false;
      unawaited(
        showZamDialog<String>(
          context: host.context,
          builder: _dialog,
        ).then((_) => completed = true),
      );
      await tester.pumpAndSettle();

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.byKey(_content), findsNothing);
    });

    testWidgets('returns the value the dialog pops with', (tester) async {
      final host = OverlayHost(tester);
      await host.pump();

      String? result;
      unawaited(
        showZamDialog<String>(
          context: host.context,
          builder: (context) => ZamDialogSurface(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => Navigator.of(context).pop('done'),
              child: const SizedBox(key: _content, width: 100, height: 100),
            ),
          ),
        ).then((value) => result = value),
      );
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(_content));
      await tester.pumpAndSettle();

      expect(result, 'done');
    });

    testWidgets('pushes onto the root navigator by default', (tester) async {
      final navigatorKey = GlobalKey<NavigatorState>();
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          themeMode: ZamThemeMode.light,
          navigatorKey: navigatorKey,
          home: Navigator(
            onGenerateRoute: (settings) => PageRouteBuilder<void>(
              settings: settings,
              pageBuilder: (context, _, _) => Builder(
                builder: (context) {
                  unawaited(
                    Future<void>.microtask(
                      () => showZamDialog<void>(
                        context: context,
                        builder: _dialog,
                        routeSettings: const RouteSettings(name: 'zam-dialog'),
                      ),
                    ),
                  );
                  return const SizedBox();
                },
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      var rootHasDialog = false;
      navigatorKey.currentState!.popUntil((route) {
        rootHasDialog = rootHasDialog || route.settings.name == 'zam-dialog';
        return true;
      });
      expect(rootHasDialog, isTrue);
    });

    testWidgets('names the barrier with the localized dismiss label', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final host = OverlayHost(tester);
      await host.pump();

      unawaited(showZamDialog<void>(context: host.context, builder: _dialog));
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Dismiss'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('uses a custom barrier label', (tester) async {
      final semantics = tester.ensureSemantics();
      final host = OverlayHost(tester);
      await host.pump();

      unawaited(
        showZamDialog<void>(
          context: host.context,
          builder: _dialog,
          barrierLabel: 'Close the dialog',
        ),
      );
      await tester.pumpAndSettle();

      expect(find.bySemanticsLabel('Close the dialog'), findsOneWidget);
      expect(find.bySemanticsLabel('Dismiss'), findsNothing);
      semantics.dispose();
    });

    testWidgets('is a semantics scope, so screen readers announce it', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final host = OverlayHost(tester);
      await host.pump();

      unawaited(
        showZamDialog<void>(
          context: host.context,
          builder: (context) => const ZamDialogSurface(
            child: Text('Delete entry', key: _content),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(inRouteScope(tester, find.byKey(_content)), isTrue);
      semantics.dispose();
    });

    testWidgets('keeps focus inside the dialog and restores it on close', (
      tester,
    ) async {
      final outside = FocusNode(debugLabel: 'outside');
      final first = FocusNode(debugLabel: 'first');
      final second = FocusNode(debugLabel: 'second');
      addTearDown(() {
        outside.dispose();
        first.dispose();
        second.dispose();
      });
      late BuildContext context;
      await tester.pumpApp(
        Builder(
          builder: (ctx) {
            context = ctx;
            return Focus(
              focusNode: outside,
              autofocus: true,
              child: const SizedBox(),
            );
          },
        ),
      );
      expect(outside.hasPrimaryFocus, isTrue);

      unawaited(
        showZamDialog<void>(
          context: context,
          builder: (_) => ZamDialogSurface(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Focus(
                  focusNode: first,
                  autofocus: true,
                  child: const SizedBox(width: 50, height: 20),
                ),
                Focus(
                  focusNode: second,
                  child: const SizedBox(width: 50, height: 20),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(first.hasPrimaryFocus, isTrue);

      // Tab traversal loops inside the dialog and never reaches the page.
      final visited = <FocusNode>{};
      for (var i = 0; i < 6; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        visited.add(FocusManager.instance.primaryFocus!);
      }
      expect(visited, containsAll(<FocusNode>[first, second]));
      expect(visited, isNot(contains(outside)));

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(outside.hasPrimaryFocus, isTrue);
    });

    testWidgets('republishes a theme applied below the navigator', (
      tester,
    ) async {
      final local = ZamThemeData(
        colors: ZamColorTokens.fromSeed(primary: const Color(0xFFAA0000)),
        typography: const ZamTypographyTokens(fontFamily: 'Local Sans'),
        icons: testTheme.icons,
      );
      late BuildContext context;
      await tester.pumpApp(
        ZamTheme(
          data: local,
          child: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox();
            },
          ),
        ),
      );

      ZamThemeData? seen;
      unawaited(
        showZamDialog<void>(
          context: context,
          builder: (inner) {
            seen = inner.zam;
            return const SizedBox();
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(seen, same(local));
    });

    testWidgets('lays out in right-to-left', (tester) async {
      late BuildContext context;
      await pumpRtlApp(
        tester,
        Builder(
          builder: (ctx) {
            context = ctx;
            return const SizedBox();
          },
        ),
      );

      unawaited(
        showZamDialog<void>(
          context: context,
          builder: (_) => const ZamDialogSurface(
            insetPadding: EdgeInsetsDirectional.only(start: 100, end: 20),
            child: SizedBox(key: _content, width: 2000, height: 40),
          ),
        ),
      );
      await tester.pumpAndSettle();

      final rect = tester.getRect(find.byKey(_content));
      // The start side is the right in right-to-left.
      expect(rect.right, 800 - 100);
      expect(rect.left, 20);
    });
  });
}
