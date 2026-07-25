part of '../tokens.dart';

/// Opacity tokens defining standard alpha values for states, overlays, and tints.
class ZamOpacityTokens {
  /// Creates a configurable [ZamOpacityTokens] scale.
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

  /// Fully transparent opacity (0.0).
  final double transparent;

  /// Whisper light opacity (0.06).
  final double whisper;

  /// Pressed state opacity (0.08).
  final double pressed;

  /// Standard tint opacity (0.10).
  final double tint;

  /// Subtle tint opacity (0.12).
  final double subtleTint;

  /// Soft tint opacity (0.15).
  final double softTint;

  /// Standard overlay opacity (0.20).
  final double overlay;

  /// Quarter opacity (0.25).
  final double quarter;

  /// Border tint opacity (0.28).
  final double borderTint;

  /// Faint opacity (0.30).
  final double faint;

  /// Medium tint opacity (0.40).
  final double mediumTint;

  /// Disabled element opacity (0.50).
  final double disabled;

  /// Modal scrim opacity (0.55).
  final double scrim;

  /// Secondary text opacity (0.60).
  final double secondary;

  /// Strong overlay opacity (0.65).
  final double overlayStrong;

  /// Icon emphasis opacity (0.70).
  final double iconEmphasis;

  /// High emphasis opacity (0.80).
  final double high;

  /// Strong opacity (0.85).
  final double strong;

  /// Nearly opaque value (0.88).
  final double nearlyOpaque;

  /// Fully visible opacity (1.0).
  final double visible;

  /// Applies opacity [token] value to a given [color].
  Color apply(Color color, double token) => color.withValues(alpha: token);
}
