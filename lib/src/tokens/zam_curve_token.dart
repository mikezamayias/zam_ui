part of '../tokens.dart';

/// Animation easing curve tokens.
enum ZamCurveToken {
  /// Emphasized cubic easing.
  emphasized(Curves.easeInOutCubicEmphasized),

  /// Emphasized decelerated easing.
  emphasizedDecelerated(Cubic(0.05, 0.7, 0.1, 1)),

  /// Emphasized accelerated easing.
  emphasizedAccelerated(Cubic(0.3, 0, 0.8, 0.15)),

  /// Standard cubic easing.
  standard(Cubic(0.2, 0, 0, 1)),

  /// Standard decelerated easing.
  standardDecelerated(Cubic(0, 0, 0, 1)),

  /// Standard accelerated easing.
  standardAccelerated(Cubic(0.3, 0, 1, 1));

  const ZamCurveToken(this.curve);

  /// Underlying [Curve] value.
  final Curve curve;
}
