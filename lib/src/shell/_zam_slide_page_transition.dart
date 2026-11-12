// Adapted from CupertinoPageTransition and CupertinoFullscreenDialogTransition
// in packages/flutter/lib/src/cupertino/route.dart of Flutter 3.50.0.
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

/// The iOS page transition.
///
/// A page slides in from the trailing edge and shifts a third towards the
/// leading edge while another page covers it. A fullscreen dialog slides up
/// from the bottom instead. Both mirror in right-to-left layouts.
///
/// While a back gesture runs, [linear] is true and the animations follow the
/// finger without curves.
class _ZamSlidePageTransition extends StatefulWidget {
  const _ZamSlidePageTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.fullscreenDialog,
    required this.linear,
    required this.child,
  });

  // From fully off screen at the trailing edge to on screen.
  static final Animatable<Offset> _trailingToMiddle = Tween<Offset>(
    begin: const Offset(1, 0),
    end: Offset.zero,
  );

  // From on screen to a third off screen at the leading edge.
  static final Animatable<Offset> _middleToLeading = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-1 / 3, 0),
  );

  // From fully off screen at the bottom to on screen.
  static final Animatable<Offset> _bottomToMiddle = Tween<Offset>(
    begin: const Offset(0, 1),
    end: Offset.zero,
  );

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final bool fullscreenDialog;
  final bool linear;
  final Widget child;

  @override
  State<_ZamSlidePageTransition> createState() =>
      _ZamSlidePageTransitionState();
}

class _ZamSlidePageTransitionState extends State<_ZamSlidePageTransition> {
  CurvedAnimation? _primaryCurve;
  CurvedAnimation? _secondaryCurve;
  late Animation<Offset> _primaryPosition;
  late Animation<Offset> _secondaryPosition;

  @override
  void initState() {
    super.initState();
    _setUp();
  }

  @override
  void didUpdateWidget(_ZamSlidePageTransition oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.animation != widget.animation ||
        oldWidget.secondaryAnimation != widget.secondaryAnimation ||
        oldWidget.fullscreenDialog != widget.fullscreenDialog ||
        oldWidget.linear != widget.linear) {
      _disposeCurves();
      _setUp();
    }
  }

  @override
  void dispose() {
    _disposeCurves();
    super.dispose();
  }

  void _disposeCurves() {
    _primaryCurve?.dispose();
    _secondaryCurve?.dispose();
    _primaryCurve = null;
    _secondaryCurve = null;
  }

  void _setUp() {
    // A fullscreen dialog has no back gesture, so its entrance always eases.
    if (widget.fullscreenDialog) {
      _primaryCurve = CurvedAnimation(
        parent: widget.animation,
        curve: Curves.linearToEaseOut,
        // Flipped so that the exit does not ease in, which iOS does not do.
        reverseCurve: Curves.linearToEaseOut.flipped,
      );
    } else if (!widget.linear) {
      _primaryCurve = CurvedAnimation(
        parent: widget.animation,
        curve: Curves.fastEaseInToSlowEaseOut,
        reverseCurve: Curves.fastEaseInToSlowEaseOut.flipped,
      );
    }
    if (!widget.linear) {
      _secondaryCurve = CurvedAnimation(
        parent: widget.secondaryAnimation,
        curve: Curves.linearToEaseOut,
        reverseCurve: Curves.easeInToLinear,
      );
    }
    _primaryPosition = (_primaryCurve ?? widget.animation).drive(
      widget.fullscreenDialog
          ? _ZamSlidePageTransition._bottomToMiddle
          : _ZamSlidePageTransition._trailingToMiddle,
    );
    _secondaryPosition = (_secondaryCurve ?? widget.secondaryAnimation).drive(
      _ZamSlidePageTransition._middleToLeading,
    );
  }

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    return SlideTransition(
      position: _secondaryPosition,
      textDirection: textDirection,
      transformHitTests: false,
      child: SlideTransition(
        position: _primaryPosition,
        textDirection: textDirection,
        child: widget.child,
      ),
    );
  }
}
