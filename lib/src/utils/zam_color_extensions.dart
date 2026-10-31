part of '../utils.dart';

/// Extension methods on Flutter [Color] for blending and contrast resolution.
extension ZamColorExtensions on Color {
  /// Blends an [overlay] color with specified [opacity] on top of this color.
  Color blend(Color overlay, double opacity) {
    return Color.alphaBlend(overlay.withValues(alpha: opacity), this);
  }

  /// Returns the contrasting foreground color (black or white) for readability.
  Color get contrastColor => ZamColorUtils.readableOn(this);
}
