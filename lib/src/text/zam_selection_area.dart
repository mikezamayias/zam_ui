part of '../text.dart';

/// Makes the text in [child] selectable, with platform handles, a magnifier
/// and an edit menu.
///
/// It wraps [SelectableRegion] with the same parts as [ZamTextField]:
/// [ZamTextSelectionControls] for the handles, the iOS or Android magnifier,
/// and shad's menu with localized copy and select-all items. Unlike the text
/// field, it uses shad's menu on iOS too, because Flutter offers the iOS
/// system menu for editable text only.
///
/// Wrap a [Text] in it to get what `SelectableText` gives.
class ZamSelectionArea extends StatelessWidget {
  /// Creates a [ZamSelectionArea] around [child].
  const ZamSelectionArea({required this.child, this.focusNode, super.key});

  /// The subtree whose text can be selected.
  final Widget child;

  /// The focus node of the region, or null for one of its own.
  final FocusNode? focusNode;

  @override
  Widget build(BuildContext context) {
    return SelectableRegion(
      focusNode: focusNode,
      selectionControls: _zamTextSelectionControls,
      contextMenuBuilder: _zamSelectableRegionContextMenu,
      magnifierConfiguration: _zamMagnifierConfiguration(),
      child: child,
    );
  }
}
