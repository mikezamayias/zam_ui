import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';
import '../../helpers/helpers.dart';

void main() {
  group('ZamAsyncButton', () {
    testWidgets('disables and shows loading while the future is in flight', (
      tester,
    ) async {
      final completer = Completer<void>();

      await tester.pumpApp(
        ZamAsyncButton(label: 'Save', onPressed: () => completer.future),
      );

      await tester.tap(find.text('Save'));
      await tester.pump();

      var button = tester.widget<ShadButton>(find.byType(ShadButton));
      expect(button.enabled, isFalse);
      expect(button.onPressed, isNull);
      expect(tester.widget<ZamButton>(find.byType(ZamButton)).isLoading, true);

      completer.complete();
      await tester.pump();

      button = tester.widget<ShadButton>(find.byType(ShadButton));
      expect(button.enabled, isTrue);
      expect(button.onPressed, isNotNull);
      expect(
        tester.widget<ZamButton>(find.byType(ZamButton)).isLoading,
        false,
      );
    });

    testWidgets('re-enables and rethrows when the future fails', (
      tester,
    ) async {
      final completer = Completer<void>();

      await tester.pumpApp(
        ZamAsyncButton(label: 'Save', onPressed: () => completer.future),
      );

      final onPressed =
          tester.widget<ZamButton>(find.byType(ZamButton)).onPressed!
              as Future<void> Function();
      final pressed = onPressed();
      await tester.pump();

      var button = tester.widget<ShadButton>(find.byType(ShadButton));
      expect(button.enabled, isFalse);

      completer.completeError(StateError('save failed'));
      final rethrown = expectLater(pressed, throwsStateError);
      await tester.pump();
      await rethrown;

      button = tester.widget<ShadButton>(find.byType(ShadButton));
      expect(button.enabled, isTrue);
    });

    testWidgets('invokes the callback once for rapid taps', (tester) async {
      final completer = Completer<void>();
      var calls = 0;

      await tester.pumpApp(
        ZamAsyncButton(
          label: 'Submit',
          onPressed: () {
            calls++;
            return completer.future;
          },
        ),
      );

      await tester.tap(find.text('Submit'));
      await tester.tap(find.text('Submit'));
      await tester.pump();
      await tester.tap(find.text('Submit'));

      completer.complete();
      await tester.pump();

      expect(calls, 1);
    });

    testWidgets('survives disposal while the future is in flight', (
      tester,
    ) async {
      final completer = Completer<void>();

      await tester.pumpApp(
        ZamAsyncButton(label: 'Save', onPressed: () => completer.future),
      );

      await tester.tap(find.text('Save'));
      await tester.pump();

      await tester.pumpApp(const SizedBox.shrink());
      completer.complete();
      await tester.pump();

      expect(tester.takeException(), isNull);
    });

    testWidgets('keeps callback-less buttons disabled', (tester) async {
      await tester.pumpApp(const ZamAsyncButton(label: 'No-op'));

      final button = tester.widget<ShadButton>(find.byType(ShadButton));
      expect(button.enabled, isFalse);
      expect(button.onPressed, isNull);
    });

    testWidgets('requires button content', (tester) async {
      expect(ZamAsyncButton.new, throwsA(isA<AssertionError>()));
    });

    testWidgets('passes style to the inner ZamButton', (tester) async {
      const style = ZamButtonStyle(radius: BorderRadius.zero);

      await tester.pumpApp(
        ZamAsyncButton(label: 'Save', style: style, onPressed: () async {}),
      );

      expect(tester.widget<ZamButton>(find.byType(ZamButton)).style, style);
    });
  });

  group('ZamButtonSize deprecated aliases', () {
    testWidgets('sm still renders the small height', (tester) async {
      await tester.pumpApp(
        const Column(
          children: [
            ZamButton(
              label: 'Small',
              onPressed: _noop,
              // The alias must keep rendering until it is removed.
              // ignore: deprecated_member_use_from_same_package
              size: ZamButtonSize.sm,
            ),
          ],
        ),
      );

      final sizes = testTheme.sizes;
      expect(
        tester.getSize(find.byType(ShadButton)).height,
        sizes.buttonSmallHeight,
      );
    });
  });
}

void _noop() {}
