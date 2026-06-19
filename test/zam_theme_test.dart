import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/zam_ui.dart';

void main() {
  const primary = Color(0xFF80CBC4);
  const icons = ZamIconSet(
    info: IconData(0xe88e, fontFamily: 'TestIcons'),
    success: IconData(0xe876, fontFamily: 'TestIcons'),
    warning: IconData(0xe002, fontFamily: 'TestIcons'),
    error: IconData(0xe000, fontFamily: 'TestIcons'),
    back: IconData(0xe5c4, fontFamily: 'TestIcons'),
    chevronRight: IconData(0xe5cc, fontFamily: 'TestIcons'),
  );

  test('creates configurable color tokens from a seed color', () {
    final colors = ZamColorTokens.fromSeed(primary: primary);

    expect(colors.primary, primary);
    expect(colors.light.background, const Color(0xFFFAF9F7));
    expect(colors.dark.background, const Color(0xFF09090B));
    expect(colors.oled.background, const Color(0xFF000000));
    expect(
      colors.forBrightness(Brightness.light).card,
      const Color(0xFFFFFFFF),
    );
    expect(colors.forBrightness(Brightness.dark).card, const Color(0xFF1A1A1C));
  });

  test('builds shadcn theme data from configured tokens', () {
    final theme = ZamThemeData(
      colors: ZamColorTokens.fromSeed(primary: primary),
      typography: const ZamTypographyTokens(
        fontFamily: 'Test Sans',
        monoFontFamily: 'Test Mono',
      ),
      icons: icons,
    );

    final light = theme.toShadThemeData(Brightness.light);
    final dark = theme.toShadThemeData(Brightness.dark, isOled: true);

    expect(light.colorScheme.primary, primary);
    expect(light.colorScheme.background, theme.colors.light.background);
    expect(dark.colorScheme.background, theme.colors.oled.background);
    expect(light.brightness, Brightness.light);
    expect(dark.brightness, Brightness.dark);
  });

  test('interpolates OKLCH colors for continuous scales', () {
    final warm = ZamOklchColor.scale(-1);
    final neutral = ZamOklchColor.scale(0);
    final cool = ZamOklchColor.scale(1);

    expect(warm, isNot(neutral));
    expect(cool, isNot(neutral));
    expect(ZamOklchColor.gradient, hasLength(5));
  });

  testWidgets('provides theme data through ZamTheme context extensions', (
    tester,
  ) async {
    final theme = ZamThemeData(
      colors: ZamColorTokens.fromSeed(primary: primary),
      typography: const ZamTypographyTokens(fontFamily: 'Test Sans'),
      icons: icons,
    );

    await tester.pumpWidget(
      ZamTheme(
        data: theme,
        child: ShadApp(
          theme: theme.toShadThemeData(Brightness.light),
          home: Builder(
            builder: (context) {
              return Text(
                context.zamTypography.fontFamily,
                style: context.zamTypography.body(context),
              );
            },
          ),
        ),
      ),
    );

    expect(find.text('Test Sans'), findsOneWidget);
  });

  testWidgets('ZamApp wires ZamTheme and ShadApp theme data', (tester) async {
    final theme = ZamThemeData(
      colors: ZamColorTokens.fromSeed(primary: primary),
      typography: const ZamTypographyTokens(fontFamily: 'Test Sans'),
      icons: icons,
    );

    await tester.pumpWidget(
      ZamApp(
        theme: theme,
        home: Builder(
          builder: (context) {
            return Text(
              context.zamTypography.fontFamily,
              style: context.zamTypography.body(context),
            );
          },
        ),
      ),
    );

    final shadTheme = tester.widget<ShadApp>(find.byType(ShadApp));

    expect(find.text('Test Sans'), findsOneWidget);
    expect(shadTheme.theme!.colorScheme.primary, primary);
  });
}
