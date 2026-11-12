// Adapted from _CupertinoBackGestureController in
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

/// Drives a route's animation controller from a back gesture.
///
/// It works in logical coordinates: 0 is the page dismissed and 1 is the page
/// on top. It brackets the gesture with [NavigatorState.didStartUserGesture]
/// and [NavigatorState.didStopUserGesture], so the route's transition runs
/// linearly under the finger.
class _ZamBackGestureController<T> {
  _ZamBackGestureController({
    required this.navigator,
    required this.controller,
    required this.getIsActive,
    required this.getIsCurrent,
  }) {
    navigator.didStartUserGesture();
  }

  /// A release at or above this speed, in page widths per second, decides
  /// the direction regardless of how far the page was dragged.
  static const double _minFlingVelocity = 1;

  final NavigatorState navigator;
  final AnimationController controller;
  final ValueGetter<bool> getIsActive;
  final ValueGetter<bool> getIsCurrent;

  /// Moves the page by [delta], a fraction of the page width.
  void dragUpdate(double delta) {
    controller.value -= delta;
  }

  /// Settles the page after release with [velocity] in page widths per
  /// second: back on top, or popped.
  void dragEnd(double velocity) {
    const Curve curve = Curves.fastEaseInToSlowEaseOut;
    final duration = ZamDurationToken.medium3.duration;
    final isCurrent = getIsCurrent();
    final bool animateForward;

    if (!isCurrent) {
      // The route was already navigated away from, for example by a pop
      // during a slow drag, so it follows its place in the stack.
      animateForward = getIsActive();
    } else if (velocity.abs() >= _minFlingVelocity) {
      animateForward = velocity <= 0;
    } else {
      animateForward = controller.value > 0.5;
    }

    if (animateForward) {
      controller.animateTo(1, duration: duration, curve: curve);
    } else {
      if (isCurrent) {
        navigator.pop();
      }
      // The pop may already have finished if the page was at the end.
      if (controller.isAnimating) {
        controller.animateBack(0, duration: duration, curve: curve);
      }
    }

    if (controller.isAnimating) {
      // Keep the gesture flag set until the page settles, so the transition
      // does not switch back to its curves mid-flight.
      late AnimationStatusListener onStatus;
      onStatus = (status) {
        navigator.didStopUserGesture();
        controller.removeStatusListener(onStatus);
      };
      controller.addStatusListener(onStatus);
    } else {
      navigator.didStopUserGesture();
    }
  }
}
