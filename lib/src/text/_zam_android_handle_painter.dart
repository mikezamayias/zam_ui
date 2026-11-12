// Adapted from Flutter's material/text_selection.dart.
//
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../text.dart';

// Paints the Android teardrop: a circle with a square top-left quadrant, so
// that it points to the top left.
class _ZamAndroidHandlePainter extends CustomPainter {
  const _ZamAndroidHandlePainter(this.color);

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final paint = Paint()..color = color;
    canvas.drawPath(
      Path()
        ..addOval(
          Rect.fromCircle(center: Offset(radius, radius), radius: radius),
        )
        ..addRect(Rect.fromLTWH(0, 0, radius, radius)),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ZamAndroidHandlePainter oldDelegate) =>
      color != oldDelegate.color;
}
