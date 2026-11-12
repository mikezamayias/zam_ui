// These tests prove the transitional Material support, so they use the
// framework Material library and the deprecated ZamMaterial on purpose.
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/material.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ZamApp without ZamMaterial', () {
    testWidgets('installs no Material, Material theme or localizations', (
      tester,
    ) async {
      late BuildContext home;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          home: Builder(
            builder: (context) {
              home = context;
              return const SizedBox();
            },
          ),
        ),
      );

      expect(Material.maybeOf(home), isNull);
      expect(home.findAncestorWidgetOfExactType<Theme>(), isNull);
      expect(
        Localizations.of<MaterialLocalizations>(home, MaterialLocalizations),
        isNull,
      );
    });
  });

  group('ZamMaterial', () {
    testWidgets('keeps Material widgets working below ZamApp', (tester) async {
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          builder: (context, child) => ZamMaterial(child: child!),
          home: const Center(child: TextField()),
        ),
      );

      await tester.enterText(find.byType(TextField), 'Material');
      expect(tester.takeException(), isNull);
      expect(find.text('Material'), findsOneWidget);
    });

    testWidgets('derives the Material theme from the active theme', (
      tester,
    ) async {
      late ThemeData theme;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          themeMode: ZamThemeMode.dark,
          home: ZamMaterial(
            child: Builder(
              builder: (context) {
                theme = Theme.of(context);
                return const SizedBox();
              },
            ),
          ),
        ),
      );

      final scheme = testTheme.toShadThemeData(Brightness.dark).colorScheme;
      expect(theme.brightness, Brightness.dark);
      expect(theme.colorScheme.primary, scheme.primary);
      expect(theme.textTheme.bodyLarge!.fontFamily, 'Test Sans');
      expect(theme.textTheme.bodyLarge!.fontFamilyFallback, isNull);
    });

    testWidgets('applies the font family fallback to the Material text '
        'themes', (tester) async {
      late ThemeData theme;
      await tester.pumpWidget(
        ZamApp(
          theme: testTheme,
          themeMode: ZamThemeMode.light,
          home: Builder(
            builder: (context) {
              final shad = ShadTheme.of(context);
              return ShadTheme(
                data: shad.copyWith(
                  textTheme: shad.textTheme.apply(
                    fontFamilyFallback: const ['Fallback Sans'],
                  ),
                ),
                child: ZamMaterial(
                  child: Builder(
                    builder: (context) {
                      theme = Theme.of(context);
                      return const SizedBox();
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );

      expect(theme.textTheme.bodyLarge!.fontFamilyFallback, ['Fallback Sans']);
      expect(theme.textTheme.titleMedium!.fontFamilyFallback, [
        'Fallback Sans',
      ]);
      expect(theme.primaryTextTheme.bodyLarge!.fontFamilyFallback, [
        'Fallback Sans',
      ]);
    });
  });
}
