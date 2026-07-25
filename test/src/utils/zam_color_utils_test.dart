import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

void main() {
  group('ZamOklchColor', () {
    test('interpolates OKLCH colors for continuous scales', () {
      final warm = ZamOklchColor.scale(-1);
      final neutral = ZamOklchColor.scale(0);
      final cool = ZamOklchColor.scale(1);

      expect(warm, isNot(neutral));
      expect(cool, isNot(neutral));
      expect(ZamOklchColor.gradient, hasLength(5));
    });
  });

  group('ZamColorUtils', () {
    test('computes readable contrast color', () {
      final darkContrast = ZamColorUtils.readableOn(const Color(0xFFFFFFFF));
      final lightContrast = ZamColorUtils.readableOn(const Color(0xFF000000));

      expect(darkContrast, ZamColorUtils.black);
      expect(lightContrast, ZamColorUtils.white);
    });

    test('defines barrier color constant', () {
      expect(ZamColorUtils.barrier, const Color(0xCC000000));
    });
  });
}
