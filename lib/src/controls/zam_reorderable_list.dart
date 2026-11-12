part of '../controls.dart';

/// A scrolling list whose items the user can reorder by dragging.
///
/// On iOS, Android and Fuchsia an item starts dragging after a long press.
/// On desktop platforms it starts dragging at once. Every item must have a
/// key, which is how the list tracks it while it moves.
///
/// Each item also offers screen reader actions to move it up, down, to the
/// start and to the end, worded by [labels]. They replace the framework's own
/// English or locale wording, so an item announces each action once.
///
/// The list needs an `Overlay` ancestor, which [ZamApp] provides.
class ZamReorderableList extends StatelessWidget {
  /// Creates a [ZamReorderableList].
  const ZamReorderableList({
    required this.itemCount,
    required this.itemBuilder,
    required this.onReorderItem,
    super.key,
    this.proxyDecorator,
    this.shrinkWrap = false,
    this.physics,
    this.padding,
    this.labels = const ZamReorderLabels(),
  });

  /// Number of items.
  final int itemCount;

  /// Builds the item at an index. The returned widget needs a key.
  final IndexedWidgetBuilder itemBuilder;

  /// Called when an item moves.
  ///
  /// [newIndex] is already adjusted for the removal of the item at
  /// [oldIndex], so it is the index the item has in the new order.
  final ReorderCallback onReorderItem;

  /// Decorates the item while it is dragged.
  ///
  /// Without it the dragged item has no added decoration.
  final ReorderItemProxyDecorator? proxyDecorator;

  /// Whether the list sizes itself to its items.
  final bool shrinkWrap;

  /// Scroll physics, or null for the ambient scroll behavior.
  final ScrollPhysics? physics;

  /// Padding around the items.
  final EdgeInsetsGeometry? padding;

  /// Wording of the screen reader reorder actions.
  final ZamReorderLabels labels;

  Widget _buildItem(BuildContext context, int index) {
    final item = itemBuilder(context, index);
    final key = item.key;
    // The list wraps and re-keys each item, so the key moves to the wrapper
    // as a value key. That keeps a global key unique in the tree.
    final wrapperKey = key == null ? null : ValueKey<Key>(key);
    final dragsAtOnce = switch (defaultTargetPlatform) {
      TargetPlatform.linux ||
      TargetPlatform.macOS ||
      TargetPlatform.windows => true,
      TargetPlatform.android ||
      TargetPlatform.iOS ||
      TargetPlatform.fuchsia => false,
    };
    return dragsAtOnce
        ? ReorderableDragStartListener(
            key: wrapperKey,
            index: index,
            child: item,
          )
        : ReorderableDelayedDragStartListener(
            key: wrapperKey,
            index: index,
            child: item,
          );
  }

  @override
  Widget build(BuildContext context) {
    return Localizations.override(
      context: context,
      delegates: [
        _ZamReorderLocalizationsDelegate(
          base: WidgetsLocalizations.of(context),
          labels: labels,
          direction: Directionality.of(context),
        ),
      ],
      child: ReorderableList(
        itemCount: itemCount,
        itemBuilder: _buildItem,
        onReorderItem: onReorderItem,
        proxyDecorator: proxyDecorator,
        shrinkWrap: shrinkWrap,
        physics: physics,
        padding: padding,
      ),
    );
  }
}
