part of '../shell.dart';

/// The Zam scrollbar for a [ListView], [GridView] or [CustomScrollView].
///
/// The thumb fades in while scrolling and out shortly after, in the theme's
/// border colour. The scrollbar that [ZamScrollBehavior] would add is turned
/// off below it, so there is only one.
class ZamScrollbar extends StatelessWidget {
  /// Creates a scrollbar for [child].
  const ZamScrollbar({
    required this.child,
    this.controller,
    this.thumbVisibility,
    this.thickness,
    this.thumbColor,
    super.key,
  });

  /// The scrollable the scrollbar belongs to.
  final Widget child;

  /// The controller of [child].
  ///
  /// Defaults to the [PrimaryScrollController].
  final ScrollController? controller;

  /// Whether the thumb stays visible when not scrolling.
  ///
  /// Defaults to false.
  final bool? thumbVisibility;

  /// The thumb's thickness in logical pixels.
  ///
  /// Defaults to 7.
  final double? thickness;

  /// The thumb's colour.
  ///
  /// Defaults to the palette's border colour.
  final Color? thumbColor;

  @override
  Widget build(BuildContext context) {
    return ShadScrollbar(
      controller: controller,
      thumbVisibility: thumbVisibility,
      thickness: thickness,
      thumbColor: thumbColor,
      child: child,
    );
  }
}
