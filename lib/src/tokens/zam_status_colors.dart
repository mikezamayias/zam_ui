part of '../tokens.dart';

/// Status colors for one brightness, each paired with a readable foreground.
///
/// Read them with `context.zamStatus` for badges, banners, and inline
/// messages; toasts use the same roles.
@immutable
class ZamStatusColors {
  /// Creates a [ZamStatusColors] set.
  const ZamStatusColors({
    required this.success,
    required this.onSuccess,
    required this.warning,
    required this.onWarning,
    required this.info,
    required this.onInfo,
    required this.error,
    required this.onError,
  });

  /// Resolves the status roles of [surface], picking black or white
  /// foregrounds by contrast where [surface] sets none.
  factory ZamStatusColors.of(ZamSurfaceColors surface) {
    return ZamStatusColors(
      success: surface.success,
      onSuccess: ZamColorUtils.readableOn(surface.success),
      warning: surface.warning,
      onWarning: ZamColorUtils.readableOn(surface.warning),
      info: surface.info,
      onInfo: ZamColorUtils.readableOn(surface.info),
      error: surface.destructive,
      onError:
          surface.destructiveForeground ??
          ZamColorUtils.readableOn(surface.destructive),
    );
  }

  /// Success color.
  final Color success;

  /// Text and icon color on [success].
  final Color onSuccess;

  /// Warning color.
  final Color warning;

  /// Text and icon color on [warning].
  final Color onWarning;

  /// Info color.
  final Color info;

  /// Text and icon color on [info].
  final Color onInfo;

  /// Error color, the surface's destructive color.
  final Color error;

  /// Text and icon color on [error].
  final Color onError;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZamStatusColors &&
          other.success == success &&
          other.onSuccess == onSuccess &&
          other.warning == warning &&
          other.onWarning == onWarning &&
          other.info == info &&
          other.onInfo == onInfo &&
          other.error == error &&
          other.onError == onError;

  @override
  int get hashCode => Object.hash(
    success,
    onSuccess,
    warning,
    onWarning,
    info,
    onInfo,
    error,
    onError,
  );
}
