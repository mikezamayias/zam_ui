// The handle shapes, sizes and anchors are adapted from Flutter's
// material/text_selection.dart and cupertino/text_selection.dart.
//
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../text.dart';

// The diameter of the Android teardrop handle.
const double _kAndroidHandleSize = 22;

// The radius of the ball on the iOS handle.
const double _kIosHandleRadius = 6;

// How far the iOS handle's bar overlaps its ball.
const double _kIosHandleOverlap = 1.5;

/// Text selection handles in the platform's shape, drawn in the theme's
/// `primaryControl` color.
///
/// On iOS and macOS the handles are a bar with a ball, as in UIKit. On every
/// other platform they are the Android teardrop. The color is
/// [ZamPalette.primaryControl] for the active brightness.
///
/// These controls draw handles only. The edit menu comes from the
/// `contextMenuBuilder` of the [EditableText] or [SelectableRegion] that uses
/// them, which [ZamTextField] and [ZamSelectionArea] set.
class ZamTextSelectionControls extends TextSelectionControls
    with TextSelectionHandleControls {
  /// Creates the handle controls.
  ZamTextSelectionControls();

  static bool get _iosStyle => switch (defaultTargetPlatform) {
    TargetPlatform.iOS || TargetPlatform.macOS => true,
    TargetPlatform.android ||
    TargetPlatform.fuchsia ||
    TargetPlatform.linux ||
    TargetPlatform.windows => false,
  };

  @override
  Size getHandleSize(double textLineHeight) {
    if (_iosStyle) {
      return Size(
        _kIosHandleRadius * 2,
        textLineHeight + _kIosHandleRadius * 2 - _kIosHandleOverlap,
      );
    }
    return const Size.square(_kAndroidHandleSize);
  }

  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) {
    final color = _zamControlColor(context);
    final size = getHandleSize(textLineHeight);
    if (_iosStyle) {
      // iOS handles do not respond to taps.
      final handle = SizedBox.fromSize(
        size: size,
        child: CustomPaint(painter: _ZamIosHandlePainter(color)),
      );
      return switch (type) {
        TextSelectionHandleType.left => handle,
        // The end handle is the start handle turned upside down.
        TextSelectionHandleType.right => Transform.rotate(
          angle: math.pi,
          child: handle,
        ),
        // A collapsed caret has no visible handle on iOS, but the invisible
        // box still receives the drag that moves the caret.
        TextSelectionHandleType.collapsed => SizedBox.fromSize(size: size),
      };
    }

    final handle = SizedBox.fromSize(
      size: size,
      child: CustomPaint(
        painter: _ZamAndroidHandlePainter(color),
        child: GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
        ),
      ),
    );
    // The painted teardrop points to the top left. Each type rotates it to
    // point at the selection edge it marks.
    return switch (type) {
      TextSelectionHandleType.left => Transform.rotate(
        angle: math.pi / 2,
        child: handle,
      ),
      TextSelectionHandleType.right => handle,
      TextSelectionHandleType.collapsed => Transform.rotate(
        angle: math.pi / 4,
        child: handle,
      ),
    };
  }

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    final size = getHandleSize(textLineHeight);
    if (_iosStyle) {
      return switch (type) {
        // The ball is on top and the anchor is at the bottom of the line.
        TextSelectionHandleType.left => Offset(size.width / 2, size.height),
        // The end handle is flipped, so the anchor sits near the ball's top.
        TextSelectionHandleType.right => Offset(
          size.width / 2,
          size.height - 2 * _kIosHandleRadius + _kIosHandleOverlap,
        ),
        TextSelectionHandleType.collapsed => Offset(
          size.width / 2,
          textLineHeight + (size.height - textLineHeight) / 2,
        ),
      };
    }
    return switch (type) {
      TextSelectionHandleType.collapsed => const Offset(
        _kAndroidHandleSize / 2,
        -4,
      ),
      TextSelectionHandleType.left => const Offset(_kAndroidHandleSize, 0),
      TextSelectionHandleType.right => Offset.zero,
    };
  }
}

// The theme's `primaryControl` role for [context], or the fallback theme's
// when no ZamTheme is above it.
Color _zamControlColor(BuildContext context) {
  final theme = ZamTheme.maybeOf(context) ?? ZamThemeData.fallback();
  final brightness =
      ShadTheme.maybeOf(context)?.brightness ??
      MediaQuery.maybePlatformBrightnessOf(context) ??
      Brightness.light;
  return theme.palette(brightness).primaryControl;
}

// One shared instance, since the controls hold no state.
final ZamTextSelectionControls _zamTextSelectionControls =
    ZamTextSelectionControls();
