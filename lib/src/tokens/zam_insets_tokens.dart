part of '../tokens.dart';

class ZamInsetsTokens {
  const ZamInsetsTokens(this.spacing);

  final ZamSpacingTokens spacing;

  EdgeInsets get zero => EdgeInsets.zero;
  EdgeInsets get screen => EdgeInsets.fromLTRB(
        spacing.sixteen,
        spacing.twelve,
        spacing.sixteen,
        spacing.sixteen,
      );
  EdgeInsets get screenHeader => EdgeInsets.fromLTRB(
        spacing.sixteen,
        spacing.sixteen,
        spacing.sixteen,
        spacing.ten,
      );
  EdgeInsets get card => EdgeInsets.all(spacing.fourteen);
  EdgeInsets get compactCard => EdgeInsets.all(spacing.twelve);
  EdgeInsets get denseCard => EdgeInsets.all(spacing.eight);
  EdgeInsets get tile => EdgeInsets.all(spacing.twelve);
  EdgeInsets get smallTile => EdgeInsets.all(spacing.ten);
  EdgeInsets get dialogInset => EdgeInsets.symmetric(
        horizontal: spacing.twentyFour,
        vertical: spacing.twentyFour,
      );
  EdgeInsets get dialog => EdgeInsets.all(spacing.twenty);
  EdgeInsets get toast => EdgeInsets.symmetric(
        horizontal: spacing.twelve,
        vertical: spacing.eight,
      );
  EdgeInsets get buttonCompact => EdgeInsets.symmetric(
        horizontal: spacing.twelve,
        vertical: spacing.eight,
      );
  EdgeInsets get buttonLarge => EdgeInsets.symmetric(
        horizontal: spacing.twentyFour,
        vertical: spacing.fourteen,
      );
  EdgeInsets get bottomActionBar => EdgeInsets.symmetric(
        horizontal: spacing.sixteen,
        vertical: spacing.ten,
      );

  EdgeInsets all(double token) => EdgeInsets.all(token);
  EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}
