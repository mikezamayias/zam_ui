import 'dart:async';
import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/semantics.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/src/theme.dart';
import 'package:zam_ui/src/tokens.dart';
import 'package:zam_ui/src/utils.dart';

part 'overlays/_zam_overlay_route.dart';
part 'overlays/_zam_overlay_surface.dart';
part 'overlays/_zam_route_scope.dart';
part 'overlays/_zam_route_scope_data.dart';
part 'overlays/_zam_sheet_frame.dart';
part 'overlays/_zam_sheet_handle.dart';
part 'overlays/_zam_tooltip_trigger.dart';
part 'overlays/zam_dialog_surface.dart';
part 'overlays/zam_sheet_side.dart';
part 'overlays/zam_toaster.dart';
part 'overlays/zam_tooltip.dart';

/// Displays a modal dialog above the current route.
///
/// [builder] returns the dialog, usually a [ZamDialogSurface]. The dialog
/// fades in and out, and the barrier is a plain scrim unless
/// [barrierBlurSigma] is above zero.
///
/// A barrier tap dismisses the dialog when [barrierDismissible] is true, and
/// so does the system back action. The returned future completes with the
/// value passed to `Navigator.pop`, or with null when the dialog was
/// dismissed. The route announces itself to screen readers, keeps focus
/// inside the dialog and restores focus to the previous widget when it
/// closes.
///
/// [barrierLabel] is the accessibility label of the barrier and defaults to
/// shad's localized "Dismiss". [useRootNavigator] pushes the dialog onto the
/// root navigator.
Future<T?> showZamDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color barrierColor = ZamColorUtils.barrier,
  String? barrierLabel,
  double barrierBlurSigma = 0,
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
}) {
  assert(barrierBlurSigma >= 0, 'barrierBlurSigma must not be negative.');
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final scope = _ZamRouteScopeData.capture(context, navigator.context);
  final duration = ZamDurationToken.short4.duration;

  return navigator.push<T>(
    _ZamOverlayRoute<T>(
      settings: routeSettings,
      barrierDismissible: barrierDismissible,
      barrierColor: barrierColor,
      barrierLabel:
          barrierLabel ?? ShadLocalizations.of(context).dialog.dismiss,
      transitionDuration: duration,
      reverseTransitionDuration: duration,
      filter: barrierBlurSigma > 0
          ? ui.ImageFilter.blur(
              sigmaX: barrierBlurSigma,
              sigmaY: barrierBlurSigma,
            )
          : null,
      pageBuilder: (routeContext) => _ZamRouteScope(
        data: scope,
        child: SafeArea(child: Builder(builder: builder)),
      ),
      transitionBuilder: (context, animation, secondaryAnimation, child) =>
          FadeTransition(opacity: animation, child: child),
    ),
  );
}

/// Displays a modal sheet that slides in from [side].
///
/// [builder] returns the sheet content only. The sheet draws its own frame:
/// the [backgroundColor] (default: the card color), a border in [borderColor]
/// (default: the border color), rounded corners on the edges that face the
/// screen ([radius] replaces them), an optional drag handle, and padding for
/// the safe area and the keyboard.
///
/// A swipe toward the edge, a barrier tap and the system back action all
/// complete the returned future with null. Set [isDismissible] to false to
/// ignore barrier taps, and [enableDrag] to false to ignore swipes. A
/// scrollable inside the sheet takes the drags that start on it.
///
/// [maxHeightFraction] caps the height of top and bottom sheets as a share of
/// the available height. Left and right sheets fill the height and take at
/// most three quarters of the width.
///
/// With [showDragHandle] a top or bottom sheet shows a handle that screen
/// readers expose as a dismiss button. [useSafeArea] keeps the sheet out of
/// the system bars. [barrierLabel] defaults to shad's localized "Dismiss".
/// When the system asks to reduce motion, the sheet fades instead of sliding.
Future<T?> showZamSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  ZamSheetSide side = ZamSheetSide.bottom,
  Color? backgroundColor,
  Color? borderColor,
  BorderRadiusGeometry? radius,
  Color barrierColor = ZamColorUtils.barrier,
  String? barrierLabel,
  bool isDismissible = true,
  bool enableDrag = true,
  bool showDragHandle = false,
  bool useSafeArea = true,
  double maxHeightFraction = 0.9,
  bool useRootNavigator = false,
  RouteSettings? routeSettings,
}) {
  assert(
    maxHeightFraction > 0 && maxHeightFraction <= 1,
    'maxHeightFraction must be in (0, 1].',
  );
  assert(
    !showDragHandle || enableDrag,
    'A drag handle needs enableDrag to be true.',
  );
  final navigator = Navigator.of(context, rootNavigator: useRootNavigator);
  final scope = _ZamRouteScopeData.capture(context, navigator.context);
  final motion = context.zam.motion;
  final label = barrierLabel ?? ShadLocalizations.of(context).dialog.dismiss;
  final enter = motion.emphasizedDecelerated;
  final exit = motion.emphasizedAccelerated;

  // The frame slides itself, because a drag has to move it without the curve.
  return navigator.push<T>(
    _ZamOverlayRoute<T>(
      settings: routeSettings,
      barrierDismissible: isDismissible,
      barrierColor: barrierColor,
      barrierLabel: label,
      transitionDuration: enter.duration,
      reverseTransitionDuration: exit.duration,
      pageBuilder: (routeContext) => _ZamRouteScope(
        data: scope,
        child: _ZamSheetFrame(
          side: side,
          backgroundColor: backgroundColor,
          borderColor: borderColor,
          radius: radius,
          dismissLabel: label,
          enterCurve: enter.curve,
          exitCurve: exit.curve,
          enableDrag: enableDrag,
          showDragHandle: showDragHandle,
          useSafeArea: useSafeArea,
          maxHeightFraction: maxHeightFraction,
          child: Builder(builder: builder),
        ),
      ),
    ),
  );
}
