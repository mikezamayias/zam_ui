part of '../tokens.dart';

// The numeric names stay for one release as deprecated getters, which is
// deliberate even in a breaking version, so apps can migrate one call at a time.
// ignore_for_file: remove_deprecations_in_breaking_versions

/// Spacing scale, the same scale as shad's [ShadSpacing].
///
/// [ZamThemeData] passes it to shad, so one [step] size drives both.
/// Every padding, gap and size in zam_ui is a number of steps.
@immutable
class ZamSpacingTokens {
  /// Creates a scale whose unit step is [step] logical pixels.
  const ZamSpacingTokens({this.step = 4});

  /// The size of one step on the scale.
  final double step;

  /// [steps] steps, in logical pixels. `spacing(6)` is 24 by default.
  double call(double steps) => step * steps;

  /// One step, 4px by default.
  double get xs => call(1);

  /// Two steps, 8px by default.
  double get sm => call(2);

  /// Four steps, 16px by default.
  double get md => call(4);

  /// Six steps, 24px by default.
  double get lg => call(6);

  /// Eight steps, 32px by default.
  double get xl => call(8);

  /// This scale as shad's [ShadSpacing].
  ShadSpacing toShadSpacing() => ShadSpacing(step: step);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ZamSpacingTokens && other.step == step);

  @override
  int get hashCode => step.hashCode;

  /// 0px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get zero => call(0);

  /// 1px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get one => call(0.25);

  /// 2px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get two => call(0.5);

  /// 3px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get three => call(0.75);

  /// 4px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get four => call(1);

  /// 6px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get six => call(1.5);

  /// 8px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get eight => call(2);

  /// 10px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get ten => call(2.5);

  /// 11px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get eleven => call(2.75);

  /// 12px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get twelve => call(3);

  /// 13px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get thirteen => call(3.25);

  /// 14px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get fourteen => call(3.5);

  /// 16px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get sixteen => call(4);

  /// 18px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get eighteen => call(4.5);

  /// 20px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get twenty => call(5);

  /// 22px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get twentyTwo => call(5.5);

  /// 24px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get twentyFour => call(6);

  /// 26px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get twentySix => call(6.5);

  /// 28px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get twentyEight => call(7);

  /// 32px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get thirtyTwo => call(8);

  /// 34px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get thirtyFour => call(8.5);

  /// 38px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get thirtyEight => call(9.5);

  /// 40px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get forty => call(10);

  /// 44px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get fortyFour => call(11);

  /// 46px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get fortySix => call(11.5);

  /// 48px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get fortyEight => call(12);

  /// 56px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get fiftySix => call(14);

  /// 64px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get sixtyFour => call(16);

  /// 80px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get eighty => call(20);

  /// 88px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get eightyEight => call(22);

  /// 96px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get ninetySix => call(24);

  /// 128px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get oneHundredTwentyEight => call(32);

  /// 180px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get oneHundredEighty => call(45);

  /// 240px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get twoHundredForty => call(60);

  /// 320px by default.
  @Deprecated('Use spacing(n) or a named step; see the 0.3.0 changelog.')
  double get threeHundredTwenty => call(80);
}
