// Adapted from Flutter's cupertino/text_selection.dart.
//
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../text.dart';

// Paints the iOS handle: a ball with a bar below it that slightly overlaps it.
class _ZamIosHandlePainter extends CustomPainter {
  const _ZamIosHandlePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    const halfBarWidth = 1.0;
    final paint = Paint()..color = color;
    final ball = Rect.fromCircle(
      center: const Offset(_kIosHandleRadius, _kIosHandleRadius),
      radius: _kIosHandleRadius,
    );
    final bar = Rect.fromPoints(
      const Offset(
        _kIosHandleRadius - halfBarWidth,
        2 * _kIosHandleRadius - _kIosHandleOverlap,
      ),
      Offset(_kIosHandleRadius + halfBarWidth, size.height),
    );
    canvas.drawPath(
      Path()
        ..addOval(ball)
        ..addRect(bar),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ZamIosHandlePainter oldDelegate) =>
      color != oldDelegate.color;
}
