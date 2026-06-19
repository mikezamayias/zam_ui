import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/zam_ui.dart';

void main() {
  const icons = ZamIconSet(
    info: IconData(0xe88e, fontFamily: 'TestIcons'),
    success: IconData(0xe876, fontFamily: 'TestIcons'),
    warning: IconData(0xe002, fontFamily: 'TestIcons'),
    error: IconData(0xe000, fontFamily: 'TestIcons'),
    back: IconData(0xe5c4, fontFamily: 'TestIcons'),
    chevronRight: IconData(0xe5cc, fontFamily: 'TestIcons'),
  );

  late ZamThemeData theme;

  setUp(() {
    theme = ZamThemeData(
      colors: ZamColorTokens.fromSeed(primary: const Color(0xFF06B6D4)),
      typography: const ZamTypographyTokens(fontFamily: 'Test Sans'),
      icons: icons,
    );
  });

  Widget harness(Widget child) {
    return ZamTheme(
      data: theme,
      child: ShadApp(
        theme: theme.toShadThemeData(Brightness.light),
        home: child,
      ),
    );
  }

  testWidgets('renders themed surfaces, buttons, and empty states',
      (tester) async {
    var pressed = false;

    await tester.pumpWidget(
      harness(
        ZamScreen(
          child: ZamSurface(
            child: Column(
              children: [
                const ZamScreenHeader(title: 'Dashboard', subtitle: 'Today'),
                ZamEmptyState(
                  icon: icons.info,
                  title: 'Nothing here',
                  message: 'Add something to continue.',
                ),
                ZamButton(
                  label: 'Continue',
                  onPressed: () => pressed = true,
                ),
              ],
            ),
          ),
        ),
      ),
    );

    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Nothing here'), findsOneWidget);
    await tester.tap(find.text('Continue'));
    expect(pressed, isTrue);
  });

  testWidgets('maps link buttons to the shad link variant', (tester) async {
    await tester.pumpWidget(
      harness(
        ZamButton.link(
          label: 'Learn more',
          onPressed: () {},
        ),
      ),
    );

    final button = tester.widget<ShadButton>(find.byType(ShadButton));

    expect(button.variant, ShadButtonVariant.link);
  });

  testWidgets('keeps callback-less buttons disabled', (tester) async {
    await tester.pumpWidget(
      harness(
        const ZamButton(
          label: 'No-op',
          enabled: true,
        ),
      ),
    );

    final button = tester.widget<ShadButton>(find.byType(ShadButton));

    expect(button.enabled, isFalse);
    expect(button.onPressed, isNull);
  });

  testWidgets('requires button content', (tester) async {
    expect(
      ZamButton.new,
      throwsA(isA<AssertionError>()),
    );
  });

  testWidgets('asserts semantic labels for interactive icon buttons',
      (tester) async {
    expect(
      () => ZamIconButton(icon: Icon(icons.info), onPressed: () {}),
      throwsA(isA<AssertionError>()),
    );
  });

  testWidgets('renders toast content with configured icon roles',
      (tester) async {
    await tester.pumpWidget(
      harness(
        ZamToastContent(
          style: theme.toastStyle(Brightness.light, ZamToastVariant.success),
          title: 'Saved',
          description: const Text('Your changes were saved.'),
        ),
      ),
    );

    expect(find.text('Saved'), findsOneWidget);
    expect(find.text('Your changes were saved.'), findsOneWidget);
  });

  testWidgets('renders skeleton placeholders while loading', (tester) async {
    await tester.pumpWidget(
      harness(
        const ZamSkeleton(
          child: SizedBox(width: 80, height: 16),
        ),
      ),
    );

    expect(find.byType(ZamSkeleton), findsOneWidget);
  });
}
