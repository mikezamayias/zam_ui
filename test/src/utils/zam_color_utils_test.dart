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

    test('picks the foreground with the higher contrast', () {
      // A light blue: black reaches 9.4:1, white only 2.2:1.
      expect(
        ZamColorUtils.readableOn(const Color(0xFF7FB2E5)),
        ZamColorUtils.black,
      );
      // A dark blue: white reaches 6.6:1, black only 3.2:1.
      expect(
        ZamColorUtils.readableOn(const Color(0xFF2F55BF)),
        ZamColorUtils.white,
      );
    });

    test('defines barrier color constant', () {
      expect(ZamColorUtils.barrier, const Color(0xCC000000));
    });
  });
}
