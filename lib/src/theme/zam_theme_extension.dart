part of '../theme.dart';

/// App-owned design tokens carried by a [ZamThemeData].
///
/// zam_ui models the tokens every app shares. An app with tokens of its own,
/// such as an extra accent or a set of category colors, subclasses this and
/// passes an instance to [ZamThemeData.new] as one of its `extensions`. The
/// tokens then live in the theme, so a light and a dark [ZamThemeData] each
/// carry their own values and widgets read the ones for the scoped theme:
///
/// ```dart
/// class BrandTokens extends ZamThemeExtension<BrandTokens> {
///   const BrandTokens({required this.gold});
///
///   final Color gold;
///
///   @override
///   BrandTokens copyWith({Color? gold}) =>
///       BrandTokens(gold: gold ?? this.gold);
///
///   @override
///   BrandTokens lerp(BrandTokens? other, double t) {
///     if (other == null) return this;
///     return BrandTokens(gold: Color.lerp(gold, other.gold, t)!);
///   }
///
///   @override
///   bool operator ==(Object other) =>
///       other is BrandTokens && other.gold == gold;
///
///   @override
///   int get hashCode => gold.hashCode;
/// }
///
/// final gold = context.zamExtension<BrandTokens>()?.gold;
/// ```
///
/// [ZamThemeData] compares its extensions with `==`, and [ZamTheme] notifies
/// dependents only when the theme changes, so a subclass overrides `==` and
/// [hashCode] to compare its tokens.
///
/// This mirrors Material's `ThemeExtension` without depending on Material.
abstract class ZamThemeExtension<T extends ZamThemeExtension<T>> {
  /// Lets subclasses declare const constructors.
  const ZamThemeExtension();

  /// The key [ZamThemeData.extensions] stores this extension under.
  ///
  /// Defaults to `T`, which [ZamThemeData.extension] looks up.
  Object get type => T;

  /// Creates a copy of this extension with the given fields replaced.
  ZamThemeExtension<T> copyWith();

  /// Linearly interpolates between this extension and [other] by [t].
  ///
  /// [t] of 0 gives this extension and 1 gives [other]. When [other] is null
  /// the implementation returns this extension.
  ZamThemeExtension<T> lerp(covariant ZamThemeExtension<T>? other, double t);
}
