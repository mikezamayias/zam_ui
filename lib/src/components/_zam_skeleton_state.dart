part of '../components.dart';

class _ZamSkeletonState extends State<ZamSkeleton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
  );
  late final Animation<double> _animation = Tween<double>(begin: -1, end: 2)
      .animate(
        CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
      );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _controller.duration = context.zam.motion.shimmer;
    _syncAnimation();
  }

  @override
  void didUpdateWidget(ZamSkeleton oldWidget) {
    super.didUpdateWidget(oldWidget);
    _syncAnimation();
  }

  // Runs the shimmer only while loading and while the platform allows
  // animations, so an idle or reduced-motion skeleton schedules no frames.
  void _syncAnimation() {
    final animate =
        widget.isLoading && !MediaQuery.disableAnimationsOf(context);
    if (animate && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!animate && _controller.isAnimating) {
      _controller
        ..stop()
        ..value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) return widget.child;
    final scheme = ShadTheme.of(context).colorScheme;
    final theme = context.zam;

    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              colors: [
                scheme.muted,
                scheme.muted.withValues(alpha: theme.opacities.disabled),
                scheme.muted,
              ],
              stops: const [0, 0.5, 1],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              transform: _ZamSlidingGradientTransform(_animation.value),
            ).createShader(bounds);
          },
          blendMode: BlendMode.srcIn,
          child: widget.child,
        );
      },
    );
  }
}
