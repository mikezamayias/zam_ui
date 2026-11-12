part of '../controls.dart';

class _ZamPressableState extends State<ZamPressable> {
  bool _hovered = false;
  bool _pressed = false;
  bool _focused = false;

  // A recognizer that a rebuild disposes reports a cancel while the tree
  // builds. The state is already cleared by then, so it only needs the write.
  void _set(VoidCallback update) {
    if (SchedulerBinding.instance.schedulerPhase ==
        SchedulerPhase.persistentCallbacks) {
      update();
    } else {
      setState(update);
    }
  }

  @override
  void didUpdateWidget(ZamPressable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!widget._isInteractive) {
      _pressed = false;
      _hovered = false;
      _focused = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final palette = context.zamPalette;
    final interactive = widget._isInteractive;
    final onTap = interactive ? widget.onTap : null;
    final onLongPress = interactive ? widget.onLongPress : null;
    final overlay = interactive && _pressed
        ? theme.opacities.apply(palette.foreground, theme.opacities.pressed)
        : interactive && _hovered
        ? theme.opacities.apply(palette.foreground, theme.opacities.whisper)
        : theme.colors.transparent;

    return FocusableActionDetector(
      enabled: interactive,
      focusNode: widget.focusNode,
      onShowFocusHighlight: (value) => _set(() => _focused = value),
      // Web maps Enter to ButtonActivateIntent and Space to ActivateIntent.
      actions: {
        if (onTap != null) ...{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              onTap();
              return null;
            },
          ),
          ButtonActivateIntent: CallbackAction<ButtonActivateIntent>(
            onInvoke: (_) {
              onTap();
              return null;
            },
          ),
        },
      },
      // Hover is tracked here, not through the detector's hover highlight,
      // because that one only fires in keyboard-driven highlight mode.
      child: MouseRegion(
        cursor: interactive ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) => _set(() => _hovered = true),
        onExit: (_) => _set(() => _hovered = false),
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: onTap,
          onLongPress: onLongPress,
          // A tap recognizer exists only with a tap callback, so a press
          // with no tap handler adds no tap action for screen readers.
          onTapDown: onTap == null ? null : (_) => _set(() => _pressed = true),
          onTapUp: onTap == null ? null : (_) => _set(() => _pressed = false),
          onTapCancel: onTap == null
              ? null
              : () => _set(() => _pressed = false),
          onLongPressDown: onLongPress == null
              ? null
              : (_) => _set(() => _pressed = true),
          onLongPressUp: onLongPress == null
              ? null
              : () => _set(() => _pressed = false),
          onLongPressCancel: onLongPress == null
              ? null
              : () => _set(() => _pressed = false),
          child: DecoratedBox(
            position: DecorationPosition.foreground,
            decoration: BoxDecoration(
              color: overlay,
              borderRadius: widget.radius ?? theme.radius.md,
              border: interactive && _focused
                  ? Border.fromBorderSide(
                      BorderSide(
                        color: palette.ring,
                        width: theme.strokes.focusRing,
                      ),
                    )
                  : null,
            ),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
