part of '../overlays.dart';

/// The frame [showZamSheet] draws around the sheet content.
///
/// It slides in from its side with the route animation, follows a drag toward
/// that side by driving the same animation, pads for the safe area and the
/// keyboard, and draws the surface, border and corners.
class _ZamSheetFrame extends StatefulWidget {
  const _ZamSheetFrame({
    required this.side,
    required this.backgroundColor,
    required this.borderColor,
    required this.radius,
    required this.dismissLabel,
    required this.enterCurve,
    required this.exitCurve,
    required this.enableDrag,
    required this.showDragHandle,
    required this.useSafeArea,
    required this.maxHeightFraction,
    required this.child,
  });

  final ZamSheetSide side;
  final Color? backgroundColor;
  final Color? borderColor;
  final BorderRadiusGeometry? radius;
  final String dismissLabel;
  final Curve enterCurve;
  final Curve exitCurve;
  final bool enableDrag;
  final bool showDragHandle;
  final bool useSafeArea;
  final double maxHeightFraction;
  final Widget child;

  @override
  State<_ZamSheetFrame> createState() => _ZamSheetFrameState();
}

class _ZamSheetFrameState extends State<_ZamSheetFrame> {
  /// A drag at least this fast, in logical pixels per second, decides the
  /// outcome whatever the position.
  static const double _flingVelocity = 700;

  /// A slower drag closes the sheet when it is less than this far open.
  static const double _closeThreshold = 0.5;

  /// A left or right sheet takes at most this share of the screen width.
  static const double _sideWidthFraction = 0.75;

  /// A left or right sheet is never wider than this many spacing steps (384).
  static const double _sideMaxWidthSteps = 96;

  final GlobalKey _frameKey = GlobalKey();
  _ZamOverlayRoute<dynamic>? _route;

  /// Whether the user has dragged the sheet. A drag moves the sheet one to one
  /// with the finger, so the curves are dropped from then on.
  bool _dragged = false;
  bool _closing = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final route = ModalRoute.of(context);
    _route = route is _ZamOverlayRoute<dynamic> ? route : null;
  }

  double get _extent {
    final size = _frameKey.currentContext?.size;
    final extent = widget.side._isVertical ? size?.height : size?.width;
    return extent == null || extent <= 0 ? 1 : extent;
  }

  Future<void> _close() async {
    final route = _route;
    if (_closing || route == null || !route.isCurrent) return;
    _closing = true;
    await Navigator.of(context).maybePop();
    // `maybePop` also reports true when a PopScope blocked the pop. A route
    // that is really leaving has started its exit animation by now.
    final leaving =
        !mounted ||
        !route.isCurrent ||
        route.dragController?.status == AnimationStatus.reverse;
    if (!leaving) {
      _closing = false;
      route.dragController?.forward();
    }
  }

  void _onDragStart(DragStartDetails details) {
    if (!_closing) setState(() => _dragged = true);
  }

  void _onDragUpdate(DragUpdateDetails details) {
    final controller = _route?.dragController;
    if (_closing || controller == null) return;
    controller.value -= widget.side._towardEdge(details.delta) / _extent;
  }

  void _onDragEnd(DragEndDetails details) {
    final controller = _route?.dragController;
    if (_closing || controller == null) return;
    final velocity = widget.side._towardEdge(details.velocity.pixelsPerSecond);
    final close =
        velocity > _flingVelocity ||
        (velocity >= -_flingVelocity && controller.value < _closeThreshold);
    if (close) {
      _close();
    } else {
      controller.forward();
    }
  }

  void _onDragCancel() {
    if (!_closing) _route?.dragController?.forward();
  }

  /// The safe area padding of the edge the sheet sits on, and of the edges it
  /// spans.
  EdgeInsets _safeInset(EdgeInsets padding) => switch (widget.side) {
    ZamSheetSide.top => EdgeInsets.fromLTRB(
      padding.left,
      padding.top,
      padding.right,
      0,
    ),
    ZamSheetSide.bottom => EdgeInsets.fromLTRB(
      padding.left,
      0,
      padding.right,
      padding.bottom,
    ),
    ZamSheetSide.left => EdgeInsets.fromLTRB(
      padding.left,
      padding.top,
      0,
      padding.bottom,
    ),
    ZamSheetSide.right => EdgeInsets.fromLTRB(
      0,
      padding.top,
      padding.right,
      padding.bottom,
    ),
  };

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final palette = context.zamPalette;
    final side = widget.side;
    final media = MediaQuery.of(context);
    final animation = _route?.animation ?? kAlwaysCompleteAnimation;
    final radius = (widget.radius ?? side._cornersFor(theme.radius.dialog))
        .resolve(Directionality.of(context));
    final inset = widget.useSafeArea
        ? _safeInset(media.padding)
        : theme.insets.zero;

    // The sheet applies the keyboard and the safe area itself, so the content
    // sees them as already consumed and does not pad for them a second time.
    final contentMedia = media
        .removeViewInsets(removeBottom: true)
        .removePadding(
          removeTop:
              widget.useSafeArea &&
              (inset.top > 0 || side == ZamSheetSide.bottom),
          removeBottom: widget.useSafeArea && inset.bottom > 0,
          removeLeft: widget.useSafeArea && inset.left > 0,
          removeRight: widget.useSafeArea && inset.right > 0,
        );
    final handle = widget.showDragHandle && side._isVertical
        ? _ZamSheetHandle(label: widget.dismissLabel, onDismiss: _close)
        : null;

    Widget surface = _ZamOverlaySurface(
      color: widget.backgroundColor ?? palette.card,
      borderColor: widget.borderColor ?? palette.border,
      foreground: palette.cardForeground,
      radius: radius,
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: inset,
        child: side._isVertical
            ? Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (side == ZamSheetSide.bottom && handle != null) handle,
                  Flexible(child: widget.child),
                  if (side == ZamSheetSide.top && handle != null) handle,
                ],
              )
            : widget.child,
      ),
    );

    if (widget.enableDrag) {
      surface = side._isVertical
          ? GestureDetector(
              onVerticalDragStart: _onDragStart,
              onVerticalDragUpdate: _onDragUpdate,
              onVerticalDragEnd: _onDragEnd,
              onVerticalDragCancel: _onDragCancel,
              child: surface,
            )
          : GestureDetector(
              onHorizontalDragStart: _onDragStart,
              onHorizontalDragUpdate: _onDragUpdate,
              onHorizontalDragEnd: _onDragEnd,
              onHorizontalDragCancel: _onDragCancel,
              child: surface,
            );
    }

    final reduceMotion = media.disableAnimations;
    final slid = AnimatedBuilder(
      animation: animation,
      child: KeyedSubtree(key: _frameKey, child: surface),
      builder: (context, child) {
        if (reduceMotion && !_dragged) {
          return Opacity(opacity: animation.value, child: child);
        }
        final curve = _dragged
            ? Curves.linear
            : animation.status == AnimationStatus.reverse
            ? widget.exitCurve
            : widget.enterCurve;
        return FractionalTranslation(
          translation:
              side._hiddenOffset * (1 - curve.transform(animation.value)),
          child: child,
        );
      },
    );

    // The keyboard lifts the sheet. The route page is already inside the safe
    // area of the screen, so only the sheet itself pads for it.
    return AnimatedPadding(
      duration: ZamDurationToken.short4.duration,
      curve: Curves.linearToEaseOut,
      padding: EdgeInsets.only(bottom: media.viewInsets.bottom),
      child: MediaQuery(
        data: contentMedia,
        child: LayoutBuilder(
          builder: (context, box) {
            // A bottom sheet stays below the status bar.
            final available =
                box.maxHeight -
                (side == ZamSheetSide.bottom && widget.useSafeArea
                    ? media.padding.top
                    : 0);
            final width = math.min(
              box.maxWidth * _sideWidthFraction,
              theme.spacing(_sideMaxWidthSteps),
            );
            final constraints = side._isVertical
                ? BoxConstraints(
                    minWidth: box.maxWidth,
                    maxWidth: box.maxWidth,
                    maxHeight: available * widget.maxHeightFraction,
                  )
                : BoxConstraints.tightFor(width: width, height: box.maxHeight);
            return Align(
              alignment: side._alignment,
              child: ConstrainedBox(constraints: constraints, child: slid),
            );
          },
        ),
      ),
    );
  }
}
