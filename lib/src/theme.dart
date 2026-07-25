import 'package:flutter/material.dart'
    show
        Action,
        GenerateAppTitle,
        InitialRouteListFactory,
        Intent,
        LocaleListResolutionCallback,
        LocaleResolutionCallback,
        NavigatorObserver,
        NavigatorState,
        RouteFactory,
        RouterConfig,
        ShortcutActivator,
        ThemeMode;
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/src/tokens.dart';
import 'package:zam_ui/src/utils.dart';

part 'theme/zam_app.dart';
part 'theme/zam_toast_variant.dart';
part 'theme/zam_toast_style.dart';
part 'theme/zam_theme_data.dart';
part 'theme/zam_theme.dart';
part 'theme/zam_theme_context.dart';
part 'theme/zam_preset.dart';

/// Type alias for resolved shadcn theme data.
typedef ZamResolvedThemeData = ShadThemeData;

/// Type alias for resolved shadcn color scheme.
typedef ZamResolvedColorScheme = ShadColorScheme;

/// Type alias for resolved shadcn theme widget.
typedef ZamResolvedTheme = ShadTheme;
