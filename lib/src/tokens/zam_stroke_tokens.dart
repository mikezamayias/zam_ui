part of '../tokens.dart';

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
