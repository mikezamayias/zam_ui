import 'package:flutter/widgets.dart';
import 'package:zam_ui/zam_ui.dart';

/// Info icon data.
const infoIcon = IconData(0xe88e, fontFamily: 'MaterialIcons');

/// Success icon data.
const successIcon = IconData(0xe876, fontFamily: 'MaterialIcons');

/// Warning icon data.
const warningIcon = IconData(0xe002, fontFamily: 'MaterialIcons');

/// Error icon data.
const errorIcon = IconData(0xe000, fontFamily: 'MaterialIcons');

/// Back icon data.
const backIcon = IconData(0xe5c4, fontFamily: 'MaterialIcons');

/// Chevron right icon data.
const chevronRightIcon = IconData(0xe5cc, fontFamily: 'MaterialIcons');

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

/// Fitness brand preset implementation.
class FitnessPreset implements ZamPreset {
  /// Creates a [FitnessPreset].
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

/// Wellness preset singleton instance.
const wellnessPreset = WellnessPreset();

/// Fitness preset singleton instance.
const fitnessPreset = FitnessPreset();
