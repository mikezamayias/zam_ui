// The ZamX = ShadX aliases are deprecated in 0.3.0 so apps get one release
// of warnings before 0.4.0 removes them.
// ignore_for_file: remove_deprecations_in_breaking_versions

import 'package:flutter/material.dart'
    show
        Action,
        GenerateAppTitle,
        InitialRouteListFactory,
        Intent,
        LocaleListResolutionCallback,
        LocaleResolutionCallback,
        MaterialPageRoute,
        NavigatorObserver,
        NavigatorState,
        RouteFactory,
        RouterConfig,
        ShortcutActivator,
        ThemeMode;
import 'package:flutter/widgets.dart';
// ponytail: ZamApp keeps Material set up for apps that still use Material
// widgets, as shadcn_ui did. Drop it once the apps move off Material.
import 'package:shad/material.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/src/tokens.dart';
import 'package:zam_ui/src/utils.dart';

part 'theme/zam_app.dart';
part 'theme/zam_toast_variant.dart';
part 'theme/zam_toast_style.dart';
part 'theme/zam_theme_data.dart';
part 'theme/zam_theme.dart';
part 'theme/zam_theme_context.dart';
part 'theme/zam_preset.dart';

/// Deprecated alias for [ShadThemeData]. Use [ShadThemeData] directly.
@Deprecated('Use ShadThemeData from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamResolvedThemeData = ShadThemeData;

/// Deprecated alias for [ShadColorScheme]. Use [ShadColorScheme] directly.
@Deprecated('Use ShadColorScheme from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamResolvedColorScheme = ShadColorScheme;

/// Deprecated alias for [ShadTheme]. Use [ShadTheme] directly.
@Deprecated('Use ShadTheme from package:shad. Removed in zam_ui 0.4.0.')
typedef ZamResolvedTheme = ShadTheme;
