part of '../overlays.dart';

/// Gives [child] its own toast layer, so [ZamToast] works below it.
///
/// [ZamApp] already places a toaster around the app. Use this widget for a
/// subtree that replaces the app builder's child, such as a screen that takes
/// over the whole app, because that subtree no longer sits below the root
/// toaster.
class ZamToaster extends StatelessWidget {
  /// Creates a [ZamToaster] around [child].
  const ZamToaster({required this.child, super.key});

  /// The widget below the toaster. Toasts appear above it.
  final Widget child;

  @override
  Widget build(BuildContext context) => ShadToaster(child: child);
}
