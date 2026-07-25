part of '../utils.dart';

/// Helper utilities for color manipulation and contrast calculations.
abstract final class ZamColorUtils {
  /// Pure black color constant (`0xFF000000`).
  static const black = Color(0xFF000000);

  /// Pure white color constant (`0xFFFFFFFF`).
  static const white = Color(0xFFFFFFFF);

  /// Fully transparent color constant (`0x00000000`).
  static const transparent = Color(0x00000000);

  /// Tokenized modal and sheet backdrop barrier overlay color (`0xCC000000`).
  static const barrier = Color(0xCC000000);

  /// Returns either black or white based on luminance contrast against [color].
  static Color readableOn(Color color) {
    return color.computeLuminance() > 0.5 ? black : white;
  }

  /// Linearly interpolates between [base] color and [overlay] by [amount].
  static Color mix(Color base, Color overlay, double amount) {
    final t = amount.clamp(0, 1).toDouble();
    return Color.fromARGB(
      _lerp(_channel(base.a), _channel(overlay.a), t),
      _lerp(_channel(base.r), _channel(overlay.r), t),
      _lerp(_channel(base.g), _channel(overlay.g), t),
      _lerp(_channel(base.b), _channel(overlay.b), t),
    );
  }

  static int _channel(double value) {
    return (value * 255).round().clamp(0, 255);
  }

  static int _lerp(int a, int b, double t) => (a + (b - a) * t).round();
}
