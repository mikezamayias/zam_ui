// The positioning rules and the lens styles are adapted from Flutter's
// material/magnifier.dart (Android) and cupertino/magnifier.dart (iOS).
//
// Copyright 2014 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

part of '../text.dart';

// iOS lens size, and how far the lens bottom sits below the focal point.
const Size _kIosLensSize = Size(80, 47.5);
const double _kIosLensAboveFocalPoint = -26;
// iOS hides the lens once the finger is this far below the line.
const double _kIosHideBelowThreshold = 48;
// iOS lets the lens follow a downward drag at a tenth of the distance.
const double _kIosDragResistance = 10;
const double _kIosScreenEdgePadding = 10;

// Android lens size, its distance above the focal point and its zoom.
const Size _kAndroidLensSize = Size(77.37, 37.9);
const double _kAndroidLensAboveFocalPoint = 22;
const double _kAndroidMagnification = 1.25;

// The magnifier for a text drag on iOS and Android, or null elsewhere.
//
// The platform is read when the field builds, so a test that overrides
// `debugDefaultTargetPlatformOverride` gets the matching lens.
TextMagnifierConfiguration _zamMagnifierConfiguration() {
  return TextMagnifierConfiguration(
    shouldDisplayHandlesInMagnifier:
        defaultTargetPlatform == TargetPlatform.iOS,
    magnifierBuilder: (context, controller, magnifierInfo) =>
        switch (defaultTargetPlatform) {
          TargetPlatform.iOS => _ZamTextMagnifier(
            controller: controller,
            magnifierInfo: magnifierInfo,
            iosStyle: true,
          ),
          TargetPlatform.android => _ZamTextMagnifier(
            controller: controller,
            magnifierInfo: magnifierInfo,
            iosStyle: false,
          ),
          TargetPlatform.fuchsia ||
          TargetPlatform.linux ||
          TargetPlatform.macOS ||
          TargetPlatform.windows => null,
        },
  );
}

// A [RawMagnifier] that follows a text drag by the platform's rules.
//
// iOS: a bordered pill that tracks the finger, fades in and out, and hides
// when the finger moves well below the line. Android: a rounded lens that
// stays on the touched line, zooms by a quarter, and jumps between lines.
class _ZamTextMagnifier extends StatefulWidget {
  const _ZamTextMagnifier({
    required this.controller,
    required this.magnifierInfo,
    required this.iosStyle,
  });

  final MagnifierController controller;
  final ValueNotifier<MagnifierInfo> magnifierInfo;
  final bool iosStyle;

  @override
  State<_ZamTextMagnifier> createState() => _ZamTextMagnifierState();
}
