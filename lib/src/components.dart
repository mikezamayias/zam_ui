// The ZamX = ShadX aliases are deprecated in 0.3.0 so apps get one release
// of warnings before 0.4.0 removes them.
// ignore_for_file: remove_deprecations_in_breaking_versions

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:shad/shad.dart';
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
part 'components/zam_async_button.dart';
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

/// Deprecated alias for [ShadBadge]. Use [ShadBadge] directly.
@Deprecated('Use ShadBadge from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamBadge = ShadBadge;

/// Deprecated alias for [ShadBorder]. Use [ShadBorder] directly.
@Deprecated('Use ShadBorder from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamBorder = ShadBorder;

/// Deprecated alias for [ShadCalendar]. Use [ShadCalendar] directly.
@Deprecated('Use ShadCalendar from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamCalendar = ShadCalendar;

/// Deprecated alias for [ShadCard]. Use [ShadCard] directly.
@Deprecated('Use ShadCard from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamCard = ShadCard;

/// Deprecated alias for [ShadCheckbox]. Use [ShadCheckbox] directly.
@Deprecated('Use ShadCheckbox from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamCheckbox = ShadCheckbox;

/// Deprecated alias for [ShadColorScheme]. Use [ShadColorScheme] directly.
@Deprecated('Use ShadColorScheme from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamColorScheme = ShadColorScheme;

/// Deprecated alias for [ShadDecoration]. Use [ShadDecoration] directly.
@Deprecated('Use ShadDecoration from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamDecoration = ShadDecoration;

/// Deprecated alias for [ShadInput]. Use [ShadInput] directly.
@Deprecated('Use ShadInput from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamInput = ShadInput;

/// Deprecated alias for [ShadInputOTP]. Use [ShadInputOTP] directly.
@Deprecated('Use ShadInputOTP from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamInputOTP = ShadInputOTP;

/// Deprecated alias for [ShadInputOTPGroup]. Use [ShadInputOTPGroup] directly.
@Deprecated('Use ShadInputOTPGroup from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamInputOTPGroup = ShadInputOTPGroup;

/// Deprecated alias for [ShadInputOTPSlot]. Use [ShadInputOTPSlot] directly.
@Deprecated('Use ShadInputOTPSlot from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamInputOTPSlot = ShadInputOTPSlot;

/// Deprecated alias for [ShadProgress]. Use [ShadProgress] directly.
@Deprecated('Use ShadProgress from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamProgress = ShadProgress;

/// Deprecated alias for [ShadRadio]. Use [ShadRadio] directly.
@Deprecated('Use ShadRadio from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamRadio<T> = ShadRadio<T>;

/// Deprecated alias for [ShadSheet]. Use [ShadSheet] directly.
@Deprecated('Use ShadSheet from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamSheet = ShadSheet;

/// Deprecated alias for [ShadSheetSide]. Use [ShadSheetSide] directly.
@Deprecated('Use ShadSheetSide from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamSheetSide = ShadSheetSide;

/// Deprecated alias for [ShadSlider]. Use [ShadSlider] directly.
@Deprecated('Use ShadSlider from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamSlider = ShadSlider;

/// Deprecated alias for [ShadSliderController]. Use [ShadSliderController] directly.
@Deprecated(
  'Use ShadSliderController from package:shad. Removed in zam_ui 0.4.0.',
)
typedef ZamSliderController = ShadSliderController;

/// Deprecated alias for [ShadSonner]. Use [ShadSonner] directly.
@Deprecated('Use ShadSonner from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamSonner = ShadSonner;

/// Deprecated alias for [ShadSwitch]. Use [ShadSwitch] directly.
@Deprecated('Use ShadSwitch from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamSwitch = ShadSwitch;

/// Deprecated alias for [ShadTab]. Use [ShadTab] directly.
@Deprecated('Use ShadTab from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamTab<T> = ShadTab<T>;

/// Deprecated alias for [ShadTabs]. Use [ShadTabs] directly.
@Deprecated('Use ShadTabs from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamTabs<T> = ShadTabs<T>;

/// Deprecated alias for [ShadTextTheme]. Use [ShadTextTheme] directly.
@Deprecated('Use ShadTextTheme from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamTextTheme = ShadTextTheme;

/// Deprecated alias for [ShadTooltip]. Use [ShadTooltip] directly.
@Deprecated('Use ShadTooltip from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamTooltip = ShadTooltip;

/// Deprecated alias for [ShadDialog]. Use [ShadDialog] directly.
@Deprecated('Use ShadDialog from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamRawDialog = ShadDialog;

/// Deprecated alias for [ShadDialogVariant]. Use [ShadDialogVariant] directly.
@Deprecated('Use ShadDialogVariant from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamDialogVariant = ShadDialogVariant;

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
