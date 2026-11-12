part of '../controls.dart';

/// Screen reader wording for the reorder actions of a [ZamReorderableList].
///
/// The defaults are English. Apps pass their own localized strings.
@immutable
class ZamReorderLabels {
  /// Creates a [ZamReorderLabels].
  const ZamReorderLabels({
    this.moveUp = 'Move up',
    this.moveDown = 'Move down',
    this.moveToStart = 'Move to the start',
    this.moveToEnd = 'Move to the end',
  });

  /// Action that moves an item one place toward the start.
  final String moveUp;

  /// Action that moves an item one place toward the end.
  final String moveDown;

  /// Action that moves an item to the first place.
  final String moveToStart;

  /// Action that moves an item to the last place.
  final String moveToEnd;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZamReorderLabels &&
          other.moveUp == moveUp &&
          other.moveDown == moveDown &&
          other.moveToStart == moveToStart &&
          other.moveToEnd == moveToEnd;

  @override
  int get hashCode => Object.hash(moveUp, moveDown, moveToStart, moveToEnd);
}
