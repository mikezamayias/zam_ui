import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/zam_ui.dart';
import '../../helpers/helpers.dart';

void main() {
  group('ZamButton', () {
    testWidgets('renders button with label and responds to tap', (
      tester,
    ) async {
      var pressed = false;

      await tester.pumpApp(
        ZamButton(label: 'Continue', onPressed: () => pressed = true),
      );

      expect(find.text('Continue'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      expect(pressed, isTrue);
    });

    testWidgets('maps link buttons to the shad link variant', (tester) async {
      await tester.pumpApp(
        ZamButton.link(label: 'Learn more', onPressed: () {}),
      );

      final button = tester.widget<ShadButton>(find.byType(ShadButton));
      expect(button.variant, ShadButtonVariant.link);
    });

    testWidgets('keeps callback-less buttons disabled', (tester) async {
      await tester.pumpApp(const ZamButton(label: 'No-op', enabled: true));

      final button = tester.widget<ShadButton>(find.byType(ShadButton));
      expect(button.enabled, isFalse);
      expect(button.onPressed, isNull);
    });

    testWidgets('requires button content', (tester) async {
      expect(ZamButton.new, throwsA(isA<AssertionError>()));
    });
  });

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

      completer.complete();
      await tester.pump();

      button = tester.widget<ShadButton>(find.byType(ShadButton));
      expect(button.enabled, isTrue);
      expect(button.onPressed, isNotNull);
    });

    testWidgets('re-enables and rethrows when the future fails', (
      tester,
    ) async {
      final completer = Completer<void>();

      await tester.pumpApp(
        ZamAsyncButton(label: 'Save', onPressed: () => completer.future),
      );

      final onPressed = tester
          .widget<ZamButton>(find.byType(ZamButton))
          .onPressed! as Future<void> Function();
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
  });

  group('ZamIconButton', () {
    testWidgets('asserts semantic labels for interactive icon buttons', (
      tester,
    ) async {
      expect(
        () => ZamIconButton(icon: Icon(testTheme.icons.info), onPressed: () {}),
        throwsA(isA<AssertionError>()),
      );
    });
  });

  group('ZamSurface & Screen', () {
    testWidgets('renders themed surface inside screen', (tester) async {
      await tester.pumpApp(
        const ZamScreen(child: ZamSurface(child: Text('Dashboard Content'))),
      );

      expect(find.text('Dashboard Content'), findsOneWidget);
    });
  });

  group('ZamEmptyState', () {
    testWidgets('renders icon, title, and message', (tester) async {
      await tester.pumpApp(
        ZamEmptyState(
          icon: testTheme.icons.info,
          title: 'Nothing here',
          message: 'Add something to continue.',
        ),
      );

      expect(find.text('Nothing here'), findsOneWidget);
      expect(find.text('Add something to continue.'), findsOneWidget);
    });
  });

  group('ZamToast', () {
    testWidgets('renders toast content with configured icon roles', (
      tester,
    ) async {
      await tester.pumpApp(
        ZamToastContent(
          style: testTheme.toastStyle(
            Brightness.light,
            ZamToastVariant.success,
          ),
          title: 'Saved',
          description: const Text('Your changes were saved.'),
        ),
      );

      expect(find.text('Saved'), findsOneWidget);
      expect(find.text('Your changes were saved.'), findsOneWidget);
    });
  });

  group('ZamSkeleton', () {
    testWidgets('renders skeleton placeholders while loading', (tester) async {
      await tester.pumpApp(
        const ZamSkeleton(child: SizedBox(width: 80, height: 16)),
      );

      expect(find.byType(ZamSkeleton), findsOneWidget);
    });
  });

  group('ZamDivider', () {
    testWidgets('renders horizontal divider with theme border color', (
      tester,
    ) async {
      await tester.pumpApp(const ZamDivider());

      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, testTheme.strokes.hairline);
      expect(sizedBox.width, double.infinity);
    });

    testWidgets('renders vertical divider', (tester) async {
      await tester.pumpApp(
        const SizedBox(
          height: 100,
          child: Row(children: [Text('A'), ZamDivider.vertical(), Text('B')]),
        ),
      );

      expect(find.byType(ZamDivider), findsOneWidget);
    });
  });

  group('ZamListTile', () {
    testWidgets('renders title and subtitle', (tester) async {
      await tester.pumpApp(
        const ZamListTile(
          title: 'Settings',
          subtitle: 'Manage your preferences',
        ),
      );

      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Manage your preferences'), findsOneWidget);
    });

    testWidgets('renders leading and trailing widgets', (tester) async {
      await tester.pumpApp(
        const ZamListTile(
          title: 'Profile',
          leading: Icon(IconData(0xe7fd, fontFamily: 'TestIcons')),
          trailing: Text('→'),
        ),
      );

      expect(find.byType(Icon), findsOneWidget);
      expect(find.text('→'), findsOneWidget);
    });

    testWidgets('fires onTap callback', (tester) async {
      var tapped = false;

      await tester.pumpApp(
        ZamListTile(
          title: 'Tappable',
          semanticLabel: 'Tappable tile',
          onTap: () => tapped = true,
        ),
      );

      await tester.tap(find.text('Tappable'));
      expect(tapped, isTrue);
    });

    testWidgets('asserts semantic label for interactive list tiles', (
      tester,
    ) async {
      expect(
        () => ZamListTile(title: 'Bad', onTap: () {}),
        throwsA(isA<AssertionError>()),
      );
    });

    testWidgets('renders divider when showDivider is true', (tester) async {
      await tester.pumpApp(
        const Column(
          children: [
            ZamListTile(title: 'Item 1', showDivider: true),
            ZamListTile(title: 'Item 2'),
          ],
        ),
      );

      expect(find.byType(ZamDivider), findsOneWidget);
    });
  });

  group('ZamFormField', () {
    testWidgets('renders label and child', (tester) async {
      await tester.pumpApp(
        const ZamFormField(label: 'Email', child: ZamInput()),
      );

      expect(find.text('Email'), findsOneWidget);
      expect(find.byType(ZamInput), findsOneWidget);
    });

    testWidgets('shows required indicator when isRequired is true', (
      tester,
    ) async {
      await tester.pumpApp(
        const ZamFormField(
          label: 'Password',
          isRequired: true,
          child: ZamInput(),
        ),
      );

      expect(find.text('Password'), findsOneWidget);
      expect(find.text('*'), findsOneWidget);
    });

    testWidgets('shows description when no error', (tester) async {
      await tester.pumpApp(
        const ZamFormField(
          label: 'Username',
          description: 'Choose a unique username.',
          child: ZamInput(),
        ),
      );

      expect(find.text('Choose a unique username.'), findsOneWidget);
    });

    testWidgets('shows error and hides description when error present', (
      tester,
    ) async {
      await tester.pumpApp(
        const ZamFormField(
          label: 'Email',
          description: 'We will never share your email.',
          error: 'Invalid email address.',
          child: ZamInput(),
        ),
      );

      expect(find.text('Invalid email address.'), findsOneWidget);
      expect(find.text('We will never share your email.'), findsNothing);
    });

    testWidgets('hides required indicator when isRequired is false', (
      tester,
    ) async {
      await tester.pumpApp(
        const ZamFormField(label: 'Notes', child: ZamInput()),
      );

      expect(find.text('*'), findsNothing);
    });
  });
}
