part of '../tokens.dart';

/// Motion tokens combining durations and curves for standard UI transitions.
class ZamMotionTokens {
  /// Creates a configurable [ZamMotionTokens] set.
  const ZamMotionTokens({
    this.toastDefault = const Duration(seconds: 4),
    this.progressToast = const Duration(seconds: 10),
    this.shimmer = const Duration(milliseconds: 1500),
  });

  /// Default toast display duration (4s).
  final Duration toastDefault;

  /// Progress toast display duration (10s).
  final Duration progressToast;

  /// Skeleton shimmer animation loop duration (1500ms).
  final Duration shimmer;

  /// Standard motion token pair (medium2 duration + standard curve).
  ZamAnimationToken get standard => (
    duration: ZamDurationToken.medium2.duration,
    curve: ZamCurveToken.standard.curve,
  );

  /// Emphasized decelerated motion token pair (medium4 duration + emphasized decelerated curve).
  ZamAnimationToken get emphasizedDecelerated => (
    duration: ZamDurationToken.medium4.duration,
    curve: ZamCurveToken.emphasizedDecelerated.curve,
  );

  /// Emphasized accelerated motion token pair (short4 duration + emphasized accelerated curve).
  ZamAnimationToken get emphasizedAccelerated => (
    duration: ZamDurationToken.short4.duration,
    curve: ZamCurveToken.emphasizedAccelerated.curve,
  );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZamMotionTokens &&
          other.toastDefault == toastDefault &&
          other.progressToast == progressToast &&
          other.shimmer == shimmer;

  @override
  int get hashCode => Object.hashAll([toastDefault, progressToast, shimmer]);
}
