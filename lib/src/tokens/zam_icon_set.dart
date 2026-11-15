part of '../tokens.dart';

/// App-owned icon set mapping semantic roles to host app [IconData].
class ZamIconSet {
  /// Creates a [ZamIconSet] mapping required semantic roles.
  ///
  /// [search] and [clear] are optional, so an app that sets only the
  /// required roles still compiles. Components that use them fall back as
  /// their own documentation describes.
  const ZamIconSet({
    required this.info,
    required this.success,
    required this.warning,
    required this.error,
    required this.back,
    required this.chevronRight,
    this.search,
    this.clear,
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

  /// Search icon, such as a magnifying glass, or null for none.
  ///
  /// When null, `ZamSearchField` shows no leading icon.
  final IconData? search;

  /// Clear icon, such as a cross, for a button that empties an input, or
  /// null for none.
  ///
  /// When null, `ZamSearchField` draws a plain cross instead.
  final IconData? clear;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ZamIconSet &&
          other.info == info &&
          other.success == success &&
          other.warning == warning &&
          other.error == error &&
          other.back == back &&
          other.chevronRight == chevronRight &&
          other.search == search &&
          other.clear == clear;

  @override
  int get hashCode => Object.hashAll([
    info,
    success,
    warning,
    error,
    back,
    chevronRight,
    search,
    clear,
  ]);
}
