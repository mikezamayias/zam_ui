part of '../components.dart';

class ZamScreen extends StatelessWidget {
  const ZamScreen({
    required this.child,
    super.key,
    this.padding,
    this.scrollable = false,
    this.safeBottom = false,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final bool scrollable;
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
