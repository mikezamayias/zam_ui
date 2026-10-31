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
    spacing.md,
    spacing(3),
    spacing.md,
    spacing.md,
  );

  /// Standard screen header padding.
  EdgeInsets get screenHeader => EdgeInsets.fromLTRB(
    spacing.md,
    spacing.md,
    spacing.md,
    spacing(2.5),
  );

  /// Standard card padding.
  EdgeInsets get card => EdgeInsets.all(spacing(3.5));

  /// Compact card padding.
  EdgeInsets get compactCard => EdgeInsets.all(spacing(3));

  /// Dense card padding.
  EdgeInsets get denseCard => EdgeInsets.all(spacing.sm);

  /// Standard list tile padding.
  EdgeInsets get tile => EdgeInsets.all(spacing(3));

  /// Small list tile padding.
  EdgeInsets get smallTile => EdgeInsets.all(spacing(2.5));

  /// Dialog margin inset padding.
  EdgeInsets get dialogInset => EdgeInsets.symmetric(
    horizontal: spacing.lg,
    vertical: spacing.lg,
  );

  /// Dialog content padding.
  EdgeInsets get dialog => EdgeInsets.all(spacing(5));

  /// Toast notification padding.
  EdgeInsets get toast =>
      EdgeInsets.symmetric(horizontal: spacing(3), vertical: spacing.sm);

  /// Compact button padding.
  EdgeInsets get buttonCompact =>
      EdgeInsets.symmetric(horizontal: spacing(3), vertical: spacing.sm);

  /// Large button padding.
  EdgeInsets get buttonLarge => EdgeInsets.symmetric(
    horizontal: spacing.lg,
    vertical: spacing(3.5),
  );

  /// Bottom action bar padding.
  EdgeInsets get bottomActionBar =>
      EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing(2.5));

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
  }) => EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}
