part of '../components.dart';

class _ZamSkeletonState extends State<ZamSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_initialized) return;
    _controller = AnimationController(
      vsync: this,
      duration: context.zam.motion.shimmer,
    )..repeat();
    _animation = Tween<double>(begin: -1, end: 2).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutSine),
    );
    _initialized = true;
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
