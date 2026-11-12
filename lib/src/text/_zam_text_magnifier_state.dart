// Adapted from Flutter's material/magnifier.dart and cupertino/magnifier.dart.
//
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../text.dart';

class _ZamTextMagnifierState extends State<_ZamTextMagnifier>
    with SingleTickerProviderStateMixin {
  Offset _position = Offset.zero;
  bool _positioned = false;
  Offset _focalPointAdjustment = Offset.zero;

  // Android: set while the lens animates a jump to another line.
  Timer? _lineJumpTimer;

  // iOS: the fade and slide in and out.
  late final AnimationController _inOut = AnimationController(
    vsync: this,
    duration: ZamDurationToken.short3.duration,
    value: widget.iosStyle ? 0 : 1,
  )..addListener(_rebuild);
  late final CurvedAnimation _inOutCurve = CurvedAnimation(
    parent: _inOut,
    curve: Curves.easeOut,
  );

  void _rebuild() => setState(() {});

  @override
  void initState() {
    super.initState();
    if (widget.iosStyle) widget.controller.animationController = _inOut;
    widget.magnifierInfo.addListener(_update);
  }

  @override
  void didChangeDependencies() {
    _update();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    if (identical(widget.controller.animationController, _inOut)) {
      widget.controller.animationController = null;
    }
    widget.magnifierInfo.removeListener(_update);
    _lineJumpTimer?.cancel();
    _inOutCurve.dispose();
    _inOut.dispose();
    super.dispose();
  }

  void _update() => widget.iosStyle ? _updateIos() : _updateAndroid();

  void _updateIos() {
    final info = widget.magnifierInfo.value;
    final lineCenter = info.caretRect.center.dy;
    final gesture = info.globalGesturePosition;

    if (lineCenter - gesture.dy < -_kIosHideBelowThreshold) {
      if (widget.controller.shown) {
        widget.controller.hide(removeFromOverlay: false);
      }
      return;
    }
    if (!widget.controller.shown) _inOut.forward();

    // Never above the line's center, and a resisted follow below it.
    final lensY = math.max(
      lineCenter,
      lineCenter - (lineCenter - gesture.dy) / _kIosDragResistance,
    );
    final raw = Offset(
      gesture.dx - _kIosLensSize.width / 2,
      lensY - (_kIosLensSize.height - _kIosLensAboveFocalPoint),
    );
    final screen = Offset.zero & MediaQuery.sizeOf(context);
    // iOS keeps the lens inside the screen sideways only.
    final verticalSlack = _kIosLensSize.height + _kIosLensAboveFocalPoint;
    final adjusted = MagnifierController.shiftWithinBounds(
      bounds: Rect.fromLTRB(
        screen.left + _kIosScreenEdgePadding,
        screen.top - verticalSlack,
        screen.right - _kIosScreenEdgePadding,
        screen.bottom + verticalSlack,
      ),
      rect: raw & _kIosLensSize,
    ).topLeft;

    setState(() {
      _position = adjusted;
      _positioned = true;
      // The lens always shows the center of the line.
      _focalPointAdjustment = Offset(0, lineCenter - lensY);
    });
  }

  void _updateAndroid() {
    final info = widget.magnifierInfo.value;
    final screen = Offset.zero & MediaQuery.sizeOf(context);
    final centering = Offset(
      _kAndroidLensSize.width / 2,
      _kAndroidLensSize.height + _kAndroidLensAboveFocalPoint,
    );

    // Follow the finger, but never past either end of the current line.
    final x = clampDouble(
      info.globalGesturePosition.dx,
      info.currentLineBoundaries.left,
      info.currentLineBoundaries.right,
    );
    final unadjusted =
        Offset(x, info.caretRect.center.dy) - centering & _kAndroidLensSize;
    final adjusted = MagnifierController.shiftWithinBounds(
      bounds: screen,
      rect: unadjusted,
    );

    // Keep the focal point inside the field, so the lens never shows what
    // lies beyond it, unless the field is too narrow for that.
    final edgeInset = (_kAndroidLensSize.width / 2) / _kAndroidMagnification;
    final focalX = info.fieldBounds.width < edgeInset * 2
        ? info.fieldBounds.center.dx
        : clampDouble(
            adjusted.center.dx,
            info.fieldBounds.left + edgeInset,
            info.fieldBounds.right - edgeInset,
          );

    var lineJumpTimer = _lineJumpTimer;
    if (_positioned && adjusted.top != _position.dy) {
      lineJumpTimer?.cancel();
      // The timer is cancelled in dispose, so the callback is mounted-safe.
      lineJumpTimer = Timer(
        ZamDurationToken.short1.duration,
        () => setState(() => _lineJumpTimer = null),
      );
    }

    setState(() {
      _position = adjusted.topLeft;
      _positioned = true;
      _lineJumpTimer = lineJumpTimer;
      _focalPointAdjustment = Offset(
        focalX - adjusted.center.dx,
        unadjusted.top - adjusted.top,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.iosStyle) {
      final shown = _inOutCurve.value;
      return AnimatedPositioned(
        duration: ZamDurationToken.short1.duration,
        curve: Curves.easeOut,
        left: _position.dx,
        top: _position.dy,
        child: Transform.translate(
          offset: Offset.lerp(
            const Offset(0, -_kIosLensAboveFocalPoint),
            Offset.zero,
            shown,
          )!,
          child: RawMagnifier(
            size: _kIosLensSize,
            focalPointOffset:
                Offset(
                  0,
                  _kIosLensSize.height / 2 - _kIosLensAboveFocalPoint,
                ) +
                _focalPointAdjustment,
            decoration: MagnifierDecoration(
              opacity: shown,
              shape: RoundedRectangleBorder(
                borderRadius: const BorderRadius.all(Radius.elliptical(60, 50)),
                side: BorderSide(color: _zamControlColor(context), width: 2),
              ),
              shadows: const [
                BoxShadow(
                  color: Color.fromARGB(25, 0, 0, 0),
                  blurRadius: 11,
                  spreadRadius: 0.2,
                  blurStyle: BlurStyle.outer,
                ),
              ],
            ),
          ),
        ),
      );
    }

    return AnimatedPositioned(
      left: _position.dx,
      top: _position.dy,
      // The Android lens moves at once, except when it jumps between lines.
      duration: _lineJumpTimer == null
          ? Duration.zero
          : ZamDurationToken.short1.duration,
      child: RawMagnifier(
        size: _kAndroidLensSize,
        magnificationScale: _kAndroidMagnification,
        clipBehavior: Clip.hardEdge,
        focalPointOffset:
            _focalPointAdjustment +
            Offset(
              0,
              _kAndroidLensAboveFocalPoint + _kAndroidLensSize.height / 2,
            ),
        decoration: const MagnifierDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(40)),
          ),
          shadows: [
            BoxShadow(
              blurRadius: 1.5,
              offset: Offset(0, 2),
              spreadRadius: 0.75,
              color: Color.fromARGB(25, 0, 0, 0),
            ),
          ],
        ),
        // A faint film tells the lens apart from the text behind it.
        child: const ColoredBox(color: Color.fromARGB(8, 158, 158, 158)),
      ),
    );
  }
}
