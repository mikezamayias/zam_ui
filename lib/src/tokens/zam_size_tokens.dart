part of '../tokens.dart';

/// Size tokens defining icon dimensions, touch targets, and layout constraints derived from [spacing].
class ZamSizeTokens {
  /// Creates a [ZamSizeTokens] set derived from [spacing].
  const ZamSizeTokens(this.spacing);

  /// Reference to underlying spacing tokens.
  final ZamSpacingTokens spacing;

  /// Small icon dimension (16px).
  double get iconSm => spacing.md;

  /// Medium icon dimension (18px).
  double get iconMd => spacing(4.5);

  /// Large icon dimension (20px).
  double get iconLg => spacing(5);

  /// Extra-large icon dimension (24px).
  double get iconXl => spacing.lg;

  /// Hero icon dimension (32px).
  double get iconHero => spacing.xl;

  /// Minimum accessible touch target dimension (44px), the iOS and WCAG
  /// minimum. It stays fixed when the spacing step changes.
  double get minTapTarget => 44;

  /// Android's minimum touch target dimension (48px), for controls that
  /// must meet both platforms' guidelines. It stays fixed when the spacing
  /// step changes.
  double get androidMinTapTarget => 48;

  /// Small button height, kept at [minTapTarget].
  double get buttonSmallHeight => minTapTarget;

  /// Medium button height (48px).
  double get buttonMediumHeight => spacing(12);

  /// Large button height (56px).
  double get buttonLargeHeight => spacing(14);

  /// Empty state icon container dimension (64px).
  double get emptyIconContainer => spacing(16);

  /// Empty state message maximum width (240px).
  double get emptyMessageWidth => spacing(60);

  /// Dialog maximum width constraint (320px).
  double get dialogMaxWidth => spacing(80);

  /// Minimum width for dialog action buttons (96px).
  double get dialogActionMinWidth => spacing(24);

  /// Maximum line count for text previews.
  int get textPreviewLines => 1;

  /// Minimum tap target constraints (44x44px).
  BoxConstraints get minTapTargetConstraints =>
      BoxConstraints(minHeight: minTapTarget, minWidth: minTapTarget);

  /// Dialog layout constraints.
  BoxConstraints get dialogConstraints =>
      BoxConstraints(maxWidth: dialogMaxWidth);
}
