part of '../text.dart';

// The edit menu of a ZamTextField.
//
// On iOS, when the platform can show it, this is the system menu, which the
// operating system localizes. Elsewhere it is shad's menu.
Widget _zamEditableTextContextMenu(
  BuildContext context,
  EditableTextState editableTextState,
) {
  if (SystemContextMenu.isSupportedByField(editableTextState)) {
    return SystemContextMenu.editableText(editableTextState: editableTextState);
  }
  return _zamContextMenu(
    context,
    anchors: editableTextState.contextMenuAnchors,
    items: editableTextState.contextMenuButtonItems,
    // Select all keeps the menu open on phones, and the menu then offers cut
    // and copy for the new selection.
    onSelectAll: editableTextState.showToolbar,
  );
}

// The edit menu of a ZamSelectionArea: shad's menu on every platform, because
// Flutter 3.50 offers the iOS system menu for editable text only.
Widget _zamSelectableRegionContextMenu(
  BuildContext context,
  SelectableRegionState selectableRegionState,
) {
  return _zamContextMenu(
    context,
    anchors: selectableRegionState.contextMenuAnchors,
    items: selectableRegionState.contextMenuButtonItems,
  );
}

// shad's context menu with the items Flutter offers for the platform and the
// selection, labelled by GlobalShadLocalizations.
//
// The menu sits above the selection, or below it when there is no room above,
// so that it never covers the selected text or the handles that drag it.
// Items shad has no label for, such as share or look up, are left out.
Widget _zamContextMenu(
  BuildContext context, {
  required TextSelectionToolbarAnchors anchors,
  required List<ContextMenuButtonItem> items,
  VoidCallback? onSelectAll,
}) {
  final strings = ShadLocalizations.of(context).input;
  String? labelOf(ContextMenuButtonItem item) =>
      switch (item.type) {
        ContextMenuButtonType.cut => strings.cut,
        ContextMenuButtonType.copy => strings.copy,
        ContextMenuButtonType.paste => strings.paste,
        ContextMenuButtonType.selectAll => strings.selectAll,
        _ => null,
      } ??
      item.label;

  final labelled = [
    for (final item in items)
      if (labelOf(item) case final label? when label.isNotEmpty)
        (item: item, label: label),
  ];
  if (labelled.isEmpty) return const SizedBox.shrink();

  // The iOS handles carry a ball above the start and below the end of the
  // selection, and the Android teardrops hang below it.
  final iosStyle = ZamTextSelectionControls._iosStyle;
  const ballGap = _kIosHandleRadius * 2;
  final gapAbove = iosStyle ? ballGap : _kAndroidHandleSize / 2;
  final gapBelow = iosStyle ? ballGap : _kAndroidHandleSize + ballGap / 3;
  // shad keeps the menu inside the overlay it opens in. The status bar and
  // the keyboard sit inside the app overlay, so the menu opens in an overlay
  // of its own that covers only the visible area.
  final media = MediaQuery.of(context);
  final visible = EdgeInsets.only(
    top: media.padding.top,
    bottom: math.max(media.padding.bottom, media.viewInsets.bottom),
  );
  final visibleHeight = math.max(0, media.size.height - visible.vertical);
  double inVisible(double globalY) =>
      clampDouble(globalY - visible.top, 0, visibleHeight.toDouble());
  final top = inVisible(anchors.primaryAnchor.dy);
  final bottom = inVisible(
    (anchors.secondaryAnchor ?? anchors.primaryAnchor).dy,
  );

  return Padding(
    padding: visible,
    child: Overlay.wrap(
      child: Stack(
        children: [
          Positioned(
            left: anchors.primaryAnchor.dx,
            top: top,
            width: 0,
            height: math.max(0, bottom - top),
            child: FocusScope(
              // The menu must not take focus from the field or the region, or
              // they would dismiss it before it renders.
              canRequestFocus: false,
              child: ShadContextMenu(
                visible: true,
                // shad hangs the menu below the target point, and a top
                // follower anchor lifts it by its own height, so this pair
                // puts the menu above the selection and the fallback below.
                anchor: ShadAnchorAuto(
                  followerAnchor: Alignment.topCenter,
                  targetAnchor: Alignment.topCenter,
                  offset: Offset(0, -gapAbove),
                  // shad's default pair, bottom on bottom, hangs it below.
                  fallback: ShadAnchorAuto(offset: Offset(0, gapBelow)),
                ),
                items: [
                  for (final (:item, :label) in labelled)
                    ShadContextMenuItem(
                      onTapDown: item.onPressed == null
                          ? null
                          : (_) {
                              item.onPressed!();
                              if (item.type ==
                                  ContextMenuButtonType.selectAll) {
                                onSelectAll?.call();
                              }
                            },
                      child: Text(label),
                    ),
                ],
                child: const SizedBox.expand(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
