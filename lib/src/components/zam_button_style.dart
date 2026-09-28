part of '../components.dart';

/// Style overrides for a [ZamButton].
///
/// Every field left null keeps the variant's theme value.
@immutable
class ZamButtonStyle {
  /// Creates a [ZamButtonStyle].
  const ZamButtonStyle({
    this.backgroundColor,
    this.foregroundColor,
    this.pressedBackgroundColor,
    this.disabledBackgroundColor,
    this.disabledForegroundColor,
    this.radius,
    this.textStyle,
  });

  /// Fill in the default, hovered, and focused states.
  final Color? backgroundColor;

  /// Label and icon color in the default, hovered, and pressed states.
  final Color? foregroundColor;

  /// Fill while pressed, such as the fill with a state layer composited.
  final Color? pressedBackgroundColor;

  /// Fill while disabled.
  ///
  /// When this or [disabledForegroundColor] is set, a disabled button with a
  /// label draws the disabled colors at full opacity instead of fading to 50%.
  final Color? disabledBackgroundColor;

  /// Label and icon color while disabled.
  ///
  /// When this or [disabledBackgroundColor] is set, a disabled button with a
  /// label draws the disabled colors at full opacity instead of fading to 50%.
  final Color? disabledForegroundColor;

  /// Corner radius, such as a pill. The focus ring follows it.
  final BorderRadiusGeometry? radius;

  /// Label style, merged onto the variant's text style; the foreground color
  /// still applies on top of it.
  final TextStyle? textStyle;

  /// Whether a disabled color is set.
  bool get hasDisabledColors =>
      disabledBackgroundColor != null || disabledForegroundColor != null;

  /// Returns a copy with the given fields replaced.
  ZamButtonStyle copyWith({
    Color? backgroundColor,
    Color? foregroundColor,
    Color? pressedBackgroundColor,
    Color? disabledBackgroundColor,
    Color? disabledForegroundColor,
    BorderRadiusGeometry? radius,
    TextStyle? textStyle,
  }) {
    return ZamButtonStyle(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      foregroundColor: foregroundColor ?? this.foregroundColor,
      pressedBackgroundColor:
          pressedBackgroundColor ?? this.pressedBackgroundColor,
      disabledBackgroundColor:
          disabledBackgroundColor ?? this.disabledBackgroundColor,
      disabledForegroundColor:
          disabledForegroundColor ?? this.disabledForegroundColor,
      radius: radius ?? this.radius,
      textStyle: textStyle ?? this.textStyle,
    );
  }

  @override
  bool operator ==(Object other) =>
      other is ZamButtonStyle &&
      other.backgroundColor == backgroundColor &&
      other.foregroundColor == foregroundColor &&
      other.pressedBackgroundColor == pressedBackgroundColor &&
      other.disabledBackgroundColor == disabledBackgroundColor &&
      other.disabledForegroundColor == disabledForegroundColor &&
      other.radius == radius &&
      other.textStyle == textStyle;

  @override
  int get hashCode => Object.hash(
        backgroundColor,
        foregroundColor,
        pressedBackgroundColor,
        disabledBackgroundColor,
        disabledForegroundColor,
        radius,
        textStyle,
      );
}
