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

typedef ZamResolvedThemeData = ShadThemeData;
typedef ZamResolvedColorScheme = ShadColorScheme;
typedef ZamResolvedTheme = ShadTheme;
