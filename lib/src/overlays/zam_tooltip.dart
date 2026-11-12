part of '../overlays.dart';

/// A short label that appears next to [child] on hover and on long press.
///
/// Touch users long-press [child] and the tooltip stays for about a second and
/// a half. Pointer users hover it. Escape hides it. Screen readers read
/// [message] as a hint on [child] and can trigger the long press action, and
/// TalkBack also hears the message when the tooltip opens.
///
/// A tooltip does not take focus. A keyboard user reaches the label through
/// the semantics of [child], so [child] should be a labeled control.
class ZamTooltip extends StatelessWidget {
  /// Creates a [ZamTooltip] that shows [message] next to [child].
  const ZamTooltip({
    required this.message,
    required this.child,
    super.key,
    this.excludeFromSemantics = false,
    this.waitDuration,
  });

  /// The text of the tooltip.
  final String message;

  /// The widget the tooltip belongs to.
  final Widget child;

  /// Whether to leave [message] out of the semantics of [child].
  ///
  /// Set it when [child] already carries the same words as its label, so a
  /// screen reader does not read them twice.
  final bool excludeFromSemantics;

  /// How long a pointer rests on [child] before the tooltip appears.
  ///
  /// When null, the tooltip appears at once.
  final Duration? waitDuration;

  @override
  Widget build(BuildContext context) {
    return _ZamTooltipTrigger(
      message: message,
      excludeFromSemantics: excludeFromSemantics,
      waitDuration: waitDuration,
      child: child,
    );
  }
}
