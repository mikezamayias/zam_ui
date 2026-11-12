import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';
import 'overlay_test_support.dart';

void main() {
  group('ZamDialog on showZamDialog', () {
    testWidgets('showMessage closes with its button and does not blur', (
      tester,
    ) async {
      final host = OverlayHost(tester);
      await host.pump();

      var closed = false;
      unawaited(
        ZamDialog.showMessage(
          context: host.context,
          title: 'Heads up',
          message: 'Something happened.',
        ).then((_) => closed = true),
      );
      await tester.pumpAndSettle();

      expect(find.text('Heads up'), findsWidgets);
      expect(find.byType(BackdropFilter), findsNothing);
      final barrier = tester.widget<ModalBarrier>(
        find.byType(ModalBarrier).last,
      );
      expect(barrier.color, ZamColorUtils.barrier);

      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(closed, isTrue);
    });

    testWidgets('showConfirmation returns true or false', (tester) async {
      final host = OverlayHost(tester);
      await host.pump();

      bool? result;
      unawaited(
        ZamDialog.showConfirmation(
          context: host.context,
          title: 'Delete',
          message: 'This cannot be undone.',
          icon: testTheme.icons.warning,
          destructive: true,
        ).then((value) => result = value),
      );
      await tester.pumpAndSettle();
      expect(find.byIcon(testTheme.icons.warning), findsOneWidget);

      await tester.tap(find.text('Confirm'));
      await tester.pumpAndSettle();
      expect(result, isTrue);

      unawaited(
        ZamDialog.showConfirmation(
          context: host.context,
          title: 'Delete',
          message: 'This cannot be undone.',
        ).then((value) => result = value),
      );
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(result, isFalse);
    });

    testWidgets('showConfirmation ignores a barrier tap', (tester) async {
      final host = OverlayHost(tester);
      await host.pump();

      unawaited(
        ZamDialog.showConfirmation(
          context: host.context,
          title: 'Delete',
          message: 'This cannot be undone.',
        ),
      );
      await tester.pumpAndSettle();

      await tester.tapAt(const Offset(2, 2));
      await tester.pumpAndSettle();

      expect(find.text('Confirm'), findsOneWidget);
    });
  });
}
