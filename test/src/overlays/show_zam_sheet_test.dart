import 'dart:async';

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';
import 'overlay_test_support.dart';

const _content = Key('sheet-content');
const _sheetSize = Size(800, 600);

/// An 800 by 600 view with one device pixel per logical pixel.
void _useLogicalPixels(WidgetTester tester) {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = _sheetSize;
  addTearDown(tester.view.reset);
}

/// Sheet content that takes taps and drags, unlike an empty [SizedBox].
Widget _box({double? height}) => ColoredBox(
  key: _content,
  color: const Color(0x00000000),
  child: SizedBox(height: height),
);

Widget _fixed(BuildContext context) => _box(height: 200);

Widget _tall(BuildContext context) => _box(height: 2000);

typedef _Opened<T> = ({OverlayHost host, Future<T?> result});

Future<_Opened<T>> _open<T>(
  WidgetTester tester, {
  WidgetBuilder builder = _fixed,
  ZamSheetSide side = ZamSheetSide.bottom,
  bool isDismissible = true,
  bool enableDrag = true,
  bool showDragHandle = false,
  bool useSafeArea = true,
  double maxHeightFraction = 0.9,
  Color? backgroundColor,
  Color? borderColor,
  BorderRadiusGeometry? radius,
  String? barrierLabel,
  OverlayHost? host,
  bool settle = true,
}) async {
  final effectiveHost = host ?? OverlayHost(tester);
  if (host == null) await effectiveHost.pump();
  final result = showZamSheet<T>(
    context: effectiveHost.context,
    builder: builder,
    side: side,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    useSafeArea: useSafeArea,
    maxHeightFraction: maxHeightFraction,
    backgroundColor: backgroundColor,
    borderColor: borderColor,
    radius: radius,
    barrierLabel: barrierLabel,
  );
  if (settle) {
    await tester.pumpAndSettle();
  } else {
    await tester.pump();
  }
  return (host: effectiveHost, result: result);
}

Finder get _surface => find.ancestor(
  of: find.byKey(_content),
  matching: find.byType(ClipRRect),
);

void main() {
  group('showZamSheet placement', () {
    testWidgets('a bottom sheet sits on the bottom edge at full width', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);

      expect(
        tester.getRect(find.byKey(_content)),
        const Rect.fromLTRB(0, 400, 800, 600),
      );
    });

    testWidgets('a top sheet sits on the top edge at full width', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(tester, side: ZamSheetSide.top);

      expect(
        tester.getRect(find.byKey(_content)),
        const Rect.fromLTRB(0, 0, 800, 200),
      );
    });

    testWidgets('left and right sheets fill the height and cap the width', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(
        tester,
        side: ZamSheetSide.left,
        builder: (_) => _box(),
      );
      expect(
        tester.getRect(find.byKey(_content)),
        const Rect.fromLTRB(0, 0, 384, 600),
      );
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await _open<void>(
        tester,
        side: ZamSheetSide.right,
        builder: (_) => _box(),
      );
      expect(
        tester.getRect(find.byKey(_content)),
        const Rect.fromLTRB(416, 0, 800, 600),
      );
    });

    testWidgets('a side sheet takes three quarters of a narrow screen', (
      tester,
    ) async {
      tester.view
        ..devicePixelRatio = 1
        ..physicalSize = const Size(400, 600);
      addTearDown(tester.view.reset);
      await _open<void>(
        tester,
        side: ZamSheetSide.left,
        builder: (_) => _box(),
      );

      expect(tester.getSize(find.byKey(_content)).width, 300);
    });

    testWidgets('sides stay physical in right-to-left', (tester) async {
      _useLogicalPixels(tester);
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
        showZamSheet<void>(
          context: context,
          side: ZamSheetSide.left,
          builder: (_) => _box(),
        ),
      );
      await tester.pumpAndSettle();

      expect(tester.getRect(find.byKey(_content)).left, 0);
    });

    testWidgets('slides in from the edge while it opens', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(tester, settle: false);
      await tester.pump(const Duration(milliseconds: 60));

      final top = tester.getRect(find.byKey(_content)).top;
      expect(top, greaterThan(400));
      expect(top, lessThanOrEqualTo(600));

      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(_content)).top, 400);
    });

    testWidgets('caps a bottom sheet at maxHeightFraction', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(
        tester,
        builder: _tall,
        maxHeightFraction: 0.5,
        useSafeArea: false,
      );

      expect(tester.getSize(_surface).height, 300);
    });

    testWidgets('caps a tall bottom sheet at 90 percent by default', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(tester, builder: _tall, useSafeArea: false);

      expect(tester.getSize(_surface).height, 540);
    });
  });

  group('showZamSheet surface', () {
    testWidgets('fills with the card color and rounds the free corners', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);
      final palette = tester.element(find.byKey(_content)).zamPalette;

      final clip = tester.widget<ClipRRect>(_surface);
      final radius = testTheme.radius.dialog.topLeft;
      expect(clip.borderRadius, BorderRadius.vertical(top: radius));
      expect(
        tester
            .widget<ColoredBox>(
              find
                  .descendant(of: _surface, matching: find.byType(ColoredBox))
                  .first,
            )
            .color,
        palette.card,
      );
    });

    testWidgets('rounds the corners that face the screen on every side', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final radius = testTheme.radius.dialog.topLeft;
      final expected = {
        ZamSheetSide.top: BorderRadius.vertical(bottom: radius),
        ZamSheetSide.left: BorderRadius.horizontal(right: radius),
        ZamSheetSide.right: BorderRadius.horizontal(left: radius),
      };
      for (final entry in expected.entries) {
        await _open<void>(
          tester,
          side: entry.key,
          builder: (_) => _box(height: 100),
        );
        expect(tester.widget<ClipRRect>(_surface).borderRadius, entry.value);
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
      }
    });

    testWidgets('honors color, border and radius overrides', (tester) async {
      _useLogicalPixels(tester);
      const red = Color(0xFFCC0000);
      const green = Color(0xFF00CC00);
      await _open<void>(
        tester,
        backgroundColor: red,
        borderColor: green,
        radius: const BorderRadius.all(Radius.circular(4)),
      );

      expect(
        tester.widget<ClipRRect>(_surface).borderRadius,
        const BorderRadius.all(Radius.circular(4)),
      );
      expect(
        tester
            .widget<ColoredBox>(
              find
                  .descendant(of: _surface, matching: find.byType(ColoredBox))
                  .first,
            )
            .color,
        red,
      );
      final border = tester
          .widgetList<DecoratedBox>(
            find.descendant(of: _surface, matching: find.byType(DecoratedBox)),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((decoration) => decoration.border != null);
      expect(border.border!.top.color, green);
    });

    testWidgets('mirrors a directional radius in right-to-left', (
      tester,
    ) async {
      _useLogicalPixels(tester);
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
        showZamSheet<void>(
          context: context,
          radius: const BorderRadiusDirectional.only(
            topStart: Radius.circular(9),
          ),
          builder: _fixed,
        ),
      );
      await tester.pumpAndSettle();

      final radius = tester
          .widget<ClipRRect>(_surface)
          .borderRadius
          .resolve(TextDirection.rtl);
      expect(radius.topRight, const Radius.circular(9));
      expect(radius.topLeft, Radius.zero);
    });

    testWidgets('keeps the sheet below the status bar and above the home bar', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      tester.view.padding = const FakeViewPadding(top: 50, bottom: 34);
      addTearDown(tester.view.resetPadding);
      EdgeInsets? contentPadding;
      await _open<void>(
        tester,
        builder: (context) {
          contentPadding = MediaQuery.paddingOf(context);
          return _box(height: 2000);
        },
        maxHeightFraction: 1,
      );

      // The sheet reaches the bottom edge, the content clears the home bar,
      // and nothing is padded twice.
      expect(tester.getSize(_surface).height, 550);
      expect(tester.getRect(_surface).bottom, 600);
      expect(tester.getRect(find.byKey(_content)).bottom, 600 - 34);
      expect(contentPadding!.bottom, 0);
      expect(contentPadding!.top, 0);
    });

    testWidgets('ignores the safe area when useSafeArea is false', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      tester.view.padding = const FakeViewPadding(top: 50, bottom: 34);
      addTearDown(tester.view.resetPadding);
      EdgeInsets? contentPadding;
      await _open<void>(
        tester,
        builder: (context) {
          contentPadding = MediaQuery.paddingOf(context);
          return _box(height: 200);
        },
        useSafeArea: false,
      );

      expect(tester.getRect(find.byKey(_content)).bottom, 600);
      expect(contentPadding!.bottom, 34);
    });

    testWidgets('lifts above the keyboard and removes the inset below', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      double? insetBelow;
      await _open<void>(
        tester,
        builder: (context) {
          insetBelow = MediaQuery.viewInsetsOf(context).bottom;
          return _box(height: 200);
        },
      );

      expect(tester.getRect(find.byKey(_content)).bottom, 300);
      expect(insetBelow, 0);
    });

    testWidgets('moves with the keyboard while the sheet is open', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);
      expect(tester.getRect(find.byKey(_content)).bottom, 600);

      tester.view.viewInsets = const FakeViewPadding(bottom: 250);
      addTearDown(tester.view.resetViewInsets);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 40));
      final midway = tester.getRect(find.byKey(_content)).bottom;
      expect(midway, lessThan(600));
      expect(midway, greaterThan(350));

      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(_content)).bottom, 350);
    });

    testWidgets('colors unstyled text with the card foreground', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(tester, builder: (_) => const Text('hello'));
      final palette = tester.element(find.text('hello')).zamPalette;

      expect(
        DefaultTextStyle.of(tester.element(find.text('hello'))).style.color,
        palette.cardForeground,
      );
    });
  });

  group('showZamSheet dismissal', () {
    testWidgets('a barrier tap completes the future with null', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final opened = await _open<String>(tester);
      var completed = false;
      String? value = 'unset';
      unawaited(
        opened.result.then((v) {
          completed = true;
          value = v;
        }),
      );

      await tester.tapAt(const Offset(400, 100));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(value, isNull);
      expect(find.byKey(_content), findsNothing);
    });

    testWidgets('a barrier tap is ignored when not dismissible', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(tester, isDismissible: false);

      await tester.tapAt(const Offset(400, 100));
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsOneWidget);
    });

    testWidgets('a tap on the sheet does not dismiss it', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);

      await tester.tapAt(const Offset(400, 500));
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsOneWidget);
    });

    testWidgets('the system back action completes the future with null', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final opened = await _open<String>(tester);
      var completed = false;
      String? value = 'unset';
      unawaited(
        opened.result.then((v) {
          completed = true;
          value = v;
        }),
      );

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(value, isNull);
    });

    testWidgets('Escape closes the sheet', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsNothing);
    });

    testWidgets('returns the value the content pops with', (tester) async {
      _useLogicalPixels(tester);
      final opened = await _open<int>(
        tester,
        builder: (context) => GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => Navigator.of(context).pop(7),
          child: _box(height: 200),
        ),
      );
      int? value;
      unawaited(opened.result.then((v) => value = v));

      await tester.tap(find.byKey(_content));
      await tester.pumpAndSettle();

      expect(value, 7);
    });
  });

  group('showZamSheet drag', () {
    testWidgets('follows the finger one to one', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_content)),
      );
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump();
      await gesture.moveBy(const Offset(0, 20));
      await tester.pump();

      // The drag recognizer swallows the first move to win the arena.
      final top = tester.getRect(find.byKey(_content)).top;
      expect(top, greaterThan(400));
      await gesture.up();
      await tester.pumpAndSettle();
    });

    testWidgets('a fast swipe down closes the sheet', (tester) async {
      _useLogicalPixels(tester);
      final opened = await _open<String>(tester);
      var completed = false;
      unawaited(opened.result.then((_) => completed = true));

      await tester.fling(
        find.byKey(_content),
        const Offset(0, 120),
        1500,
      );
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      expect(find.byKey(_content), findsNothing);
    });

    testWidgets('a slow drag past halfway closes the sheet', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_content)),
      );
      for (var i = 0; i < 12; i++) {
        await gesture.moveBy(const Offset(0, 12));
        await tester.pump(const Duration(milliseconds: 200));
      }
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsNothing);
    });

    testWidgets('a short slow drag snaps back and keeps the sheet', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_content)),
      );
      for (var i = 0; i < 4; i++) {
        await gesture.moveBy(const Offset(0, 10));
        await tester.pump(const Duration(milliseconds: 200));
      }
      await gesture.up();
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsOneWidget);
      expect(tester.getRect(find.byKey(_content)).top, 400);
    });

    testWidgets('a cancelled drag snaps back', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);

      final gesture = await tester.startGesture(
        tester.getCenter(find.byKey(_content)),
      );
      await gesture.moveBy(const Offset(0, 60));
      await tester.pump();
      await gesture.cancel();
      await tester.pumpAndSettle();

      expect(tester.getRect(find.byKey(_content)).top, 400);
    });

    testWidgets('a swipe up does not close a bottom sheet', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(tester);

      await tester.fling(find.byKey(_content), const Offset(0, -120), 1500);
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsOneWidget);
      expect(tester.getRect(find.byKey(_content)).top, 400);
    });

    testWidgets('does nothing when enableDrag is false', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(tester, enableDrag: false);

      await tester.fling(find.byKey(_content), const Offset(0, 120), 1500);
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsOneWidget);
    });

    testWidgets('a top sheet closes with a swipe up', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(tester, side: ZamSheetSide.top);

      await tester.fling(find.byKey(_content), const Offset(0, -120), 1500);
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsNothing);
    });

    testWidgets('a left sheet closes with a swipe left', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(
        tester,
        side: ZamSheetSide.left,
        builder: (_) => _box(),
      );

      await tester.fling(find.byKey(_content), const Offset(-120, 0), 1500);
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsNothing);
    });

    testWidgets('a right sheet closes with a swipe right', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(
        tester,
        side: ZamSheetSide.right,
        builder: (_) => _box(),
      );

      await tester.fling(find.byKey(_content), const Offset(120, 0), 1500);
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsNothing);
    });

    testWidgets('snaps back when a PopScope blocks the close', (tester) async {
      _useLogicalPixels(tester);
      await _open<void>(
        tester,
        builder: (_) => PopScope(canPop: false, child: _box(height: 200)),
      );

      await tester.fling(find.byKey(_content), const Offset(0, 120), 1500);
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsOneWidget);
      expect(tester.getRect(find.byKey(_content)).top, 400);

      // It can be dragged again afterwards.
      await tester.fling(find.byKey(_content), const Offset(0, 120), 1500);
      await tester.pumpAndSettle();
      expect(tester.getRect(find.byKey(_content)).top, 400);
    });

    testWidgets('a scrollable inside the sheet keeps its own drags', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(
        tester,
        builder: (_) => ListView(
          children: [_box(height: 2000)],
        ),
      );

      await tester.fling(find.byType(ListView), const Offset(0, -100), 1000);
      await tester.pumpAndSettle();
      await tester.fling(find.byType(ListView), const Offset(0, 40), 300);
      await tester.pumpAndSettle();

      expect(find.byKey(_content), findsOneWidget);
    });
  });

  group('showZamSheet themes', () {
    testWidgets('republishes a shad theme applied below the navigator', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      late BuildContext context;
      final local = ShadThemeData(
        brightness: Brightness.dark,
        colorScheme: const ShadZincColorScheme.dark(),
      );
      await tester.pumpApp(
        ShadTheme(
          data: local,
          child: Builder(
            builder: (ctx) {
              context = ctx;
              return const SizedBox();
            },
          ),
        ),
      );

      Brightness? seen;
      unawaited(
        showZamSheet<void>(
          context: context,
          builder: (inner) {
            seen = ShadTheme.of(inner).brightness;
            return _box(height: 100);
          },
        ),
      );
      await tester.pumpAndSettle();

      expect(seen, Brightness.dark);
    });
  });

  group('showZamSheet drag handle', () {
    testWidgets('adds a handle above the content when asked to', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await _open<void>(tester, showDragHandle: true);
      final palette = tester.element(find.byKey(_content)).zamPalette;

      // The handle is a 4 high pill with 12 above and below it.
      expect(tester.getSize(_surface).height, 200 + 28);
      expect(tester.getRect(find.byKey(_content)).bottom, 600);
      final pill = find.byWidgetPredicate(
        (widget) =>
            widget is DecoratedBox &&
            widget.decoration is BoxDecoration &&
            (widget.decoration as BoxDecoration).color == palette.mutedControl,
      );
      expect(pill, findsOneWidget);
      expect(tester.getSize(pill), const Size(32, 4));
    });

    testWidgets('exposes the handle to screen readers as a dismiss button', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final semantics = tester.ensureSemantics();
      final opened = await _open<String>(tester, showDragHandle: true);
      var completed = false;
      unawaited(opened.result.then((_) => completed = true));

      expect(buttonsLabeled('Dismiss'), findsOneWidget);
      tester.semantics.tap(buttonsLabeled('Dismiss'));
      await tester.pumpAndSettle();

      expect(completed, isTrue);
      semantics.dispose();
    });

    testWidgets('keeps the handle a small node that only taps', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final semantics = tester.ensureSemantics();
      await _open<void>(
        tester,
        showDragHandle: true,
        builder: (_) => ListView(children: [_box(height: 2000)]),
      );

      // The drag detector's scroll actions must not merge into the handle,
      // so the focus rectangle of a screen reader stays on the pill.
      final handle = buttonsLabeled('Dismiss').evaluate().single;
      expect(handle.rect.width, lessThanOrEqualTo(64));
      expect(handle.rect.height, lessThanOrEqualTo(44));
      expect(handle.rect.width, greaterThanOrEqualTo(32));
      expect(handle.rect.height, greaterThanOrEqualTo(28));
      expect(handle.getSemanticsData().actions, SemanticsAction.tap.index);

      // Only the scrollable content scrolls, and it is not the handle.
      final scrollers = find.semantics.byPredicate(
        (node) => node.getSemanticsData().hasAction(SemanticsAction.scrollUp),
      );
      expect(scrollers, findsOneWidget);
      expect(scrollers.evaluate().single.label, isNot('Dismiss'));
      semantics.dispose();
    });

    testWidgets('names the handle with a custom barrier label', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final semantics = tester.ensureSemantics();
      await _open<void>(
        tester,
        showDragHandle: true,
        barrierLabel: 'Close sheet',
      );

      expect(buttonsLabeled('Close sheet'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('has no handle by default or on a side sheet', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final semantics = tester.ensureSemantics();
      await _open<void>(tester);
      expect(buttonsLabeled('Dismiss'), findsNothing);
      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();

      await _open<void>(
        tester,
        side: ZamSheetSide.left,
        showDragHandle: true,
        builder: (_) => _box(),
      );
      expect(buttonsLabeled('Dismiss'), findsNothing);
      semantics.dispose();
    });
  });

  group('showZamSheet accessibility', () {
    testWidgets('names the barrier with the localized dismiss label', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final semantics = tester.ensureSemantics();
      await _open<void>(tester);

      expect(find.bySemanticsLabel('Dismiss'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('uses a custom barrier label', (tester) async {
      _useLogicalPixels(tester);
      final semantics = tester.ensureSemantics();
      await _open<void>(tester, barrierLabel: 'Close sheet');

      expect(find.bySemanticsLabel('Close sheet'), findsOneWidget);
      semantics.dispose();
    });

    testWidgets('is a semantics scope, so screen readers announce it', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final semantics = tester.ensureSemantics();
      await _open<void>(tester, builder: (_) => const Text('Share'));

      expect(inRouteScope(tester, find.text('Share')), isTrue);
      semantics.dispose();
    });

    testWidgets('keeps focus inside the sheet and restores it on close', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      final outside = FocusNode(debugLabel: 'outside');
      final inside = FocusNode(debugLabel: 'inside');
      addTearDown(() {
        outside.dispose();
        inside.dispose();
      });
      final host = OverlayHost(tester);
      await host.pump(
        wrap: (page) => Focus(
          focusNode: outside,
          autofocus: true,
          child: page,
        ),
      );
      expect(outside.hasPrimaryFocus, isTrue);

      await _open<void>(
        tester,
        host: host,
        builder: (_) => Focus(
          focusNode: inside,
          autofocus: true,
          child: _box(height: 100),
        ),
      );
      expect(inside.hasPrimaryFocus, isTrue);

      for (var i = 0; i < 4; i++) {
        await tester.sendKeyEvent(LogicalKeyboardKey.tab);
        await tester.pump();
        expect(outside.hasPrimaryFocus, isFalse);
      }

      await tester.binding.handlePopRoute();
      await tester.pumpAndSettle();
      expect(outside.hasPrimaryFocus, isTrue);
    });

    testWidgets('fades instead of sliding when animations are reduced', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      tester.platformDispatcher.accessibilityFeaturesTestValue =
          const FakeAccessibilityFeatures(disableAnimations: true);
      addTearDown(
        tester.platformDispatcher.clearAccessibilityFeaturesTestValue,
      );
      await _open<void>(tester, settle: false);
      await tester.pump();

      // The sheet is where it ends up from the first frame on.
      expect(tester.getRect(find.byKey(_content)).top, 400);
      expect(
        find.ancestor(
          of: find.byKey(_content),
          matching: find.byType(Opacity),
        ),
        findsOneWidget,
      );
      expect(
        find.ancestor(
          of: find.byKey(_content),
          matching: find.byType(FractionalTranslation),
        ),
        findsNothing,
      );
      await tester.pumpAndSettle();
    });
  });
}
