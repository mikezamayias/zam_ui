part of '../overlays.dart';

/// The edge of the screen a sheet slides in from.
enum ZamSheetSide {
  /// The sheet slides down from the top edge.
  top,

  /// The sheet slides up from the bottom edge.
  bottom,

  /// The sheet slides in from the left edge.
  left,

  /// The sheet slides in from the right edge.
  right;

  /// Whether the sheet moves along the vertical axis.
  bool get _isVertical => this == top || this == bottom;

  Alignment get _alignment => switch (this) {
    top => Alignment.topCenter,
    bottom => Alignment.bottomCenter,
    left => Alignment.centerLeft,
    right => Alignment.centerRight,
  };

  /// The share of the sheet that is off screen before it enters.
  Offset get _hiddenOffset => switch (this) {
    top => const Offset(0, -1),
    bottom => const Offset(0, 1),
    left => const Offset(-1, 0),
    right => const Offset(1, 0),
  };

  /// A drag along the axis, positive toward dismissal.
  double _towardEdge(Offset delta) => switch (this) {
    top => -delta.dy,
    bottom => delta.dy,
    left => -delta.dx,
    right => delta.dx,
  };

  /// The corners that face the screen get the radius.
  BorderRadius _cornersFor(BorderRadius radius) => switch (this) {
    top => BorderRadius.vertical(bottom: radius.bottomLeft),
    bottom => BorderRadius.vertical(top: radius.topLeft),
    left => BorderRadius.horizontal(right: radius.topRight),
    right => BorderRadius.horizontal(left: radius.topLeft),
  };
}
