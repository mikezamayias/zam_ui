part of '../components.dart';

class _ZamSlidingGradientTransform extends GradientTransform {
  const _ZamSlidingGradientTransform(this.percent);

  final double percent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * percent, 0, 0);
  }
}
