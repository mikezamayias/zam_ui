part of '../shell.dart';

/// How a [ZamPageRoute] enters and leaves the screen.
enum ZamPageTransition {
  /// [slide] on iOS and macOS, [fade] on every other platform.
  platform,

  /// The iOS page transition on every platform.
  ///
  /// The page slides in from the trailing edge over 500 ms while the page
  /// below shifts by a third, and a drag from the leading edge pops the
  /// route interactively. A fullscreen dialog slides up from the bottom
  /// instead and has no back gesture.
  slide,

  /// The Android page transition on every platform.
  ///
  /// The page fades in while it slides a quarter of the width in from the
  /// trailing edge, and the page below fades out while it slides a quarter
  /// towards the leading edge, over 450 ms. It has no back gesture. The
  /// system back button pops the route.
  fade,

  /// No animation: the page appears and disappears at once.
  none,
}
