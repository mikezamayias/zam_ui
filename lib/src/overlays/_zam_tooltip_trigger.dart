part of '../overlays.dart';

/// The state behind [ZamTooltip]: a shad tooltip that a long press also opens.
class _ZamTooltipTrigger extends StatefulWidget {
  const _ZamTooltipTrigger({
    required this.message,
    required this.excludeFromSemantics,
    required this.waitDuration,
    required this.child,
  });

  final String message;
  final bool excludeFromSemantics;
  final Duration? waitDuration;
  final Widget child;

  @override
  State<_ZamTooltipTrigger> createState() => _ZamTooltipTriggerState();
}

class _ZamTooltipTriggerState extends State<_ZamTooltipTrigger> {
  /// How long a long-pressed tooltip stays before it hides (1.5 seconds).
  static final Duration _touchHold = ZamDurationToken.long4.duration * 2.5;

  final ShadTooltipController _controller = ShadTooltipController();
  Timer? _hideTimer;

  @override
  void initState() {
    super.initState();
    _controller.addListener(_onVisibilityChanged);
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    FocusManager.instance.removeEarlyKeyEventHandler(_onKeyEvent);
    _controller
      ..removeListener(_onVisibilityChanged)
      ..dispose();
    super.dispose();
  }

  void _onVisibilityChanged() {
    if (_controller.isOpen) {
      // Escape closes a shown tooltip wherever the focus is, so a pointer user
      // can dismiss one that the pointer opened.
      FocusManager.instance.addEarlyKeyEventHandler(_onKeyEvent);
      if (!widget.excludeFromSemantics) {
        SemanticsService.tooltip(widget.message).ignore();
      }
    } else {
      FocusManager.instance.removeEarlyKeyEventHandler(_onKeyEvent);
    }
  }

  KeyEventResult _onKeyEvent(KeyEvent event) {
    if (event is KeyDownEvent &&
        event.logicalKey == LogicalKeyboardKey.escape &&
        _controller.isOpen) {
      _hideTimer?.cancel();
      _controller.hide();
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  void _showForTouch() {
    _hideTimer?.cancel();
    _controller.show();
    _hideTimer = Timer(_touchHold, _controller.hide);
  }

  @override
  Widget build(BuildContext context) {
    Widget result = ShadTooltip(
      controller: _controller,
      waitDuration: widget.waitDuration,
      builder: (context) => Text(widget.message),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onLongPress: _showForTouch,
        child: widget.child,
      ),
    );
    if (!widget.excludeFromSemantics) {
      result = Semantics(tooltip: widget.message, child: result);
    }
    return result;
  }
}
