part of '../utils.dart';

/// Representation of a color in the OKLCH perceptually uniform color space.
class ZamOklchColor {
  /// Creates a [ZamOklchColor] with specified [lightness], [chroma], and [hue].
  const ZamOklchColor({
    required this.lightness,
    required this.chroma,
    required this.hue,
  });

  /// Default warm OKLCH color benchmark.
  static const warm = ZamOklchColor(
    lightness: 0.57,
    chroma: 0.110,
    hue: 40,
  );

  /// Default neutral OKLCH color benchmark.
  static const neutral = ZamOklchColor(
    lightness: 0.47,
    chroma: 0,
    hue: 250,
  );

  /// Default cool OKLCH color benchmark.
  static const cool = ZamOklchColor(
    lightness: 0.57,
    chroma: 0.080,
    hue: 160,
  );

  /// Perceptual lightness component (0.0 to 1.0).
  final double lightness;

  /// Perceptual chroma/saturation component.
  final double chroma;

  /// Hue angle in degrees (0 to 360).
  final double hue;

  /// Converts this OKLCH color into a standard sRGB Flutter [Color].
  Color toColor() {
    final hRad = hue * math.pi / 180;
    final a = chroma * math.cos(hRad);
    final b = chroma * math.sin(hRad);
    return _oklabToColor(lightness, a, b);
  }

  /// Interpolates a color along an OKLCH scale based on a normalized [-1, 1] [score].
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

  /// Returns a 5-step continuous color gradient from negative to positive OKLCH endpoints.
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
