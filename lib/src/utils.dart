import 'dart:math' as math;
import 'dart:ui';

extension ZamColorExtensions on Color {
  Color blend(Color overlay, double opacity) {
    return Color.alphaBlend(overlay.withValues(alpha: opacity), this);
  }

  Color get contrastColor => ZamColorUtils.readableOn(this);
}

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

class ZamOklchColor {
  const ZamOklchColor({
    required this.lightness,
    required this.chroma,
    required this.hue,
  });

  static const warm = ZamOklchColor(
    lightness: 0.57,
    chroma: 0.110,
    hue: 40,
  );

  static const neutral = ZamOklchColor(
    lightness: 0.47,
    chroma: 0,
    hue: 250,
  );

  static const cool = ZamOklchColor(
    lightness: 0.57,
    chroma: 0.080,
    hue: 160,
  );

  final double lightness;
  final double chroma;
  final double hue;

  Color toColor() {
    final hRad = hue * math.pi / 180;
    final a = chroma * math.cos(hRad);
    final b = chroma * math.sin(hRad);
    return _oklabToColor(lightness, a, b);
  }

  static Color scale(
    double score, {
    ZamOklchColor negative = warm,
    ZamOklchColor neutral = neutral,
    ZamOklchColor positive = cool,
  }) {
    final s = score.clamp(-1.0, 1.0);
    final t = (s + 1) / 2;
    if (t < 0.5) {
      return negative._lerpTo(neutral, t * 2).toColor();
    }
    return neutral._lerpTo(positive, (t - 0.5) * 2).toColor();
  }

  static List<Color> get gradient => [
        scale(-1),
        scale(-0.5),
        scale(0),
        scale(0.5),
        scale(1),
      ];

  ZamOklchColor _lerpTo(
    ZamOklchColor b,
    double t,
  ) {
    return ZamOklchColor(
      lightness: _lerpDouble(lightness, b.lightness, t),
      chroma: _lerpDouble(chroma, b.chroma, t),
      hue: _lerpHue(hue, b.hue, t),
    );
  }

  static double _lerpDouble(double a, double b, double t) => a + (b - a) * t;

  static double _lerpHue(double a, double b, double t) {
    var diff = b - a;
    if (diff > 180) diff -= 360;
    if (diff < -180) diff += 360;
    return ((a + diff * t) % 360 + 360) % 360;
  }

  static Color _oklabToColor(double l, double a, double b) {
    final lPrime = l + 0.3963377774 * a + 0.2158037573 * b;
    final mPrime = l - 0.1055613458 * a - 0.0638541728 * b;
    final sPrime = l - 0.0894841775 * a - 1.2914855480 * b;

    final l3 = lPrime * lPrime * lPrime;
    final m3 = mPrime * mPrime * mPrime;
    final s3 = sPrime * sPrime * sPrime;

    final r = 4.0767416621 * l3 - 3.3077115913 * m3 + 0.2309699292 * s3;
    final g = -1.2684380046 * l3 + 2.6097574011 * m3 - 0.3413193965 * s3;
    final bl = -0.0041960863 * l3 - 0.7034186147 * m3 + 1.7076147010 * s3;

    return Color.fromARGB(
      255,
      _linearToSrgb(r),
      _linearToSrgb(g),
      _linearToSrgb(bl),
    );
  }

  static int _linearToSrgb(double x) {
    final c =
        x <= 0.0031308 ? 12.92 * x : 1.055 * math.pow(x, 1.0 / 2.4) - 0.055;
    return (c.clamp(0.0, 1.0) * 255).round();
  }
}
