part of '../tokens.dart';

/// Stroke width tokens defining border hairlines, focus rings, and selection indicators.
class ZamStrokeTokens {
  /// Creates a configurable [ZamStrokeTokens] set.
  const ZamStrokeTokens({
    this.hairline = 1,
    this.progress = 2,
    this.focusRing = 3,
    this.selected = 3,
  });

  /// Hairline border thickness (1px).
  final double hairline;

  /// Progress bar stroke thickness (2px).
  final double progress;

  /// Focus ring outline thickness (3px).
  final double focusRing;

  /// Selection border indicator thickness (3px).
  final double selected;

  /// Creates a [BorderSide] using [hairline] width and specified [color].
  BorderSide border(Color color) => BorderSide(color: color, width: hairline);
}
