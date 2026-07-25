import 'package:flutter/widgets.dart';
import 'package:zam_ui/zam_ui.dart';

const infoIcon = IconData(0xe88e, fontFamily: 'MaterialIcons');
const successIcon = IconData(0xe876, fontFamily: 'MaterialIcons');
const warningIcon = IconData(0xe002, fontFamily: 'MaterialIcons');
const errorIcon = IconData(0xe000, fontFamily: 'MaterialIcons');
const backIcon = IconData(0xe5c4, fontFamily: 'MaterialIcons');
const chevronRightIcon = IconData(0xe5cc, fontFamily: 'MaterialIcons');

const exampleIcons = ZamIconSet(
  info: infoIcon,
  success: successIcon,
  warning: warningIcon,
  error: errorIcon,
  back: backIcon,
  chevronRight: chevronRightIcon,
);

class WellnessPreset implements ZamPreset {
  const WellnessPreset();

  @override
  String get name => 'Healpen-style wellness';

  @override
  ZamThemeData get light => ZamThemeData(
        colors: ZamColorTokens.fromSeed(primary: const Color(0xFF80CBC4)),
        typography: const ZamTypographyTokens(
          fontFamily: 'DM Sans',
          monoFontFamily: 'JetBrains Mono',
        ),
        icons: exampleIcons,
      );

  @override
  ZamThemeData get dark => light;
}

class FitnessPreset implements ZamPreset {
  const FitnessPreset();

  @override
  String get name => 'Peakward-style fitness';

  @override
  ZamThemeData get light => ZamThemeData(
        colors: ZamColorTokens.fromSeed(primary: const Color(0xFF06B6D4)),
        typography: const ZamTypographyTokens(
          fontFamily: 'Inter',
          monoFontFamily: 'JetBrains Mono',
        ),
        icons: exampleIcons,
      );

  @override
  ZamThemeData get dark => light;
}

const wellnessPreset = WellnessPreset();
const fitnessPreset = FitnessPreset();
