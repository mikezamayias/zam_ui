part of '../controls.dart';

/// Wraps [child] with press, hover and focus feedback and tap handling.
///
/// A press or a hover draws a translucent foreground overlay, and keyboard
/// focus draws a ring. Enter and Space activate [onTap]. Touch taps and the
/// screen reader tap action reach [onTap] and [onLongPress] through the same
/// gesture detector.
///
/// The widget adds no label and no role, so callers wrap it in their own
/// `Semantics`, as they would around an ink well. It adds no minimum size
/// either, so callers constrain the hit target themselves.
class ZamPressable extends StatefulWidget {
  /// Creates a [ZamPressable].
  const ZamPressable({
    required this.child,
    super.key,
    this.onTap,
    this.onLongPress,
    this.radius,
    this.enabled = true,
    this.focusNode,
  });

  /// Content that receives the overlay and the focus ring.
  final Widget child;

  /// Called on a tap, on Enter and on Space.
  final VoidCallback? onTap;

  /// Called on a long press.
  final VoidCallback? onLongPress;

  /// Corner radius of the overlay and the focus ring.
  ///
  /// Defaults to the theme's medium radius.
  final BorderRadiusGeometry? radius;

  /// Whether the widget reacts to input.
  ///
  /// A widget with neither [onTap] nor [onLongPress] is inactive as well.
  final bool enabled;

  /// Focus node for keyboard focus, or null to let the widget own one.
  final FocusNode? focusNode;

  bool get _isInteractive => enabled && (onTap != null || onLongPress != null);

  @override
  State<ZamPressable> createState() => _ZamPressableState();
}
