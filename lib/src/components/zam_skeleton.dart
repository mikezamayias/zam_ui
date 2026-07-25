part of '../components.dart';

/// Skeleton shimmer loading placeholder component.
class ZamSkeleton extends StatefulWidget {
  /// Creates a [ZamSkeleton].
  const ZamSkeleton({
    required this.child,
    super.key,
    this.isLoading = true,
  });

  /// Child widget placeholder layout to mask with shimmer.
  final Widget child;

  /// Whether the skeleton loading animation is active.
  final bool isLoading;

  @override
  State<ZamSkeleton> createState() => _ZamSkeletonState();
}
