part of '../tokens.dart';

/// Insets tokens providing semantic [EdgeInsets] configurations derived from [spacing].
class ZamInsetsTokens {
  /// Creates a [ZamInsetsTokens] set derived from [spacing].
  const ZamInsetsTokens(this.spacing);

  /// Reference to underlying spacing tokens.
  final ZamSpacingTokens spacing;

  /// Zero padding (`EdgeInsets.zero`).
  EdgeInsets get zero => EdgeInsets.zero;

  /// Standard screen content padding.
  EdgeInsets get screen => EdgeInsets.fromLTRB(
        spacing.sixteen,
        spacing.twelve,
        spacing.sixteen,
        spacing.sixteen,
      );

  /// Standard screen header padding.
  EdgeInsets get screenHeader => EdgeInsets.fromLTRB(
        spacing.sixteen,
        spacing.sixteen,
        spacing.sixteen,
        spacing.ten,
      );

  /// Standard card padding.
  EdgeInsets get card => EdgeInsets.all(spacing.fourteen);

  /// Compact card padding.
  EdgeInsets get compactCard => EdgeInsets.all(spacing.twelve);

  /// Dense card padding.
  EdgeInsets get denseCard => EdgeInsets.all(spacing.eight);

  /// Standard list tile padding.
  EdgeInsets get tile => EdgeInsets.all(spacing.twelve);

  /// Small list tile padding.
  EdgeInsets get smallTile => EdgeInsets.all(spacing.ten);

  /// Dialog margin inset padding.
  EdgeInsets get dialogInset => EdgeInsets.symmetric(
        horizontal: spacing.twentyFour,
        vertical: spacing.twentyFour,
      );

  /// Dialog content padding.
  EdgeInsets get dialog => EdgeInsets.all(spacing.twenty);

  /// Toast notification padding.
  EdgeInsets get toast => EdgeInsets.symmetric(
        horizontal: spacing.twelve,
        vertical: spacing.eight,
      );

  /// Compact button padding.
  EdgeInsets get buttonCompact => EdgeInsets.symmetric(
        horizontal: spacing.twelve,
        vertical: spacing.eight,
      );

  /// Large button padding.
  EdgeInsets get buttonLarge => EdgeInsets.symmetric(
        horizontal: spacing.twentyFour,
        vertical: spacing.fourteen,
      );

  /// Bottom action bar padding.
  EdgeInsets get bottomActionBar => EdgeInsets.symmetric(
        horizontal: spacing.sixteen,
        vertical: spacing.ten,
      );

  /// Returns [EdgeInsets.all] using a tokenized value.
  EdgeInsets all(double token) => EdgeInsets.all(token);

  /// Returns symmetric [EdgeInsets].
  EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);

  /// Returns directional [EdgeInsets.only].
  EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}
