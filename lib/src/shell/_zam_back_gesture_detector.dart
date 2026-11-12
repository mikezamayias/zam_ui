// Adapted from _CupertinoBackGestureDetector in
// packages/flutter/lib/src/cupertino/route.dart of Flutter 3.50.0.
//
// Copyright 2014 The Flutter Authors. All rights reserved.
//
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//
//     * Redistributions of source code must retain the above copyright
//       notice, this list of conditions and the following disclaimer.
//     * Redistributions in binary form must reproduce the above
//       copyright notice, this list of conditions and the following
//       disclaimer in the documentation and/or other materials provided
//       with the distribution.
//     * Neither the name of Google Inc. nor the names of its
//       contributors may be used to endorse or promote products derived
//       from this software without specific prior written permission.
//
// THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
// AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
// IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
// ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
// LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
// CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
// SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
// INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
// CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
// ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
// POSSIBILITY OF SUCH DAMAGE.

part of '../shell.dart';

/// Recognizes a horizontal drag that starts at the leading edge of a page
/// and feeds it to a [_ZamBackGestureController], which drives the route.
///
/// The edge strip is 20 logical pixels wide, or the leading safe area padding
/// when that is wider. Drag values are converted to logical coordinates, so
/// the gesture mirrors in right-to-left layouts.
class _ZamBackGestureDetector<T> extends StatefulWidget {
  const _ZamBackGestureDetector({
    required this.enabledCallback,
    required this.onStartPopGesture,
    required this.child,
  });

  static const double _edgeWidth = 20;

  final ValueGetter<bool> enabledCallback;
  final ValueGetter<_ZamBackGestureController<T>> onStartPopGesture;
  final Widget child;

  @override
  State<_ZamBackGestureDetector<T>> createState() =>
      _ZamBackGestureDetectorState<T>();
}

class _ZamBackGestureDetectorState<T>
    extends State<_ZamBackGestureDetector<T>> {
  _ZamBackGestureController<T>? _controller;
  late final HorizontalDragGestureRecognizer _recognizer =
      HorizontalDragGestureRecognizer(debugOwner: this)
        ..onStart = _handleDragStart
        ..onUpdate = _handleDragUpdate
        ..onEnd = _handleDragEnd
        ..onCancel = _handleDragCancel;

  @override
  void dispose() {
    _recognizer.dispose();
    // A page disposed mid-drag still owes the navigator the end of the
    // gesture it started.
    final controller = _controller;
    if (controller != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (controller.navigator.mounted) {
          controller.navigator.didStopUserGesture();
        }
      });
      _controller = null;
    }
    super.dispose();
  }

  void _handleDragStart(DragStartDetails details) {
    assert(_controller == null, 'A back gesture is already running.');
    _controller = widget.onStartPopGesture();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    _controller?.dragUpdate(
      _toLogical(details.primaryDelta! / context.size!.width),
    );
  }

  void _handleDragEnd(DragEndDetails details) {
    _controller?.dragEnd(
      _toLogical(details.velocity.pixelsPerSecond.dx / context.size!.width),
    );
    _controller = null;
  }

  void _handleDragCancel() {
    // Called even when no drag started, paired with the pointer down.
    _controller?.dragEnd(0);
    _controller = null;
  }

  void _handlePointerDown(PointerDownEvent event) {
    if (widget.enabledCallback()) {
      _recognizer.addPointer(event);
    }
  }

  double _toLogical(double value) => switch (Directionality.of(context)) {
    TextDirection.rtl => -value,
    TextDirection.ltr => value,
  };

  @override
  Widget build(BuildContext context) {
    // On devices with a notch the strip widens to the notch side's padding.
    final padding = MediaQuery.paddingOf(context);
    final safeWidth = switch (Directionality.of(context)) {
      TextDirection.rtl => padding.right,
      TextDirection.ltr => padding.left,
    };
    return Stack(
      fit: StackFit.passthrough,
      children: [
        widget.child,
        PositionedDirectional(
          start: 0,
          width: math.max(safeWidth, _ZamBackGestureDetector._edgeWidth),
          top: 0,
          bottom: 0,
          child: Listener(
            onPointerDown: _handlePointerDown,
            behavior: HitTestBehavior.translucent,
          ),
        ),
      ],
    );
  }
}
