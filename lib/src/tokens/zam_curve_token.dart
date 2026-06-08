part of '../tokens.dart';

enum ZamCurveToken {
  emphasized(Curves.easeInOutCubicEmphasized),
  emphasizedDecelerated(Cubic(0.05, 0.7, 0.1, 1)),
  emphasizedAccelerated(Cubic(0.3, 0, 0.8, 0.15)),
  standard(Cubic(0.2, 0, 0, 1)),
  standardDecelerated(Cubic(0, 0, 0, 1)),
  standardAccelerated(Cubic(0.3, 0, 1, 1));

  const ZamCurveToken(this.curve);
  final Curve curve;
}
