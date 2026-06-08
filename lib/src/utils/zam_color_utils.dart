part of '../utils.dart';

abstract final class ZamColorUtils {
  static const black = Color(0xFF000000);
  static const white = Color(0xFFFFFFFF);
  static const transparent = Color(0x00000000);

  static Color readableOn(Color color) {
    return color.computeLuminance() > 0.5 ? black : white;
  }

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
