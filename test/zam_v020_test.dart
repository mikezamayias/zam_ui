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

  // -- ZamThemeData.copyWith --

  test('copyWith preserves unchanged fields', () {
    final copy = theme.copyWith();

    expect(copy.colors, same(theme.colors));
    expect(copy.typography, same(theme.typography));
    expect(copy.icons, same(theme.icons));
    expect(copy.spacing, same(theme.spacing));
    expect(copy.radius, same(theme.radius));
    expect(copy.strokes, same(theme.strokes));
    expect(copy.opacities, same(theme.opacities));
    expect(copy.shadows, same(theme.shadows));
    expect(copy.motion, same(theme.motion));
  });

  test('copyWith replaces specified fields', () {
    final newColors = ZamColorTokens.fromSeed(
      primary: const Color(0xFF80CBC4),
    );
    final copy = theme.copyWith(colors: newColors);

    expect(copy.colors, same(newColors));
    expect(copy.colors.primary, const Color(0xFF80CBC4));
    expect(copy.typography, same(theme.typography));
  });

  test('copyWith recomputes derived insets and sizes', () {
    const newSpacing = ZamSpacingTokens(sixteen: 20);
    final copy = theme.copyWith(spacing: newSpacing);

    expect(copy.spacing.sixteen, 20);
    expect(copy.insets.screen.left, 20);
    expect(copy.sizes.iconSm, copy.spacing.sixteen);
  });

  // -- ZamDivider --

  testWidgets('renders horizontal divider with theme border color', (
    tester,
  ) async {
    await tester.pumpWidget(harness(const ZamDivider()));

    final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
    expect(sizedBox.height, theme.strokes.hairline);
    expect(sizedBox.width, double.infinity);
  });

  testWidgets('renders vertical divider', (tester) async {
    await tester.pumpWidget(
      harness(
        const SizedBox(
          height: 100,
          child: Row(
            children: [
              Text('A'),
              ZamDivider.vertical(),
              Text('B'),
            ],
          ),
        ),
      ),
    );

    expect(find.byType(ZamDivider), findsOneWidget);
  });

  // -- ZamListTile --

  testWidgets('renders title and subtitle', (tester) async {
    await tester.pumpWidget(
      harness(
        const ZamListTile(
          title: 'Settings',
          subtitle: 'Manage your preferences',
        ),
      ),
    );

    expect(find.text('Settings'), findsOneWidget);
    expect(find.text('Manage your preferences'), findsOneWidget);
  });

  testWidgets('renders leading and trailing widgets', (tester) async {
    await tester.pumpWidget(
      harness(
        const ZamListTile(
          title: 'Profile',
          leading: Icon(IconData(0xe7fd, fontFamily: 'TestIcons')),
          trailing: Text('→'),
        ),
      ),
    );

    expect(find.byType(Icon), findsOneWidget);
    expect(find.text('→'), findsOneWidget);
  });

  testWidgets('fires onTap callback', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      harness(
        ZamListTile(
          title: 'Tappable',
          semanticLabel: 'Tappable tile',
          onTap: () => tapped = true,
        ),
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
    await tester.pumpWidget(
      harness(
        const Column(
          children: [
            ZamListTile(title: 'Item 1', showDivider: true),
            ZamListTile(title: 'Item 2'),
          ],
        ),
      ),
    );

    expect(find.byType(ZamDivider), findsOneWidget);
  });

  // -- ZamFormField --

  testWidgets('renders label and child', (tester) async {
    await tester.pumpWidget(
      harness(
        const ZamFormField(
          label: 'Email',
          child: ZamInput(),
        ),
      ),
    );

    expect(find.text('Email'), findsOneWidget);
    expect(find.byType(ZamInput), findsOneWidget);
  });

  testWidgets('shows required indicator when isRequired is true', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        const ZamFormField(
          label: 'Password',
          isRequired: true,
          child: ZamInput(),
        ),
      ),
    );

    expect(find.text('Password'), findsOneWidget);
    expect(find.text('*'), findsOneWidget);
  });

  testWidgets('shows description when no error', (tester) async {
    await tester.pumpWidget(
      harness(
        const ZamFormField(
          label: 'Username',
          description: 'Choose a unique username.',
          child: ZamInput(),
        ),
      ),
    );

    expect(find.text('Choose a unique username.'), findsOneWidget);
  });

  testWidgets('shows error and hides description when error present', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        const ZamFormField(
          label: 'Email',
          description: 'We will never share your email.',
          error: 'Invalid email address.',
          child: ZamInput(),
        ),
      ),
    );

    expect(find.text('Invalid email address.'), findsOneWidget);
    expect(find.text('We will never share your email.'), findsNothing);
  });

  testWidgets('hides required indicator when isRequired is false', (
    tester,
  ) async {
    await tester.pumpWidget(
      harness(
        const ZamFormField(
          label: 'Notes',
          child: ZamInput(),
        ),
      ),
    );

    expect(find.text('*'), findsNothing);
  });
}
