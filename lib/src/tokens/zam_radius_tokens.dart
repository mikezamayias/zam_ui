part of '../tokens.dart';

/// Radius tokens defining corner radius scale values and semantic [BorderRadius] getters.
class ZamRadiusTokens {
  /// Creates a configurable [ZamRadiusTokens] scale.
  const ZamRadiusTokens({
    this.two = 2,
    this.four = 4,
    this.six = 6,
    this.eight = 8,
    this.ten = 10,
    this.twelve = 12,
    this.fourteen = 14,
    this.sixteen = 16,
    this.twenty = 20,
    this.twentyFour = 24,
    this.full = 128,
  });

  /// Radius 2px.
  final double two;

  /// Radius 4px.
  final double four;

  /// Radius 6px.
  final double six;

  /// Radius 8px.
  final double eight;

  /// Radius 10px.
  final double ten;

  /// Radius 12px.
  final double twelve;

  /// Radius 14px.
  final double fourteen;

  /// Radius 16px.
  final double sixteen;

  /// Radius 20px.
  final double twenty;

  /// Radius 24px.
  final double twentyFour;

  /// Full pill radius (128px).
  final double full;

  /// Creates a circular [BorderRadius] for a given [value].
  BorderRadius circular(double value) => BorderRadius.circular(value);

  /// Zero border radius.
  BorderRadius get zero => BorderRadius.zero;

  /// Small border radius (6px).
  BorderRadius get sm => BorderRadius.circular(six);

  /// Medium border radius (8px).
  BorderRadius get md => BorderRadius.circular(eight);

  /// Large border radius (12px).
  BorderRadius get lg => BorderRadius.circular(twelve);

  /// Extra-large border radius (16px).
  BorderRadius get xl => BorderRadius.circular(sixteen);

  /// Dialog corner radius (20px).
  BorderRadius get dialog => BorderRadius.circular(twenty);

  /// Toast notification corner radius (12px).
  BorderRadius get toast => BorderRadius.circular(twelve);

  /// Pill/capsule border radius (full).
  BorderRadius get pill => BorderRadius.circular(full);
}
