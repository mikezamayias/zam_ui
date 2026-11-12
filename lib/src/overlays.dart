import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/src/utils.dart';

/// Displays a modal side sheet configured with tokenized barrier overlay defaults.
Future<T?> showZamSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  ShadSheetSide? side,
  Color? backgroundColor,
  String barrierLabel = '',
  ShapeBorder? shape,
  Color barrierColor = ZamColorUtils.barrier,
  bool useRootNavigator = false,
  bool isDismissible = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  List<Effect<dynamic>>? animateIn,
  List<Effect<dynamic>>? animateOut,
}) {
  return showShadSheet<T>(
    context: context,
    builder: builder,
    side: side,
    backgroundColor: backgroundColor,
    shape: shape,
    isDismissible: isDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    animateIn: animateIn,
    animateOut: animateOut,
  );
}

/// Displays a raw modal dialog configured with tokenized barrier overlay defaults.
Future<T?> showZamDialog<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool barrierDismissible = true,
  Color barrierColor = ZamColorUtils.barrier,
  String barrierLabel = '',
  bool useRootNavigator = true,
  RouteSettings? routeSettings,
  Offset? anchorPoint,
  List<Effect<dynamic>>? animateIn,
  List<Effect<dynamic>>? animateOut,
  ShadDialogVariant variant = ShadDialogVariant.primary,
}) {
  return showShadDialog<T>(
    context: context,
    builder: builder,
    barrierDismissible: barrierDismissible,
    barrierColor: barrierColor,
    barrierLabel: barrierLabel,
    useRootNavigator: useRootNavigator,
    routeSettings: routeSettings,
    anchorPoint: anchorPoint,
    animateIn: animateIn,
    animateOut: animateOut,
    variant: variant,
  );
}
