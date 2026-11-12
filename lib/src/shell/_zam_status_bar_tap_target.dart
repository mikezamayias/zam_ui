part of '../shell.dart';

/// Covers the status bar area of a [ZamScaffold] and scrolls the route's
/// [PrimaryScrollController] to the top when the user taps the status bar.
///
/// iOS reports the tap to every [WidgetsBindingObserver]. Only the scaffold
/// whose status bar area is hit-testable at the origin, which is the one in
/// the foreground, reacts, as Material's `Scaffold` does.
class _ZamStatusBarTapTarget extends StatefulWidget {
  const _ZamStatusBarTapTarget();

  @override
  State<_ZamStatusBarTapTarget> createState() => _ZamStatusBarTapTargetState();
}

class _ZamStatusBarTapTargetState extends State<_ZamStatusBarTapTarget>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void handleStatusBarTap() {
    final controller = PrimaryScrollController.maybeOf(context);
    if (controller == null || !controller.hasClients || !_isInForeground()) {
      return;
    }
    controller.animateTo(
      0,
      // 1000 ms, as Material's Scaffold.
      duration: ZamDurationToken.long2.duration * 2,
      curve: Curves.easeOutCirc,
    );
  }

  bool _isInForeground() {
    final target = context.findRenderObject();
    final result = HitTestResult();
    WidgetsBinding.instance.hitTestInView(
      result,
      Offset.zero,
      View.of(context).viewId,
    );
    return result.path.any((entry) => entry.target == target);
  }

  @override
  Widget build(BuildContext context) {
    return const MetaData(
      behavior: HitTestBehavior.translucent,
      child: SizedBox.expand(),
    );
  }
}
