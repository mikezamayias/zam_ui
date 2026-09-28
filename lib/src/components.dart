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
part 'components/zam_button_style.dart';
part 'components/zam_icon_button.dart';
part 'components/zam_dialog.dart';
part 'components/zam_toast_content.dart';
part 'components/zam_toast.dart';
part 'components/zam_skeleton.dart';
part 'components/_zam_skeleton_state.dart';
part 'components/_zam_sliding_gradient_transform.dart';
part 'components/_zam_loading_dot.dart';
part 'components/zam_divider.dart';
part 'components/zam_list_tile.dart';
part 'components/zam_form_field.dart';

/// Type alias for shadcn badge component.
typedef ZamBadge = ShadBadge;

/// Type alias for shadcn border component.
typedef ZamBorder = ShadBorder;

/// Type alias for shadcn calendar component.
typedef ZamCalendar = ShadCalendar;

/// Type alias for shadcn card component.
typedef ZamCard = ShadCard;

/// Type alias for shadcn checkbox component.
typedef ZamCheckbox = ShadCheckbox;

/// Type alias for shadcn color scheme component.
typedef ZamColorScheme = ShadColorScheme;

/// Type alias for shadcn decoration component.
typedef ZamDecoration = ShadDecoration;

/// Type alias for shadcn input component.
typedef ZamInput = ShadInput;

/// Type alias for shadcn OTP input component.
typedef ZamInputOTP = ShadInputOTP;

/// Type alias for shadcn OTP input group component.
typedef ZamInputOTPGroup = ShadInputOTPGroup;

/// Type alias for shadcn OTP input slot component.
typedef ZamInputOTPSlot = ShadInputOTPSlot;

/// Type alias for shadcn progress indicator component.
typedef ZamProgress = ShadProgress;

/// Type alias for shadcn radio component.
typedef ZamRadio<T> = ShadRadio<T>;

/// Type alias for shadcn sheet component.
typedef ZamSheet = ShadSheet;

/// Type alias for shadcn sheet side enum.
typedef ZamSheetSide = ShadSheetSide;

/// Type alias for shadcn slider component.
typedef ZamSlider = ShadSlider;

/// Type alias for shadcn slider controller component.
typedef ZamSliderController = ShadSliderController;

/// Type alias for shadcn sonner component.
typedef ZamSonner = ShadSonner;

/// Type alias for shadcn switch component.
typedef ZamSwitch = ShadSwitch;

/// Type alias for shadcn tab component.
typedef ZamTab<T> = ShadTab<T>;

/// Type alias for shadcn tabs component.
typedef ZamTabs<T> = ShadTabs<T>;

/// Type alias for shadcn text theme component.
typedef ZamTextTheme = ShadTextTheme;

/// Type alias for shadcn tooltip component.
typedef ZamTooltip = ShadTooltip;

/// Type alias for raw shadcn dialog component.
typedef ZamRawDialog = ShadDialog;

/// Type alias for shadcn dialog variant enum.
typedef ZamDialogVariant = ShadDialogVariant;

/// Displays a modal side sheet configured with tokenized barrier overlay defaults.
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
