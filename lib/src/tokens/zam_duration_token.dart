part of '../tokens.dart';

enum ZamDurationToken {
  short1(Duration(milliseconds: 50)),
  short2(Duration(milliseconds: 100)),
  short3(Duration(milliseconds: 150)),
  short4(Duration(milliseconds: 200)),
  medium1(Duration(milliseconds: 250)),
  medium2(Duration(milliseconds: 300)),
  medium3(Duration(milliseconds: 350)),
  medium4(Duration(milliseconds: 400)),
  long1(Duration(milliseconds: 450)),
  long2(Duration(milliseconds: 500)),
  long3(Duration(milliseconds: 550)),
  long4(Duration(milliseconds: 600));

  const ZamDurationToken(this.duration);
  final Duration duration;
}
