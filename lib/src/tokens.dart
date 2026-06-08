import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/src/utils.dart';

enum ZamToastVariant { success, error, info, warning, progress }

class ZamIconSet {
  const ZamIconSet({
    required this.info,
    required this.success,
    required this.warning,
    required this.error,
    required this.back,
    required this.chevronRight,
  });

  final IconData info;
  final IconData success;
  final IconData warning;
  final IconData error;
  final IconData back;
  final IconData chevronRight;
}

class ZamSurfaceColors {
  const ZamSurfaceColors({
    required this.background,
    required this.foreground,
    required this.card,
    required this.muted,
    required this.mutedForeground,
    required this.border,
    required this.input,
    required this.destructive,
  });

  final Color background;
  final Color foreground;
  final Color card;
  final Color muted;
  final Color mutedForeground;
  final Color border;
  final Color input;
  final Color destructive;
}

class ZamColorTokens {
  const ZamColorTokens({
    required this.primary,
    required this.light,
    required this.dark,
    required this.oled,
    this.black = ZamColorUtils.black,
    this.white = ZamColorUtils.white,
    this.transparent = ZamColorUtils.transparent,
  });

  factory ZamColorTokens.fromSeed({
    required Color primary,
    Color lightBackground = const Color(0xFFFAF9F7),
    Color darkBackground = const Color(0xFF09090B),
    Color oledBackground = const Color(0xFF000000),
    Color lightCard = const Color(0xFFFFFFFF),
    Color darkCard = const Color(0xFF1A1A1C),
    Color oledCard = const Color(0xFF0A0A0A),
    Color lightMuted = const Color(0xFFF0EEEA),
    Color darkMuted = const Color(0xFF27272A),
    Color lightMutedForeground = const Color(0xFF73706A),
    Color darkMutedForeground = const Color(0xFFA1A1AA),
    Color lightBorder = const Color(0xFFE4E0D9),
    Color darkBorder = const Color(0xFF27272A),
    Color lightDestructive = const Color(0xFFFF3B30),
    Color darkDestructive = const Color(0xFFD92D20),
  }) {
    return ZamColorTokens(
      primary: primary,
      light: ZamSurfaceColors(
        background: lightBackground,
        foreground: const Color(0xFF09090B),
        card: lightCard,
        muted: lightMuted,
        mutedForeground: lightMutedForeground,
        border: lightBorder,
        input: lightMuted,
        destructive: lightDestructive,
      ),
      dark: ZamSurfaceColors(
        background: darkBackground,
        foreground: ZamColorUtils.white,
        card: darkCard,
        muted: darkMuted,
        mutedForeground: darkMutedForeground,
        border: darkBorder,
        input: darkMuted,
        destructive: darkDestructive,
      ),
      oled: ZamSurfaceColors(
        background: oledBackground,
        foreground: ZamColorUtils.white,
        card: oledCard,
        muted: darkMuted,
        mutedForeground: darkMutedForeground,
        border: darkBorder,
        input: darkMuted,
        destructive: darkDestructive,
      ),
    );
  }

  final Color primary;
  final ZamSurfaceColors light;
  final ZamSurfaceColors dark;
  final ZamSurfaceColors oled;
  final Color black;
  final Color white;
  final Color transparent;

  ZamSurfaceColors forBrightness(
    Brightness brightness, {
    bool isOled = false,
  }) {
    if (brightness == Brightness.light) return light;
    return isOled ? oled : dark;
  }
}

class ZamSpacingTokens {
  const ZamSpacingTokens({
    this.zero = 0,
    this.one = 1,
    this.two = 2,
    this.three = 3,
    this.four = 4,
    this.six = 6,
    this.eight = 8,
    this.ten = 10,
    this.eleven = 11,
    this.twelve = 12,
    this.thirteen = 13,
    this.fourteen = 14,
    this.sixteen = 16,
    this.eighteen = 18,
    this.twenty = 20,
    this.twentyTwo = 22,
    this.twentyFour = 24,
    this.twentySix = 26,
    this.twentyEight = 28,
    this.thirtyTwo = 32,
    this.thirtyFour = 34,
    this.thirtyEight = 38,
    this.forty = 40,
    this.fortyFour = 44,
    this.fortySix = 46,
    this.fortyEight = 48,
    this.fiftySix = 56,
    this.sixtyFour = 64,
    this.eighty = 80,
    this.eightyEight = 88,
    this.ninetySix = 96,
    this.oneHundredTwentyEight = 128,
    this.oneHundredEighty = 180,
    this.twoHundredForty = 240,
    this.threeHundredTwenty = 320,
  });

  final double zero;
  final double one;
  final double two;
  final double three;
  final double four;
  final double six;
  final double eight;
  final double ten;
  final double eleven;
  final double twelve;
  final double thirteen;
  final double fourteen;
  final double sixteen;
  final double eighteen;
  final double twenty;
  final double twentyTwo;
  final double twentyFour;
  final double twentySix;
  final double twentyEight;
  final double thirtyTwo;
  final double thirtyFour;
  final double thirtyEight;
  final double forty;
  final double fortyFour;
  final double fortySix;
  final double fortyEight;
  final double fiftySix;
  final double sixtyFour;
  final double eighty;
  final double eightyEight;
  final double ninetySix;
  final double oneHundredTwentyEight;
  final double oneHundredEighty;
  final double twoHundredForty;
  final double threeHundredTwenty;
}

class ZamInsetsTokens {
  const ZamInsetsTokens(this.spacing);

  final ZamSpacingTokens spacing;

  EdgeInsets get zero => EdgeInsets.zero;
  EdgeInsets get screen => EdgeInsets.fromLTRB(
        spacing.sixteen,
        spacing.twelve,
        spacing.sixteen,
        spacing.sixteen,
      );
  EdgeInsets get screenHeader => EdgeInsets.fromLTRB(
        spacing.sixteen,
        spacing.sixteen,
        spacing.sixteen,
        spacing.ten,
      );
  EdgeInsets get card => EdgeInsets.all(spacing.fourteen);
  EdgeInsets get compactCard => EdgeInsets.all(spacing.twelve);
  EdgeInsets get denseCard => EdgeInsets.all(spacing.eight);
  EdgeInsets get tile => EdgeInsets.all(spacing.twelve);
  EdgeInsets get smallTile => EdgeInsets.all(spacing.ten);
  EdgeInsets get dialogInset => EdgeInsets.symmetric(
        horizontal: spacing.twentyFour,
        vertical: spacing.twentyFour,
      );
  EdgeInsets get dialog => EdgeInsets.all(spacing.twenty);
  EdgeInsets get toast => EdgeInsets.symmetric(
        horizontal: spacing.twelve,
        vertical: spacing.eight,
      );
  EdgeInsets get buttonCompact => EdgeInsets.symmetric(
        horizontal: spacing.twelve,
        vertical: spacing.eight,
      );
  EdgeInsets get buttonLarge => EdgeInsets.symmetric(
        horizontal: spacing.twentyFour,
        vertical: spacing.fourteen,
      );
  EdgeInsets get bottomActionBar => EdgeInsets.symmetric(
        horizontal: spacing.sixteen,
        vertical: spacing.ten,
      );

  EdgeInsets all(double token) => EdgeInsets.all(token);
  EdgeInsets symmetric({double horizontal = 0, double vertical = 0}) =>
      EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical);
  EdgeInsets only({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      EdgeInsets.only(left: left, top: top, right: right, bottom: bottom);
}

class ZamRadiusTokens {
  const ZamRadiusTokens({
    this.two = 2,
    this.four = 4,
    this.six = 6,
    this.eight = 8,
    this.ten = 10,
    this.twelve = 12,
    this.fourteen = 14,
    this.sixteen = 16,
    this.twenty = 20,
    this.twentyFour = 24,
    this.full = 128,
  });

  final double two;
  final double four;
  final double six;
  final double eight;
  final double ten;
  final double twelve;
  final double fourteen;
  final double sixteen;
  final double twenty;
  final double twentyFour;
  final double full;

  BorderRadius circular(double value) => BorderRadius.circular(value);
  BorderRadius get zero => BorderRadius.zero;
  BorderRadius get sm => BorderRadius.circular(six);
  BorderRadius get md => BorderRadius.circular(eight);
  BorderRadius get lg => BorderRadius.circular(twelve);
  BorderRadius get xl => BorderRadius.circular(sixteen);
  BorderRadius get dialog => BorderRadius.circular(twenty);
  BorderRadius get toast => BorderRadius.circular(twelve);
  BorderRadius get pill => BorderRadius.circular(full);
}

class ZamStrokeTokens {
  const ZamStrokeTokens({
    this.hairline = 1,
    this.progress = 2,
    this.focusRing = 3,
    this.selected = 3,
  });

  final double hairline;
  final double progress;
  final double focusRing;
  final double selected;

  BorderSide border(Color color) => BorderSide(color: color, width: hairline);
}

class ZamOpacityTokens {
  const ZamOpacityTokens({
    this.transparent = 0,
    this.pressed = 0.08,
    this.tint = 0.1,
    this.subtleTint = 0.12,
    this.borderTint = 0.28,
    this.faint = 0.3,
    this.disabled = 0.5,
    this.secondary = 0.6,
    this.iconEmphasis = 0.7,
    this.strong = 0.85,
    this.nearlyOpaque = 0.88,
    this.visible = 1,
  });

  final double transparent;
  final double pressed;
  final double tint;
  final double subtleTint;
  final double borderTint;
  final double faint;
  final double disabled;
  final double secondary;
  final double iconEmphasis;
  final double strong;
  final double nearlyOpaque;
  final double visible;

  Color apply(Color color, double token) => color.withValues(alpha: token);
}

class ZamSizeTokens {
  const ZamSizeTokens(this.spacing);

  final ZamSpacingTokens spacing;

  double get iconSm => spacing.sixteen;
  double get iconMd => spacing.eighteen;
  double get iconLg => spacing.twenty;
  double get iconXl => spacing.twentyFour;
  double get iconHero => spacing.thirtyTwo;
  double get minTapTarget => spacing.fortyFour;
  double get buttonLargeHeight => spacing.fortyEight;
  double get emptyIconContainer => spacing.sixtyFour;
  double get emptyMessageWidth => spacing.twoHundredForty;
  double get dialogMaxWidth => spacing.threeHundredTwenty;
  double get dialogActionMinWidth => spacing.ninetySix;
  int get textPreviewLines => 1;

  BoxConstraints get minTapTargetConstraints => BoxConstraints(
        minHeight: minTapTarget,
        minWidth: minTapTarget,
      );
  BoxConstraints get dialogConstraints =>
      BoxConstraints(maxWidth: dialogMaxWidth);
}

class ZamShadowTokens {
  const ZamShadowTokens();

  List<BoxShadow> card(Brightness brightness) => brightness == Brightness.dark
      ? const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 22,
            spreadRadius: -8,
            color: Color.fromRGBO(0, 0, 0, 0.36),
          ),
        ]
      : const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 22,
            spreadRadius: -10,
            color: Color.fromRGBO(30, 26, 20, 0.08),
          ),
        ];

  List<BoxShadow> nav(Brightness brightness) => brightness == Brightness.dark
      ? const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 30,
            spreadRadius: -10,
            color: Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ]
      : const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 30,
            spreadRadius: -12,
            color: Color.fromRGBO(30, 26, 20, 0.14),
          ),
        ];
}

enum ZamDurationToken {
  short1(Duration(milliseconds: 50)),
  short2(Duration(milliseconds: 100)),
  short3(Duration(milliseconds: 150)),
  short4(Duration(milliseconds: 200)),
  medium1(Duration(milliseconds: 250)),
  medium2(Duration(milliseconds: 300)),
  medium3(Duration(milliseconds: 350)),
  medium4(Duration(milliseconds: 400)),
  long1(Duration(milliseconds: 450)),
  long2(Duration(milliseconds: 500)),
  long3(Duration(milliseconds: 550)),
  long4(Duration(milliseconds: 600));

  const ZamDurationToken(this.duration);
  final Duration duration;
}

enum ZamCurveToken {
  emphasized(Curves.easeInOutCubicEmphasized),
  emphasizedDecelerated(Cubic(0.05, 0.7, 0.1, 1)),
  emphasizedAccelerated(Cubic(0.3, 0, 0.8, 0.15)),
  standard(Cubic(0.2, 0, 0, 1)),
  standardDecelerated(Cubic(0, 0, 0, 1)),
  standardAccelerated(Cubic(0.3, 0, 1, 1));

  const ZamCurveToken(this.curve);
  final Curve curve;
}

typedef ZamAnimationToken = ({Duration duration, Curve curve});

class ZamMotionTokens {
  const ZamMotionTokens({
    this.reducedMotion = const Duration(milliseconds: 1),
    this.toastDefault = const Duration(seconds: 4),
    this.progressToast = const Duration(seconds: 10),
    this.shimmer = const Duration(milliseconds: 1500),
  });

  final Duration reducedMotion;
  final Duration toastDefault;
  final Duration progressToast;
  final Duration shimmer;

  ZamAnimationToken get standard => (
        duration: ZamDurationToken.medium2.duration,
        curve: ZamCurveToken.standard.curve,
      );
  ZamAnimationToken get emphasizedDecelerated => (
        duration: ZamDurationToken.medium4.duration,
        curve: ZamCurveToken.emphasizedDecelerated.curve,
      );
  ZamAnimationToken get emphasizedAccelerated => (
        duration: ZamDurationToken.short4.duration,
        curve: ZamCurveToken.emphasizedAccelerated.curve,
      );
}

class ZamTypographyTokens {
  const ZamTypographyTokens({
    required this.fontFamily,
    this.monoFontFamily = 'monospace',
  });

  final String fontFamily;
  final String monoFontFamily;

  double get displaySize => 28;
  double get screenTitleSize => 24;
  double get emptyTitleSize => 20;
  double get titleSize => 18;
  double get bodySize => 14;
  double get bodyLargeSize => 16;
  double get bodySmallSize => 13;
  double get labelSize => 12;
  double get captionSize => 11;
  double get monoLabelSize => 10;
  double get bodyLineHeight => 1.5;
  double get inputLineHeight => 1.58;

  FontWeight get regular => FontWeight.w400;
  FontWeight get medium => FontWeight.w500;
  FontWeight get semibold => FontWeight.w600;
  FontWeight get bold => FontWeight.w700;

  TextStyle display(BuildContext context, {Color? color}) =>
      _base(context).h1.copyWith(
            fontFamily: fontFamily,
            fontSize: displaySize,
            fontWeight: bold,
            letterSpacing: 0,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle screenTitle(BuildContext context, {Color? color}) =>
      _base(context).h2.copyWith(
            fontFamily: fontFamily,
            fontSize: screenTitleSize,
            fontWeight: bold,
            letterSpacing: 0,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle emptyTitle(BuildContext context, {Color? color}) =>
      _base(context).h3.copyWith(
            fontFamily: fontFamily,
            fontSize: emptyTitleSize,
            fontWeight: semibold,
            letterSpacing: 0,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle title(BuildContext context, {Color? color}) =>
      _base(context).large.copyWith(
            fontFamily: fontFamily,
            fontSize: titleSize,
            fontWeight: semibold,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle body(BuildContext context, {Color? color}) =>
      _base(context).p.copyWith(
            fontFamily: fontFamily,
            fontSize: bodySize,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle bodyLarge(BuildContext context, {Color? color}) =>
      _base(context).p.copyWith(
            fontFamily: fontFamily,
            fontSize: bodyLargeSize,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle bodySmall(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
            fontFamily: fontFamily,
            fontSize: bodySmallSize,
            color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
          );

  TextStyle label(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
            fontFamily: fontFamily,
            fontSize: labelSize,
            fontWeight: semibold,
            color: color ?? ShadTheme.of(context).colorScheme.foreground,
          );

  TextStyle caption(BuildContext context, {Color? color}) =>
      _base(context).small.copyWith(
            fontFamily: fontFamily,
            fontSize: captionSize,
            color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
          );

  TextStyle monoCaption(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: monoFontFamily,
        fontSize: captionSize,
        color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
      );

  TextStyle monoCaps(BuildContext context, {Color? color}) => TextStyle(
        fontFamily: monoFontFamily,
        fontSize: monoLabelSize,
        fontWeight: semibold,
        letterSpacing: 0,
        color: color ?? ShadTheme.of(context).colorScheme.mutedForeground,
      );

  ShadTextTheme toShadTextTheme() => ShadTextTheme(family: fontFamily);

  ShadTextTheme _base(BuildContext context) => ShadTheme.of(context).textTheme;
}

class ZamToastStyle {
  const ZamToastStyle({
    required this.variant,
    required this.background,
    required this.border,
    required this.foreground,
    required this.subtleForeground,
    required this.icon,
    required this.iconForeground,
    required this.shadowColor,
  });

  final ZamToastVariant variant;
  final Color background;
  final Color border;
  final Color foreground;
  final Color subtleForeground;
  final IconData icon;
  final Color iconForeground;
  final Color shadowColor;
}

class ZamThemeData {
  ZamThemeData({
    required this.colors,
    required this.typography,
    required this.icons,
    this.spacing = const ZamSpacingTokens(),
    this.radius = const ZamRadiusTokens(),
    this.strokes = const ZamStrokeTokens(),
    this.opacities = const ZamOpacityTokens(),
    this.shadows = const ZamShadowTokens(),
    this.motion = const ZamMotionTokens(),
  })  : insets = ZamInsetsTokens(spacing),
        sizes = ZamSizeTokens(spacing),
        assert(
          typography.fontFamily.isNotEmpty,
          'fontFamily must not be empty.',
        );

  final ZamColorTokens colors;
  final ZamTypographyTokens typography;
  final ZamIconSet icons;
  final ZamSpacingTokens spacing;
  final ZamInsetsTokens insets;
  final ZamSizeTokens sizes;
  final ZamRadiusTokens radius;
  final ZamStrokeTokens strokes;
  final ZamOpacityTokens opacities;
  final ZamShadowTokens shadows;
  final ZamMotionTokens motion;

  ShadThemeData toShadThemeData(
    Brightness brightness, {
    bool isOled = false,
  }) {
    final tone = colors.forBrightness(brightness, isOled: isOled);
    final primaryForeground = ZamColorUtils.readableOn(colors.primary);
    final secondary = ZamColorUtils.mix(
      colors.primary,
      brightness == Brightness.dark ? colors.black : colors.white,
      brightness == Brightness.dark ? 0.7 : 0.85,
    );
    final destructiveForeground = ZamColorUtils.readableOn(tone.destructive);

    return ShadThemeData(
      brightness: brightness,
      radius: radius.lg,
      textTheme: typography.toShadTextTheme(),
      colorScheme: ShadColorScheme(
        background: tone.background,
        foreground: tone.foreground,
        card: tone.card,
        cardForeground: tone.foreground,
        popover: tone.card,
        popoverForeground: tone.foreground,
        primary: colors.primary,
        primaryForeground: primaryForeground,
        secondary: secondary,
        secondaryForeground: ZamColorUtils.readableOn(secondary),
        muted: tone.muted,
        mutedForeground: tone.mutedForeground,
        accent: colors.primary,
        accentForeground: primaryForeground,
        destructive: tone.destructive,
        destructiveForeground: destructiveForeground,
        border: tone.border,
        input: tone.input,
        ring: colors.primary,
        selection: colors.primary.withValues(alpha: opacities.faint),
      ),
    );
  }

  ZamToastStyle toastStyle(Brightness brightness, ZamToastVariant variant) {
    final shadTheme = toShadThemeData(brightness);
    final scheme = shadTheme.colorScheme;
    final baseColor = switch (variant) {
      ZamToastVariant.success => scheme.accent,
      ZamToastVariant.error => scheme.destructive,
      ZamToastVariant.info => scheme.primary,
      ZamToastVariant.warning => scheme.secondary,
      ZamToastVariant.progress => scheme.muted,
    };
    final background = scheme.background.blend(baseColor, opacities.subtleTint);
    final border = scheme.border.blend(baseColor, opacities.borderTint);
    final foreground = ZamColorUtils.readableOn(background);
    final subtleForeground = Color.alphaBlend(
      foreground.withValues(alpha: opacities.subtleTint),
      scheme.foreground.withValues(alpha: opacities.nearlyOpaque),
    );
    final icon = switch (variant) {
      ZamToastVariant.success => icons.success,
      ZamToastVariant.error => icons.error,
      ZamToastVariant.info => icons.info,
      ZamToastVariant.warning => icons.warning,
      ZamToastVariant.progress => icons.info,
    };

    return ZamToastStyle(
      variant: variant,
      background: background,
      border: border,
      foreground: foreground,
      subtleForeground: subtleForeground,
      icon: icon,
      iconForeground: ZamColorUtils.readableOn(background),
      shadowColor: baseColor.withValues(alpha: opacities.borderTint),
    );
  }
}

class ZamTheme extends InheritedWidget {
  const ZamTheme({
    required this.data,
    required super.child,
    super.key,
  });

  final ZamThemeData data;

  static ZamThemeData of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<ZamTheme>();
    if (scope == null) {
      throw FlutterError('No ZamTheme found in the widget tree.');
    }
    return scope.data;
  }

  static ZamThemeData? maybeOf(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<ZamTheme>()?.data;
  }

  @override
  bool updateShouldNotify(ZamTheme oldWidget) => data != oldWidget.data;
}

extension ZamThemeContext on BuildContext {
  ZamThemeData get zam => ZamTheme.of(this);
  ZamColorTokens get zamColors => zam.colors;
  ZamTypographyTokens get zamTypography => zam.typography;
  ZamIconSet get zamIcons => zam.icons;
}
