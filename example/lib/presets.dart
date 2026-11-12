import 'package:flutter/widgets.dart';
import 'package:zam_ui/zam_ui.dart';

// The example ships no icon font, so the icons are text glyphs. An app would
// use its own icon package here.

/// Info icon data.
const infoIcon = IconData(0x2139);

/// Success icon data.
const successIcon = IconData(0x2713);

/// Warning icon data.
const warningIcon = IconData(0x26A0);

/// Error icon data.
const errorIcon = IconData(0x2715);

/// Back icon data.
const backIcon = IconData(0x2039);

/// Chevron right icon data.
const chevronRightIcon = IconData(0x203A);

/// Example icon set mapping.
const exampleIcons = ZamIconSet(
  info: infoIcon,
  success: successIcon,
  warning: warningIcon,
  error: errorIcon,
  back: backIcon,
  chevronRight: chevronRightIcon,
);

/// Wellness brand preset implementation.
class WellnessPreset implements ZamPreset {
  /// Creates a [WellnessPreset].
  const WellnessPreset();

  @override
  String get name => 'Wellness';

  @override
  ZamThemeData get light => ZamThemeData(
    colors: ZamColorTokens.fromSeed(primary: const Color(0xFF5FA88E)),
    typography: const ZamTypographyTokens(
      fontFamily: 'DM Sans',
      monoFontFamily: 'JetBrains Mono',
    ),
    icons: exampleIcons,
  );

  @override
  ZamThemeData get dark => light;
}

/// Fitness brand preset implementation.
class FitnessPreset implements ZamPreset {
  /// Creates a [FitnessPreset].
  const FitnessPreset();

  @override
  String get name => 'Fitness';

  @override
  ZamThemeData get light => ZamThemeData(
    colors: ZamColorTokens.fromSeed(primary: const Color(0xFFE07A3F)),
    typography: const ZamTypographyTokens(
      fontFamily: 'Inter',
      monoFontFamily: 'JetBrains Mono',
    ),
    icons: exampleIcons,
  );

  @override
  ZamThemeData get dark => light;
}

/// Wellness preset singleton instance.
const wellnessPreset = WellnessPreset();

/// Fitness preset singleton instance.
const fitnessPreset = FitnessPreset();
