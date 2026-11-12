part of '../controls.dart';

/// Paints the still spinner that [ZamSpinner] shows under reduced motion.
class _ZamStaticSpinnerPainter extends CustomPainter {
  const _ZamStaticSpinnerPainter({
    required this.color,
    required this.trackColor,
    required this.strokeWidth,
  });

  final Color color;
  final Color trackColor;
  final double strokeWidth;

  /// How much of the circle the arc covers, matching shad's spinner.
  static const double _sweep = math.pi * 0.6;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final arcRect = rect.deflate(strokeWidth / 2);

    canvas
      ..drawCircle(
        rect.center,
        math.min(arcRect.width, arcRect.height) / 2,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeWidth = strokeWidth
          ..color = trackColor,
      )
      ..drawArc(
        arcRect,
        -math.pi / 2,
        _sweep,
        false,
        Paint()
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round
          ..strokeWidth = strokeWidth
          ..color = color,
      );
  }

  @override
  bool shouldRepaint(_ZamStaticSpinnerPainter oldDelegate) =>
      oldDelegate.color != color ||
      oldDelegate.trackColor != trackColor ||
      oldDelegate.strokeWidth != strokeWidth;
}
