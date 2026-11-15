part of '../text.dart';

class _ZamSearchFieldState extends State<ZamSearchField> {
  TextEditingController? _localController;
  FocusNode? _localFocusNode;

  TextEditingController get _controller =>
      widget.controller ?? (_localController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ??
      (_localFocusNode ??= FocusNode(debugLabel: 'ZamSearchField'));

  @override
  void didUpdateWidget(ZamSearchField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _localController = TextEditingController.fromValue(
        oldWidget.controller!.value,
      );
    } else if (widget.controller != null && _localController != null) {
      _disposeAfterFrame(_localController!);
      _localController = null;
    }
    if (widget.focusNode != null && _localFocusNode != null) {
      _disposeAfterFrame(_localFocusNode!);
      _localFocusNode = null;
    }
  }

  @override
  void dispose() {
    _localController?.dispose();
    _localFocusNode?.dispose();
    super.dispose();
  }

  // The text field below still holds the old notifier until it rebuilds in
  // this frame, so it is disposed only after that.
  void _disposeAfterFrame(ChangeNotifier notifier) {
    WidgetsBinding.instance.addPostFrameCallback((_) => notifier.dispose());
  }

  void _clear() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final palette = context.zamPalette;
    final controller = _controller;
    final focusNode = _focusNode;
    final searchIcon = theme.icons.search;

    final field = ZamTextField(
      controller: controller,
      focusNode: focusNode,
      placeholderText: widget.placeholderText,
      placeholderMaxLines: 1,
      semanticsLabel: widget.semanticsLabel,
      textInputAction: TextInputAction.search,
      autofillHints: null,
      autofocus: widget.autofocus,
      enabled: widget.enabled,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
    );

    return Opacity(
      opacity: widget.enabled ? 1 : theme.opacities.disabled,
      // Taps on the clear button and the padding count as taps inside the
      // field, so they do not take focus away from it.
      child: TextFieldTapRegion(
        child: ListenableBuilder(
          listenable: Listenable.merge([controller, focusNode]),
          child: field,
          builder: (context, field) {
            final showClear = widget.enabled && controller.text.isNotEmpty;
            return GestureDetector(
              behavior: HitTestBehavior.opaque,
              excludeFromSemantics: true,
              onTap: widget.enabled ? focusNode.requestFocus : null,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: theme.sizes.minTapTarget,
                ),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: palette.card,
                    borderRadius: theme.radius.md,
                    border: Border.fromBorderSide(
                      theme.strokes.border(palette.border),
                    ),
                  ),
                  // The ring is drawn over the border instead of widening
                  // it, so the content keeps its place when focus changes.
                  child: DecoratedBox(
                    position: DecorationPosition.foreground,
                    decoration: BoxDecoration(
                      borderRadius: theme.radius.md,
                      border: focusNode.hasFocus
                          ? Border.fromBorderSide(
                              BorderSide(
                                color: palette.ring,
                                width: theme.strokes.focusRing,
                              ),
                            )
                          : null,
                    ),
                    child: Row(
                      children: [
                        SizedBox(width: theme.spacing(3)),
                        if (searchIcon != null) ...[
                          ExcludeSemantics(
                            child: Icon(
                              searchIcon,
                              size: theme.sizes.iconMd,
                              color: palette.mutedForeground,
                            ),
                          ),
                          SizedBox(width: theme.spacing.sm),
                        ],
                        Expanded(
                          child: Padding(
                            padding: theme.insets.symmetric(
                              vertical: theme.spacing.sm,
                            ),
                            child: field,
                          ),
                        ),
                        if (showClear)
                          _ZamSearchClearButton(
                            semanticsLabel: widget.clearSemanticsLabel,
                            onPressed: _clear,
                          )
                        else
                          SizedBox(width: theme.spacing(3)),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _ZamSearchClearButton extends StatelessWidget {
  const _ZamSearchClearButton({
    required this.semanticsLabel,
    required this.onPressed,
  });

  final String semanticsLabel;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final palette = context.zamPalette;
    final icon = theme.icons.clear;
    final size = theme.sizes.iconSm;
    final color = palette.mutedForeground;

    return Semantics(
      container: true,
      button: true,
      label: semanticsLabel,
      onTap: onPressed,
      excludeSemantics: true,
      child: ZamPressable(
        onTap: onPressed,
        radius: theme.radius.pill,
        child: SizedBox.square(
          dimension: theme.sizes.minTapTarget,
          child: Center(
            child: icon != null
                ? Icon(icon, size: size, color: color)
                : CustomPaint(
                    size: Size.square(size),
                    painter: _ZamCrossPainter(
                      color: color,
                      strokeWidth: theme.strokes.progress,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

// The cross the clear button draws when the app's icon set has no clear
// icon, inset so its round caps stay inside the square.
class _ZamCrossPainter extends CustomPainter {
  const _ZamCrossPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    final rect = (Offset.zero & size).deflate(size.shortestSide / 4);
    canvas
      ..drawLine(rect.topLeft, rect.bottomRight, paint)
      ..drawLine(rect.topRight, rect.bottomLeft, paint);
  }

  @override
  bool shouldRepaint(_ZamCrossPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
