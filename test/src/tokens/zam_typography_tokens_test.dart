import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

const _fallback = ['Fallback Arabic', 'Fallback Emoji'];

const _withFallback = ZamTypographyTokens(
  fontFamily: 'Test Sans',
  fontFamilyFallback: _fallback,
);

void main() {
  group('ZamTypographyTokens.fontFamilyFallback', () {
    test('defaults to empty', () {
      expect(
        const ZamTypographyTokens(fontFamily: 'Test Sans').fontFamilyFallback,
        isEmpty,
      );
    });

    test('takes part in equality', () {
      const same = ZamTypographyTokens(
        fontFamily: 'Test Sans',
        fontFamilyFallback: ['Fallback Arabic', 'Fallback Emoji'],
      );

      expect(same, _withFallback);
      expect(same.hashCode, _withFallback.hashCode);
      expect(
        const ZamTypographyTokens(fontFamily: 'Test Sans'),
        isNot(_withFallback),
      );
    });

    test('toShadTextTheme applies the fallback to every style', () {
      final text = _withFallback.toShadTextTheme();

      expect(text.family, 'Test Sans');
      for (final style in [
        text.h1Large,
        text.h1,
        text.h2,
        text.h3,
        text.h4,
        text.p,
        text.blockquote,
        text.table,
        text.list,
        text.lead,
        text.large,
        text.small,
        text.muted,
      ]) {
        expect(style.fontFamilyFallback, _fallback);
        expect(style.fontFamily, 'Test Sans');
      }
    });

    test('toShadTextTheme without a fallback leaves it null', () {
      final text = const ZamTypographyTokens(
        fontFamily: 'Test Sans',
      ).toShadTextTheme();

      expect(text.p.fontFamilyFallback, isNull);
      expect(text.h1.fontFamilyFallback, isNull);
    });

    testWidgets('every style method applies the fallback', (tester) async {
      final theme = testTheme.copyWith(typography: _withFallback);
      late List<TextStyle> styles;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            styles = [
              _withFallback.display(context),
              _withFallback.screenTitle(context),
              _withFallback.emptyTitle(context),
              _withFallback.title(context),
              _withFallback.body(context),
              _withFallback.bodyLarge(context),
              _withFallback.bodySmall(context),
              _withFallback.label(context),
              _withFallback.caption(context),
              _withFallback.monoCaption(context),
              _withFallback.monoCaps(context),
            ];
            return const SizedBox();
          },
        ),
        theme: theme,
      );

      for (final style in styles) {
        expect(style.fontFamilyFallback, _fallback);
      }
    });

    testWidgets('style methods keep the base fallback when none is set', (
      tester,
    ) async {
      late TextStyle body;
      late TextStyle mono;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            body = testTheme.typography.body(context);
            mono = testTheme.typography.monoCaption(context);
            return const SizedBox();
          },
        ),
      );

      expect(body.fontFamilyFallback, isNull);
      expect(mono.fontFamilyFallback, isNull);
    });

    testWidgets('ZamApp gives unstyled text the fallback', (tester) async {
      await tester.pumpApp(
        const Text('plain'),
        theme: testTheme.copyWith(typography: _withFallback),
      );

      final style = DefaultTextStyle.of(tester.element(find.text('plain')))
          .style;
      expect(style.fontFamily, 'Test Sans');
      expect(style.fontFamilyFallback, _fallback);
    });
  });
}
