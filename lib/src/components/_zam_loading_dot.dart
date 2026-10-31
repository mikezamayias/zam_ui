part of '../components.dart';

class _ZamLoadingDot extends StatefulWidget {
  const _ZamLoadingDot();

  @override
  State<_ZamLoadingDot> createState() => _ZamLoadingDotState();
}

class _ZamLoadingDotState extends State<_ZamLoadingDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(vsync: this);

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final motion = context.zam.motion.standard;
    _controller.duration = motion.duration;
    if (MediaQuery.disableAnimationsOf(context)) {
      _controller.stop();
    } else if (!_controller.isAnimating) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = ShadTheme.of(context).colorScheme;
    final theme = context.zam;
    final motion = theme.motion.standard;
    final color = IconTheme.of(context).color ?? scheme.foreground;
    final opacity = Tween<double>(
      begin: theme.opacities.secondary,
      end: theme.opacities.visible,
    ).animate(CurvedAnimation(parent: _controller, curve: motion.curve));
    return FadeTransition(
      opacity: opacity,
      child: SizedBox(
        width: theme.spacing(3),
        height: theme.spacing(3),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: color,
            borderRadius: theme.radius.pill,
          ),
        ),
      ),
    );
  }
}
