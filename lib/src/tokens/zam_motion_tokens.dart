part of '../tokens.dart';

class ZamMotionTokens {
  const ZamMotionTokens({
    this.reducedMotion = const Duration(milliseconds: 1),
    this.toastDefault = const Duration(seconds: 4),
    this.progressToast = const Duration(seconds: 10),
    this.shimmer = const Duration(milliseconds: 1500),
  });

  final Duration reducedMotion;
  final Duration toastDefault;
  final Duration progressToast;
  final Duration shimmer;

  ZamAnimationToken get standard => (
        duration: ZamDurationToken.medium2.duration,
        curve: ZamCurveToken.standard.curve,
      );
  ZamAnimationToken get emphasizedDecelerated => (
        duration: ZamDurationToken.medium4.duration,
        curve: ZamCurveToken.emphasizedDecelerated.curve,
      );
  ZamAnimationToken get emphasizedAccelerated => (
        duration: ZamDurationToken.short4.duration,
        curve: ZamCurveToken.emphasizedAccelerated.curve,
      );
}
