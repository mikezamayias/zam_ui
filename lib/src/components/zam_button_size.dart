part of '../components.dart';

/// Button size scale enum (small, medium, large).
enum ZamButtonSize {
  /// Small button size.
  small,

  /// Medium button size.
  medium,

  /// Large button size.
  large,

  /// Alias for [small].
  // Kept working for one more breaking release before removal.
  // ignore: remove_deprecations_in_breaking_versions
  @Deprecated('Use ZamButtonSize.small')
  sm,

  /// Alias for [medium].
  // Kept working for one more breaking release before removal.
  // ignore: remove_deprecations_in_breaking_versions
  @Deprecated('Use ZamButtonSize.medium')
  regular,

  /// Alias for [large].
  // Kept working for one more breaking release before removal.
  // ignore: remove_deprecations_in_breaking_versions
  @Deprecated('Use ZamButtonSize.large')
  lg,
}
