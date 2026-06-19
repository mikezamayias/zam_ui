part of '../tokens.dart';

class ZamOpacityTokens {
  const ZamOpacityTokens({
    this.transparent = 0,
    this.whisper = 0.06,
    this.pressed = 0.08,
    this.tint = 0.1,
    this.subtleTint = 0.12,
    this.softTint = 0.15,
    this.overlay = 0.2,
    this.quarter = 0.25,
    this.borderTint = 0.28,
    this.faint = 0.3,
    this.mediumTint = 0.4,
    this.disabled = 0.5,
    this.scrim = 0.55,
    this.secondary = 0.6,
    this.overlayStrong = 0.65,
    this.iconEmphasis = 0.7,
    this.high = 0.8,
    this.strong = 0.85,
    this.nearlyOpaque = 0.88,
    this.visible = 1,
  });

  final double transparent;
  final double whisper;
  final double pressed;
  final double tint;
  final double subtleTint;
  final double softTint;
  final double overlay;
  final double quarter;
  final double borderTint;
  final double faint;
  final double mediumTint;
  final double disabled;
  final double scrim;
  final double secondary;
  final double overlayStrong;
  final double iconEmphasis;
  final double high;
  final double strong;
  final double nearlyOpaque;
  final double visible;

  Color apply(Color color, double token) => color.withValues(alpha: token);
}
