// Adapted from FadeForwardsPageTransitionsBuilder in
// packages/flutter/lib/src/material/page_transitions_theme.dart of
// Flutter 3.50.0.
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

/// The Android page transition, as Material's `FadeForwardsPageTransitionsBuilder`
/// draws it on Android 14 and later.
///
/// The incoming page fades in while it slides a quarter of the width in from
/// the trailing edge. The page below fades out while it slides a quarter
/// towards the leading edge, over [backgroundColor] so the gap between the two
/// is never black. Both mirror in right-to-left layouts.
class _ZamFadePageTransition extends StatelessWidget {
  const _ZamFadePageTransition({
    required this.animation,
    required this.secondaryAnimation,
    required this.backgroundColor,
    required this.child,
  });

  static const Curve _curve = Curves.easeInOutCubicEmphasized;

  // The incoming page slides in from the trailing edge.
  static final Animatable<Offset> _enterOffset = Tween<Offset>(
    begin: const Offset(0.25, 0),
    end: Offset.zero,
  ).chain(CurveTween(curve: _curve));

  // The popped page slides back towards the trailing edge.
  static final Animatable<Offset> _exitOffset = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0.25, 0),
  ).chain(CurveTween(curve: _curve));

  // The covered page slides towards the leading edge.
  static final Animatable<Offset> _coverOffset = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(-0.25, 0),
  ).chain(CurveTween(curve: _curve));

  // The uncovered page slides back from the leading edge.
  static final Animatable<Offset> _uncoverOffset = Tween<Offset>(
    begin: const Offset(-0.25, 0),
    end: Offset.zero,
  ).chain(CurveTween(curve: _curve));

  static final Animatable<double> _fadeIn = Tween<double>(
    begin: 0,
    end: 1,
  ).chain(CurveTween(curve: const Interval(0, 0.75)));

  static final Animatable<double> _fadeOut = Tween<double>(
    begin: 1,
    end: 0,
  ).chain(CurveTween(curve: const Interval(0, 0.25)));

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Color backgroundColor;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);

    Widget fadeSlide(
      Animation<double> animation,
      Animatable<double> opacity,
      Animatable<Offset> offset,
      Widget? child,
    ) => FadeTransition(
      opacity: opacity.animate(animation),
      child: SlideTransition(
        position: offset.animate(animation),
        textDirection: textDirection,
        child: child,
      ),
    );

    // How this page moves while another page covers and uncovers it.
    final covered = ColoredBox(
      color: secondaryAnimation.isAnimating
          ? backgroundColor
          : ZamColorUtils.transparent,
      child: DualTransitionBuilder(
        animation: ReverseAnimation(secondaryAnimation),
        forwardBuilder: (context, animation, child) =>
            fadeSlide(animation, _fadeIn, _uncoverOffset, child),
        reverseBuilder: (context, animation, child) =>
            fadeSlide(animation, _fadeOut, _coverOffset, child),
        child: child,
      ),
    );

    // How this page enters and leaves.
    return DualTransitionBuilder(
      animation: animation,
      forwardBuilder: (context, animation, child) =>
          fadeSlide(animation, _fadeIn, _enterOffset, child),
      reverseBuilder: (context, animation, child) => IgnorePointer(
        ignoring: animation.status == AnimationStatus.forward,
        child: fadeSlide(animation, _fadeOut, _exitOffset, child),
      ),
      child: covered,
    );
  }
}
