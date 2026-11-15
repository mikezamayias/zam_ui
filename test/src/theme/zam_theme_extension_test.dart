import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

class _GoldTokens extends ZamThemeExtension<_GoldTokens> {
  const _GoldTokens({required this.gold, required this.groups});

  final Color gold;
  final List<Color> groups;

  @override
  _GoldTokens copyWith({Color? gold, List<Color>? groups}) =>
      _GoldTokens(gold: gold ?? this.gold, groups: groups ?? this.groups);

  @override
  _GoldTokens lerp(_GoldTokens? other, double t) {
    if (other == null) return this;
    return _GoldTokens(
      gold: Color.lerp(gold, other.gold, t)!,
      groups: [
        for (var i = 0; i < groups.length; i++)
          Color.lerp(groups[i], other.groups[i], t)!,
      ],
    );
  }

  @override
  bool operator ==(Object other) =>
      other is _GoldTokens &&
      other.gold == gold &&
      listEquals(other.groups, groups);

  @override
  int get hashCode => Object.hash(gold, Object.hashAll(groups));
}

class _SpacingExtras extends ZamThemeExtension<_SpacingExtras> {
  const _SpacingExtras(this.gutter);

  final double gutter;

  @override
  _SpacingExtras copyWith({double? gutter}) =>
      _SpacingExtras(gutter ?? this.gutter);

  @override
  _SpacingExtras lerp(_SpacingExtras? other, double t) {
    if (other == null) return this;
    return _SpacingExtras(gutter + (other.gutter - gutter) * t);
  }

  @override
  bool operator ==(Object other) =>
      other is _SpacingExtras && other.gutter == gutter;

  @override
  int get hashCode => gutter.hashCode;
}

void main() {
  const lightGold = _GoldTokens(
    gold: Color(0xFFB8860B),
    groups: [Color(0xFF000000), Color(0xFF202020)],
  );
  const darkGold = _GoldTokens(
    gold: Color(0xFFFFD700),
    groups: [Color(0xFF808080), Color(0xFFFFFFFF)],
  );
  const gutter = _SpacingExtras(24);

  group('ZamThemeData extensions', () {
    test('defaults to none', () {
      expect(testTheme.extensions, isEmpty);
      expect(testTheme.extension<_GoldTokens>(), isNull);
    });

    test('looks an extension up by its type', () {
      final theme = testTheme.copyWith(extensions: [lightGold, gutter]);

      expect(theme.extension<_GoldTokens>(), same(lightGold));
      expect(theme.extension<_SpacingExtras>(), same(gutter));
      expect(
        theme.extensions.keys,
        unorderedEquals([_GoldTokens, _SpacingExtras]),
      );
    });

    test('returns null for a type the theme does not carry', () {
      final theme = testTheme.copyWith(extensions: [gutter]);

      expect(theme.extension<_GoldTokens>(), isNull);
    });

    test('is unmodifiable', () {
      final theme = testTheme.copyWith(extensions: [gutter]);

      expect(
        () => theme.extensions[_GoldTokens] = lightGold,
        throwsUnsupportedError,
      );
    });

    test('asserts on two extensions of one type', () {
      expect(
        () => testTheme.copyWith(extensions: [lightGold, darkGold]),
        throwsAssertionError,
      );
    });

    test('copyWith keeps extensions when none are passed', () {
      final theme = testTheme.copyWith(extensions: [lightGold, gutter]);
      final copy = theme.copyWith(oled: true);

      expect(copy.extension<_GoldTokens>(), same(lightGold));
      expect(copy.extension<_SpacingExtras>(), same(gutter));
    });

    test('copyWith replaces the whole set of extensions', () {
      final theme = testTheme.copyWith(extensions: [lightGold, gutter]);
      final copy = theme.copyWith(extensions: [darkGold]);

      expect(copy.extension<_GoldTokens>(), same(darkGold));
      expect(copy.extension<_SpacingExtras>(), isNull);
    });

    test('equality compares extensions by value, in any order', () {
      final a = testTheme.copyWith(extensions: [lightGold, gutter]);
      final b = testTheme.copyWith(
        extensions: [
          const _SpacingExtras(24),
          lightGold.copyWith(groups: [...lightGold.groups]),
        ],
      );

      expect(a, b);
      expect(a.hashCode, b.hashCode);
      expect(a, isNot(testTheme.copyWith(extensions: [darkGold, gutter])));
      expect(a, isNot(testTheme.copyWith(extensions: [lightGold])));
      expect(a, isNot(testTheme));
    });
  });

  group('ZamThemeExtension', () {
    test('type defaults to the extension class', () {
      expect(lightGold.type, _GoldTokens);
    });

    test('copyWith replaces only the given fields', () {
      final copy = lightGold.copyWith(gold: darkGold.gold);

      expect(copy.gold, darkGold.gold);
      expect(copy.groups, lightGold.groups);
    });

    test('lerp interpolates every token', () {
      expect(lightGold.lerp(darkGold, 0), lightGold);
      expect(lightGold.lerp(darkGold, 1), darkGold);
      final mid = lightGold.lerp(darkGold, 0.5);
      expect(mid.gold, Color.lerp(lightGold.gold, darkGold.gold, 0.5));
      expect(
        mid.groups.last,
        Color.lerp(lightGold.groups.last, darkGold.groups.last, 0.5),
      );
    });

    test('lerp to a theme that lacks the extension keeps this one', () {
      final dark = testTheme.copyWith(extensions: [gutter]);

      expect(
        lightGold.lerp(dark.extension<_GoldTokens>(), 0.5),
        same(lightGold),
      );
    });
  });

  group('ZamApp extensions', () {
    final lightTheme = testTheme.copyWith(extensions: [lightGold]);
    final darkTheme = testTheme.copyWith(extensions: [darkGold]);

    Widget app(ZamThemeMode mode, void Function(_GoldTokens?) onBuild) =>
        ZamApp(
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: mode,
          home: Builder(
            builder: (context) {
              onBuild(context.zamExtension<_GoldTokens>());
              return const SizedBox();
            },
          ),
        );

    for (final (mode, expected) in [
      (ZamThemeMode.light, lightGold),
      (ZamThemeMode.dark, darkGold),
    ]) {
      testWidgets('$mode scopes the matching extension', (tester) async {
        _GoldTokens? scoped;
        await tester.pumpWidget(app(mode, (tokens) => scoped = tokens));

        expect(scoped, same(expected));
      });
    }

    testWidgets('dependents rebuild with the new extension when the '
        'brightness changes', (tester) async {
      _GoldTokens? scoped;
      await tester.pumpWidget(
        app(ZamThemeMode.light, (tokens) => scoped = tokens),
      );
      expect(scoped, same(lightGold));

      await tester.pumpWidget(
        app(ZamThemeMode.dark, (tokens) => scoped = tokens),
      );
      await tester.pumpAndSettle();
      expect(scoped, same(darkGold));
    });

    testWidgets('returns null when the scoped theme lacks the extension', (
      tester,
    ) async {
      _GoldTokens? scoped = lightGold;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            scoped = context.zamExtension<_GoldTokens>();
            return const SizedBox();
          },
        ),
      );

      expect(scoped, isNull);
    });
  });
}
