part of '../tokens.dart';

class ZamSizeTokens {
  const ZamSizeTokens(this.spacing);

  final ZamSpacingTokens spacing;

  double get iconSm => spacing.sixteen;
  double get iconMd => spacing.eighteen;
  double get iconLg => spacing.twenty;
  double get iconXl => spacing.twentyFour;
  double get iconHero => spacing.thirtyTwo;
  double get minTapTarget => spacing.fortyFour;
  double get buttonLargeHeight => spacing.fortyEight;
  double get emptyIconContainer => spacing.sixtyFour;
  double get emptyMessageWidth => spacing.twoHundredForty;
  double get dialogMaxWidth => spacing.threeHundredTwenty;
  double get dialogActionMinWidth => spacing.ninetySix;
  int get textPreviewLines => 1;

  BoxConstraints get minTapTargetConstraints => BoxConstraints(
        minHeight: minTapTarget,
        minWidth: minTapTarget,
      );
  BoxConstraints get dialogConstraints =>
      BoxConstraints(maxWidth: dialogMaxWidth);
}
