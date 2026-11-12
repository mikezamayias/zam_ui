import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';
import 'overlay_test_support.dart';

const _trigger = Key('trigger');
const _message = 'Settings';

Widget _child({VoidCallback? onTap}) => GestureDetector(
  key: _trigger,
  behavior: HitTestBehavior.opaque,
  onTap: onTap,
  child: const SizedBox(width: 48, height: 48),
);

Future<void> _pump(
  WidgetTester tester, {
  bool excludeFromSemantics = false,
  Duration? waitDuration,
  VoidCallback? onTap,
}) {
  return tester.pumpApp(
    Center(
      child: ZamTooltip(
        message: _message,
        excludeFromSemantics: excludeFromSemantics,
        waitDuration: waitDuration,
        child: _child(onTap: onTap),
      ),
    ),
  );
}

Future<TestGesture> _hover(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  addTearDown(mouse.removePointer);
  await tester.pump();
  await mouse.moveTo(tester.getCenter(find.byKey(_trigger)));
  return mouse;
}

/// The long-press delay before a touch tooltip appears, plus a margin.
const _longPress = Duration(milliseconds: 700);

void main() {
  group('ZamTooltip', () {
    testWidgets('is hidden until it is triggered', (tester) async {
      await _pump(tester);

      expect(find.text(_message), findsNothing);
      expect(find.byKey(_trigger), findsOneWidget);
    });

    testWidgets('shows on long press and hides itself after a moment', (
      tester,
    ) async {
      await _pump(tester);

      final press = await tester.startGesture(
        tester.getCenter(find.byKey(_trigger)),
      );
      await tester.pump(_longPress);
      await press.up();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(_message), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text(_message), findsNothing);
    });

    testWidgets('a quick tap does not show the tooltip and still taps', (
      tester,
    ) async {
      var taps = 0;
      await _pump(tester, onTap: () => taps++);

      await tester.tap(find.byKey(_trigger));
      await tester.pump(const Duration(milliseconds: 300));

      expect(taps, 1);
      expect(find.text(_message), findsNothing);
    });

    testWidgets('a long press on a tappable child does not tap it', (
      tester,
    ) async {
      var taps = 0;
      await _pump(tester, onTap: () => taps++);

      final press = await tester.startGesture(
        tester.getCenter(find.byKey(_trigger)),
      );
      await tester.pump(_longPress);
      await press.up();
      await tester.pump();

      expect(taps, 0);
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('shows on hover and hides when the pointer leaves', (
      tester,
    ) async {
      await _pump(tester);

      final mouse = await _hover(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(_message), findsOneWidget);

      await mouse.moveTo(const Offset(5, 5));
      await tester.pumpAndSettle();
      expect(find.text(_message), findsNothing);
    });

    testWidgets('waits before showing on hover when asked to', (tester) async {
      await _pump(tester, waitDuration: const Duration(milliseconds: 500));

      await _hover(tester);
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.text(_message), findsNothing);

      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(_message), findsOneWidget);
    });

    testWidgets('Escape hides a shown tooltip', (tester) async {
      await _pump(tester);
      await _hover(tester);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text(_message), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text(_message), findsNothing);
    });

    testWidgets('shows the message above the child', (tester) async {
      await _pump(tester);
      final press = await tester.startGesture(
        tester.getCenter(find.byKey(_trigger)),
      );
      await tester.pump(_longPress);
      await press.up();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final tip = tester.getRect(find.text(_message));
      final child = tester.getRect(find.byKey(_trigger));
      expect(tip.bottom, lessThan(child.top));
      expect(tip.center.dx, closeTo(child.center.dx, 1));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('keeps the tooltip inside the screen next to an edge', (
      tester,
    ) async {
      await tester.pumpApp(
        const Align(
          alignment: Alignment.topLeft,
          child: ZamTooltip(
            message: 'A rather long explanation of this control',
            child: SizedBox(key: _trigger, width: 24, height: 24),
          ),
        ),
      );
      final press = await tester.startGesture(
        tester.getCenter(find.byKey(_trigger)),
      );
      await tester.pump(_longPress);
      await press.up();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      final tip = tester.getRect(
        find.text('A rather long explanation of this control'),
      );
      expect(tip.left, greaterThanOrEqualTo(0));
      expect(tip.top, greaterThanOrEqualTo(0));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('shows in right-to-left', (tester) async {
      await pumpRtlApp(
        tester,
        const Center(
          child: ZamTooltip(
            message: _message,
            child: SizedBox(key: _trigger, width: 48, height: 48),
          ),
        ),
      );
      final press = await tester.startGesture(
        tester.getCenter(find.byKey(_trigger)),
      );
      await tester.pump(_longPress);
      await press.up();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(_message), findsOneWidget);
      expect(
        tester.getRect(find.text(_message)).center.dx,
        closeTo(tester.getRect(find.byKey(_trigger)).center.dx, 1),
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('disposes cleanly while a long-pressed tooltip is shown', (
      tester,
    ) async {
      await _pump(tester);
      final press = await tester.startGesture(
        tester.getCenter(find.byKey(_trigger)),
      );
      await tester.pump(_longPress);
      await press.up();
      await tester.pump();

      await tester.pumpWidget(const SizedBox());
      await tester.pump(const Duration(seconds: 3));

      expect(tester.takeException(), isNull);
    });
  });

  group('ZamTooltip semantics', () {
    testWidgets('exposes the message as the tooltip of the child', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpApp(
        Center(
          child: ZamTooltip(
            message: _message,
            child: Semantics(
              label: 'Open settings',
              button: true,
              child: const SizedBox(key: _trigger, width: 48, height: 48),
            ),
          ),
        ),
      );

      final node = tester.getSemantics(find.byKey(_trigger));
      expect(node.tooltip, _message);
      expect(node.label, 'Open settings');
      semantics.dispose();
    });

    testWidgets('leaves the message out when asked to', (tester) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpApp(
        Center(
          child: ZamTooltip(
            message: _message,
            excludeFromSemantics: true,
            child: Semantics(
              label: 'Settings',
              button: true,
              child: const SizedBox(key: _trigger, width: 48, height: 48),
            ),
          ),
        ),
      );

      expect(tester.getSemantics(find.byKey(_trigger)).tooltip, isEmpty);
      semantics.dispose();
    });

    testWidgets('adds nothing to the ancestor semantics when excluded', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpApp(
        Center(
          child: Semantics(
            key: _trigger,
            container: true,
            label: 'Settings',
            button: true,
            child: const ZamTooltip(
              message: _message,
              excludeFromSemantics: true,
              child: SizedBox(width: 48, height: 48),
            ),
          ),
        ),
      );

      final data = tester.getSemantics(find.byKey(_trigger)).getSemanticsData();
      expect(data.hasAction(SemanticsAction.longPress), isFalse);
      expect(data.tooltip, isEmpty);
      semantics.dispose();
    });

    testWidgets('still adds the long press action to the ancestor', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpApp(
        Center(
          child: Semantics(
            key: _trigger,
            container: true,
            label: 'Settings',
            button: true,
            child: const ZamTooltip(
              message: _message,
              child: SizedBox(width: 48, height: 48),
            ),
          ),
        ),
      );

      final data = tester.getSemantics(find.byKey(_trigger)).getSemanticsData();
      expect(data.hasAction(SemanticsAction.longPress), isTrue);
      expect(data.tooltip, _message);
      semantics.dispose();
    });

    testWidgets('gives screen readers a long press action to open it', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      await tester.pumpApp(
        Center(
          child: ZamTooltip(
            message: _message,
            child: Semantics(
              label: 'Open settings',
              button: true,
              child: const SizedBox(key: _trigger, width: 48, height: 48),
            ),
          ),
        ),
      );

      final node = tester.getSemantics(find.byKey(_trigger));
      expect(
        node.getSemanticsData().hasAction(SemanticsAction.longPress),
        true,
      );

      tester.semantics.longPress(find.semantics.byLabel('Open settings'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.text(_message), findsOneWidget);
      semantics.dispose();
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('tells TalkBack when the tooltip opens', (tester) async {
      final events = <Map<Object?, Object?>>[];
      tester.binding.defaultBinaryMessenger
          .setMockDecodedMessageHandler<dynamic>(SystemChannels.accessibility, (
            message,
          ) async {
            events.add(message as Map<Object?, Object?>);
            return null;
          });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger
            .setMockDecodedMessageHandler<dynamic>(
              SystemChannels.accessibility,
              null,
            ),
      );
      await _pump(tester);

      final press = await tester.startGesture(
        tester.getCenter(find.byKey(_trigger)),
      );
      await tester.pump(_longPress);
      await press.up();
      await tester.pump();

      expect(
        events
            .where((event) => event['type'] == 'tooltip')
            .map(
              (event) => (event['data']! as Map<Object?, Object?>)['message'],
            ),
        [_message],
      );
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });

    testWidgets('does not tell TalkBack when the message is excluded', (
      tester,
    ) async {
      final types = <Object?>[];
      tester.binding.defaultBinaryMessenger
          .setMockDecodedMessageHandler<dynamic>(SystemChannels.accessibility, (
            message,
          ) async {
            types.add((message as Map<Object?, Object?>)['type']);
            return null;
          });
      addTearDown(
        () => tester.binding.defaultBinaryMessenger
            .setMockDecodedMessageHandler<dynamic>(
              SystemChannels.accessibility,
              null,
            ),
      );
      await _pump(tester, excludeFromSemantics: true);

      final press = await tester.startGesture(
        tester.getCenter(find.byKey(_trigger)),
      );
      await tester.pump(_longPress);
      await press.up();
      await tester.pump();

      expect(types, isNot(contains('tooltip')));
      await tester.pumpAndSettle(const Duration(seconds: 3));
    });
  });
}
