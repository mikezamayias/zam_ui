part of '../tokens.dart';

/// Animation duration tokens ranging from short (50ms) to long (600ms).
enum ZamDurationToken {
  /// 50ms duration.
  short1(Duration(milliseconds: 50)),

  /// 100ms duration.
  short2(Duration(milliseconds: 100)),

  /// 150ms duration.
  short3(Duration(milliseconds: 150)),

  /// 200ms duration.
  short4(Duration(milliseconds: 200)),

  /// 250ms duration.
  medium1(Duration(milliseconds: 250)),

  /// 300ms duration.
  medium2(Duration(milliseconds: 300)),

  /// 350ms duration.
  medium3(Duration(milliseconds: 350)),

  /// 400ms duration.
  medium4(Duration(milliseconds: 400)),

  /// 450ms duration.
  long1(Duration(milliseconds: 450)),

  /// 500ms duration.
  long2(Duration(milliseconds: 500)),

  /// 550ms duration.
  long3(Duration(milliseconds: 550)),

  /// 600ms duration.
  long4(Duration(milliseconds: 600));

  const ZamDurationToken(this.duration);

  /// Underlying [Duration] value.
  final Duration duration;
}
