// The deprecated numeric names are the subject of one test here.
// ignore_for_file: deprecated_member_use_from_same_package
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

void main() {
  group('ZamSpacingTokens', () {
    for (final step in [4.0, 5.0, 2.5]) {
      test('named steps equal shad at step $step', () {
        final zam = ZamSpacingTokens(step: step);
        final shad = ShadSpacing(step: step);

        expect(zam.xs, shad.xs);
        expect(zam.sm, shad.sm);
        expect(zam.md, shad.md);
        expect(zam.lg, shad.lg);
        expect(zam.xl, shad.xl);
        expect(zam(3), shad(3));
        expect(zam(0.5), shad(0.5));
      });
    }

    test('deprecated numeric names keep their pixel values at step 4', () {
      const spacing = ZamSpacingTokens();
      final values = <String, (double, double)>{
        'zero': (spacing.zero, 0),
        'one': (spacing.one, 1),
        'two': (spacing.two, 2),
        'three': (spacing.three, 3),
        'four': (spacing.four, 4),
        'six': (spacing.six, 6),
        'eight': (spacing.eight, 8),
        'ten': (spacing.ten, 10),
        'eleven': (spacing.eleven, 11),
        'twelve': (spacing.twelve, 12),
        'thirteen': (spacing.thirteen, 13),
        'fourteen': (spacing.fourteen, 14),
        'sixteen': (spacing.sixteen, 16),
        'eighteen': (spacing.eighteen, 18),
        'twenty': (spacing.twenty, 20),
        'twentyTwo': (spacing.twentyTwo, 22),
        'twentyFour': (spacing.twentyFour, 24),
        'twentySix': (spacing.twentySix, 26),
        'twentyEight': (spacing.twentyEight, 28),
        'thirtyTwo': (spacing.thirtyTwo, 32),
        'thirtyFour': (spacing.thirtyFour, 34),
        'thirtyEight': (spacing.thirtyEight, 38),
        'forty': (spacing.forty, 40),
        'fortyFour': (spacing.fortyFour, 44),
        'fortySix': (spacing.fortySix, 46),
        'fortyEight': (spacing.fortyEight, 48),
        'fiftySix': (spacing.fiftySix, 56),
        'sixtyFour': (spacing.sixtyFour, 64),
        'eighty': (spacing.eighty, 80),
        'eightyEight': (spacing.eightyEight, 88),
        'ninetySix': (spacing.ninetySix, 96),
        'oneHundredTwentyEight': (spacing.oneHundredTwentyEight, 128),
        'oneHundredEighty': (spacing.oneHundredEighty, 180),
        'twoHundredForty': (spacing.twoHundredForty, 240),
        'threeHundredTwenty': (spacing.threeHundredTwenty, 320),
      };

      for (final entry in values.entries) {
        expect(entry.value.$1, entry.value.$2, reason: entry.key);
      }
    });

    test('toShadThemeData passes the step to shad', () {
      final theme = testTheme.copyWith(
        spacing: const ZamSpacingTokens(step: 5),
      );

      expect(theme.toShadThemeData(Brightness.light).spacing.step, 5);
    });

    test('changing the step scales insets and sizes', () {
      const base = ZamSpacingTokens();
      const doubled = ZamSpacingTokens(step: 8);

      expect(const ZamInsetsTokens(doubled).screen.left, 32);
      expect(const ZamInsetsTokens(base).screen.left, 16);
      expect(const ZamSizeTokens(doubled).iconSm, 32);
      expect(const ZamSizeTokens(base).iconSm, 16);
    });

    test('keeps the tap target at 44 at any step', () {
      for (final step in [2.0, 4.0, 8.0]) {
        final sizes = ZamSizeTokens(ZamSpacingTokens(step: step));
        expect(sizes.minTapTarget, 44);
        expect(sizes.buttonSmallHeight, 44);
      }
    });

    test('compares by step', () {
      final four = ZamSpacingTokens(step: [4.0].first);
      expect(const ZamSpacingTokens(), four);
      expect(const ZamSpacingTokens().hashCode, four.hashCode);
      expect(const ZamSpacingTokens(), isNot(const ZamSpacingTokens(step: 5)));
    });
  });
}
