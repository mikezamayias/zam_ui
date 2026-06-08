part of '../components.dart';

class ZamSkeleton extends StatefulWidget {
  const ZamSkeleton({
    required this.child,
    super.key,
    this.isLoading = true,
  });

  final Widget child;
  final bool isLoading;

  @override
  State<ZamSkeleton> createState() => _ZamSkeletonState();
}
