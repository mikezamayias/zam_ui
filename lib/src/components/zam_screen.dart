part of '../components.dart';

/// Screen layout wrapper managing safe area boundaries, padding, and optional scrolling.
class ZamScreen extends StatelessWidget {
  /// Creates a [ZamScreen].
  const ZamScreen({
    required this.child,
    super.key,
    this.padding,
    this.scrollable = false,
    this.safeBottom = false,
  });

  /// Screen body content.
  final Widget child;

  /// Optional padding around content.
  final EdgeInsetsGeometry? padding;

  /// Whether the screen body should wrap in a [SingleChildScrollView].
  final bool scrollable;

  /// Whether to enforce bottom safe area inset.
  final bool safeBottom;

  @override
  Widget build(BuildContext context) {
    final content =
        padding == null ? child : Padding(padding: padding!, child: child);

    return SafeArea(
      bottom: safeBottom,
      child: scrollable ? SingleChildScrollView(child: content) : content,
    );
  }
}
