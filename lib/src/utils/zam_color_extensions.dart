part of '../utils.dart';

extension ZamColorExtensions on Color {
  Color blend(Color overlay, double opacity) {
    return Color.alphaBlend(overlay.withValues(alpha: opacity), this);
  }

  Color get contrastColor => ZamColorUtils.readableOn(this);
}
