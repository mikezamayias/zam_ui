import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';
import 'overlay_test_support.dart';

const _content = Key('toast-content');

/// Records what the app sends to the accessibility channel.
class _Announcements {
  _Announcements(WidgetTester tester) {
    tester.binding.defaultBinaryMessenger.setMockDecodedMessageHandler<dynamic>(
      SystemChannels.accessibility,
      (message) async {
        final map = message as Map<Object?, Object?>;
        if (map['type'] == 'announce') {
          final data = map['data']! as Map<Object?, Object?>;
          messages.add(data['message']! as String);
        }
        return null;
      },
    );
    addTearDown(
      () => tester.binding.defaultBinaryMessenger
          .setMockDecodedMessageHandler<dynamic>(
            SystemChannels.accessibility,
            null,
          ),
    );
  }

  final List<String> messages = [];
}

Future<BuildContext> _pump(WidgetTester tester) async {
  final host = OverlayHost(tester);
  await host.pump();
  return host.context;
}

void main() {
  group('ZamToast.show', () {
    testWidgets('announces the title and a text description', (tester) async {
      final announcements = _Announcements(tester);
      final context = await _pump(tester);

      ZamToast.show(
        context,
        title: 'Saved',
        description: const Text('Your changes were saved.'),
      );
      await tester.pump();

      expect(announcements.messages, ['Saved. Your changes were saved.']);
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('announces the title alone without a description', (
      tester,
    ) async {
      final announcements = _Announcements(tester);
      final context = await _pump(tester);

      ZamToast.show(context, title: 'Offline', variant: ZamToastVariant.error);
      await tester.pump();

      expect(announcements.messages, ['Offline']);
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('shows the content and hides it after the duration', (
      tester,
    ) async {
      final context = await _pump(tester);

      ZamToast.show(
        context,
        title: 'Saved',
        duration: const Duration(seconds: 2),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Saved'), findsOneWidget);

      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();
      expect(find.text('Saved'), findsNothing);
    });

    testWidgets('shows an action below the description', (tester) async {
      final context = await _pump(tester);

      ZamToast.show(
        context,
        title: 'Upload failed',
        description: const Text('Check your connection.'),
        action: const SizedBox(key: _content, width: 80, height: 32),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        tester.getRect(find.byKey(_content)).top,
        greaterThan(tester.getRect(find.text('Check your connection.')).bottom),
      );
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('puts the icon at the start in right-to-left', (tester) async {
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

      ZamToast.show(context, title: 'Saved');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final icon = tester.getRect(find.byType(Icon));
      final title = tester.getRect(find.text('Saved'));
      expect(icon.center.dx, greaterThan(title.center.dx));
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });
  });

  group('ZamToast.showCustom', () {
    testWidgets('draws the content with no kit padding or surface', (
      tester,
    ) async {
      final context = await _pump(tester);

      ZamToast.showCustom(
        context,
        content: const SizedBox(key: _content, width: 120, height: 40),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final toast = tester.widget<ShadToast>(find.byType(ShadToast));
      expect(toast.padding, EdgeInsets.zero);
      expect(toast.border, ShadBorder.none);
      expect(toast.radius, BorderRadius.zero);
      expect(toast.shadows, isEmpty);
      expect(toast.backgroundColor, const Color(0x00000000));
      expect(toast.closeIcon, isA<SizedBox>());
      expect(tester.getSize(find.byKey(_content)), const Size(120, 40));
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('centers the content horizontally above the safe area', (
      tester,
    ) async {
      final context = await _pump(tester);

      ZamToast.showCustom(
        context,
        content: const SizedBox(key: _content, width: 120, height: 40),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final rect = tester.getRect(find.byKey(_content));
      expect(rect.center.dx, 400);
      expect(rect.bottom, 600 - 16);
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('honors alignment, offset and constraints', (tester) async {
      final context = await _pump(tester);

      ZamToast.showCustom(
        context,
        content: const SizedBox(key: _content, width: 100, height: 40),
        alignment: Alignment.topCenter,
        offset: const Offset(10, 30),
        constraints: const BoxConstraints(maxWidth: 200),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final rect = tester.getRect(find.byKey(_content));
      expect(rect.top, 30);
      final toast = tester.widget<ShadToast>(find.byType(ShadToast));
      expect(toast.constraints, const BoxConstraints(maxWidth: 200));
      expect(toast.offset, const Offset(10, 30));
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('uses the theme duration unless one is given', (tester) async {
      final context = await _pump(tester);

      ZamToast.showCustom(context, content: const SizedBox());
      await tester.pump();
      expect(
        tester.widget<ShadToast>(find.byType(ShadToast)).displayDuration,
        testTheme.motion.toastDefault,
      );
      await tester.pumpAndSettle(const Duration(seconds: 6));

      ZamToast.showCustom(
        context,
        content: const SizedBox(),
        duration: const Duration(seconds: 1),
      );
      await tester.pump();
      expect(
        tester.widget<ShadToast>(find.byType(ShadToast)).displayDuration,
        const Duration(seconds: 1),
      );
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('gives unstyled text the app text style', (tester) async {
      final context = await _pump(tester);

      ZamToast.showCustom(context, content: const Text('plain'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      final style = DefaultTextStyle.of(tester.element(find.text('plain')));
      expect(style.style.fontFamily, 'Test Sans');
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('does not announce unless it is given a semantic label', (
      tester,
    ) async {
      final announcements = _Announcements(tester);
      final context = await _pump(tester);

      ZamToast.showCustom(context, content: const Text('Quiet'));
      await tester.pump();
      expect(announcements.messages, isEmpty);
      await tester.pumpAndSettle(const Duration(seconds: 6));

      ZamToast.showCustom(
        context,
        content: const Text('Loud'),
        semanticLabel: 'Loud and clear',
      );
      await tester.pump();
      expect(announcements.messages, ['Loud and clear']);
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('the content keeps its own semantics', (tester) async {
      final semantics = tester.ensureSemantics();
      final context = await _pump(tester);

      ZamToast.showCustom(
        context,
        content: Semantics(
          label: 'Retry upload',
          button: true,
          onTap: () {},
          child: const SizedBox(width: 100, height: 40),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(buttonsLabeled('Retry upload'), findsOneWidget);
      semantics.dispose();
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('hide removes the toast and completes after the exit', (
      tester,
    ) async {
      final context = await _pump(tester);
      ZamToast.showCustom(context, content: const Text('Bye'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Bye'), findsOneWidget);

      var done = false;
      unawaited(ZamToast.hide(context).then((_) => done = true));
      await tester.pumpAndSettle();

      expect(done, isTrue);
      expect(find.text('Bye'), findsNothing);
    });

    testWidgets('mirrors a directional layout in right-to-left', (
      tester,
    ) async {
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

      ZamToast.showCustom(
        context,
        constraints: const BoxConstraints.tightFor(width: 300),
        content: const Align(
          alignment: AlignmentDirectional.centerStart,
          child: SizedBox(key: _content, width: 50, height: 20),
        ),
      );
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      // The start side is on the right.
      expect(tester.getRect(find.byKey(_content)).center.dx, greaterThan(400));
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });
  });

  group('ZamToaster', () {
    testWidgets('gives its subtree a toast layer of its own', (tester) async {
      late BuildContext inner;
      await tester.pumpApp(
        ZamToaster(
          child: Builder(
            builder: (context) {
              inner = context;
              return const SizedBox();
            },
          ),
        ),
      );

      ZamToast.showCustom(inner, content: const Text('Inner'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(
        find.descendant(
          of: find.byType(ZamToaster),
          matching: find.text('Inner'),
        ),
        findsOneWidget,
      );
      expect(find.byType(ShadToast), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });

    testWidgets('keeps toasts working where the app builder drops the root '
        'toaster', (tester) async {
      late BuildContext inner;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          themeMode: ZamThemeMode.light,
          // Replaces the app, as a gate does, and brings its own toaster.
          builder: (context, child) => ZamToaster(
            child: Builder(
              builder: (context) {
                inner = context;
                return const SizedBox(key: _content);
              },
            ),
          ),
        ),
      );

      ZamToast.show(inner, title: 'Link failed');
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Link failed'), findsOneWidget);
      await tester.pumpAndSettle(const Duration(seconds: 6));
    });
  });
}
