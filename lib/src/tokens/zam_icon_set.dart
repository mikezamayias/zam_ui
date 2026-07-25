part of '../tokens.dart';

/// App-owned icon set mapping semantic roles to host app [IconData].
class ZamIconSet {
  /// Creates a [ZamIconSet] mapping required semantic roles.
  const ZamIconSet({
    required this.info,
    required this.success,
    required this.warning,
    required this.error,
    required this.back,
    required this.chevronRight,
  });

  /// Informational status icon.
  final IconData info;

  /// Success status icon.
  final IconData success;

  /// Warning status icon.
  final IconData warning;

  /// Error status icon.
  final IconData error;

  /// Back navigation icon.
  final IconData back;

  /// Chevron right trailing icon.
  final IconData chevronRight;
}
