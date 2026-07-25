import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/src/theme.dart';
import 'package:zam_ui/src/utils.dart';

part 'components/zam_button_variant.dart';
part 'components/zam_button_size.dart';
part 'components/zam_screen.dart';
part 'components/zam_screen_header.dart';
part 'components/zam_section_header.dart';
part 'components/zam_surface.dart';
part 'components/zam_empty_state.dart';
part 'components/zam_stat_tile.dart';
part 'components/zam_filter_pill.dart';
part 'components/zam_button.dart';
part 'components/zam_icon_button.dart';
part 'components/zam_dialog.dart';
part 'components/zam_toast_content.dart';
part 'components/zam_toast.dart';
part 'components/zam_skeleton.dart';
part 'components/_zam_skeleton_state.dart';
part 'components/_zam_sliding_gradient_transform.dart';
part 'components/_zam_loading_dot.dart';

typedef ZamBadge = ShadBadge;
typedef ZamBorder = ShadBorder;
typedef ZamCalendar = ShadCalendar;
typedef ZamCard = ShadCard;
typedef ZamCheckbox = ShadCheckbox;
typedef ZamColorScheme = ShadColorScheme;
typedef ZamDecoration = ShadDecoration;
typedef ZamInput = ShadInput;
typedef ZamInputOTP = ShadInputOTP;
typedef ZamInputOTPGroup = ShadInputOTPGroup;
typedef ZamInputOTPSlot = ShadInputOTPSlot;
typedef ZamProgress = ShadProgress;
typedef ZamRadio<T> = ShadRadio<T>;
typedef ZamSheet = ShadSheet;
typedef ZamSheetSide = ShadSheetSide;
typedef ZamSlider = ShadSlider;
typedef ZamSliderController = ShadSliderController;
typedef ZamSonner = ShadSonner;
typedef ZamSwitch = ShadSwitch;
typedef ZamTab<T> = ShadTab<T>;
typedef ZamTabs<T> = ShadTabs<T>;
typedef ZamTextTheme = ShadTextTheme;
typedef ZamTooltip = ShadTooltip;
typedef ZamRawDialog = ShadDialog;
typedef ZamDialogVariant = ShadDialogVariant;

Future<T?> showZamSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  ZamSheetSide? side,
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
  ZamDialogVariant variant = ZamDialogVariant.primary,
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
