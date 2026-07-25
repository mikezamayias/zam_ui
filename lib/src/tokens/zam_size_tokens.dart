part of '../tokens.dart';

/// Size tokens defining icon dimensions, touch targets, and layout constraints derived from [spacing].
class ZamSizeTokens {
  /// Creates a [ZamSizeTokens] set derived from [spacing].
  const ZamSizeTokens(this.spacing);

  /// Reference to underlying spacing tokens.
  final ZamSpacingTokens spacing;

  /// Small icon dimension (16px).
  double get iconSm => spacing.sixteen;

  /// Medium icon dimension (18px).
  double get iconMd => spacing.eighteen;

  /// Large icon dimension (20px).
  double get iconLg => spacing.twenty;

  /// Extra-large icon dimension (24px).
  double get iconXl => spacing.twentyFour;

  /// Hero icon dimension (32px).
  double get iconHero => spacing.thirtyTwo;

  /// Minimum accessible touch target dimension (44px).
  double get minTapTarget => spacing.fortyFour;

  /// Large button height (48px).
  double get buttonLargeHeight => spacing.fortyEight;

  /// Empty state icon container dimension (64px).
  double get emptyIconContainer => spacing.sixtyFour;

  /// Empty state message maximum width (240px).
  double get emptyMessageWidth => spacing.twoHundredForty;

  /// Dialog maximum width constraint (320px).
  double get dialogMaxWidth => spacing.threeHundredTwenty;

  /// Minimum width for dialog action buttons (96px).
  double get dialogActionMinWidth => spacing.ninetySix;

  /// Maximum line count for text previews.
  int get textPreviewLines => 1;

  /// Minimum tap target constraints (44x44px).
  BoxConstraints get minTapTargetConstraints => BoxConstraints(
        minHeight: minTapTarget,
        minWidth: minTapTarget,
      );

  /// Dialog layout constraints.
  BoxConstraints get dialogConstraints =>
      BoxConstraints(maxWidth: dialogMaxWidth);
}
