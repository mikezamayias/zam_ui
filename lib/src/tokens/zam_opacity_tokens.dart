part of '../tokens.dart';

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
