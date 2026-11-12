part of '../controls.dart';

/// Widgets localizations that reword the reorder actions and forward the rest.
///
/// The framework builds the screen reader reorder actions from
/// [WidgetsLocalizations], so overriding it below a [ZamReorderableList] is
/// the one way to word them without a second set of actions.
class _ZamReorderLocalizations implements WidgetsLocalizations {
  const _ZamReorderLocalizations({
    required this.base,
    required this.labels,
    required this.direction,
  });

  final WidgetsLocalizations base;
  final ZamReorderLabels labels;

  /// The ambient direction, which [Localizations] applies to its subtree. It
  /// is not the base's, so a local `Directionality` above the list survives.
  final TextDirection direction;

  @override
  String get reorderItemUp => labels.moveUp;

  @override
  String get reorderItemDown => labels.moveDown;

  @override
  String get reorderItemToStart => labels.moveToStart;

  @override
  String get reorderItemToEnd => labels.moveToEnd;

  @override
  TextDirection get textDirection => direction;

  @override
  String get reorderItemLeft => base.reorderItemLeft;

  @override
  String get reorderItemRight => base.reorderItemRight;

  @override
  String get searchResultsFound => base.searchResultsFound;

  @override
  String get noResultsFound => base.noResultsFound;

  @override
  String get copyButtonLabel => base.copyButtonLabel;

  @override
  String get cutButtonLabel => base.cutButtonLabel;

  @override
  String get pasteButtonLabel => base.pasteButtonLabel;

  @override
  String get selectAllButtonLabel => base.selectAllButtonLabel;

  @override
  String get lookUpButtonLabel => base.lookUpButtonLabel;

  @override
  String get searchWebButtonLabel => base.searchWebButtonLabel;

  @override
  String get shareButtonLabel => base.shareButtonLabel;

  @override
  String get radioButtonUnselectedLabel => base.radioButtonUnselectedLabel;
}
