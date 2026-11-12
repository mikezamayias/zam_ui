/// Transitional Material support for apps that still use Material widgets
/// below a `ZamApp`.
///
/// `package:zam_ui/zam_ui.dart` does not depend on Material, and `ZamApp`
/// no longer sets Material up. Wrap the Material part of an app in a
/// `ZamMaterial` until it moves off Material:
///
/// ```dart
/// import 'package:zam_ui/material.dart';
///
/// ZamApp(
///   builder: (context, child) => ZamMaterial(child: child!),
///   home: const HomePage(),
/// )
/// ```
///
/// This library is deprecated on arrival and is removed in zam_ui 0.5.0.
library;

// ZamMaterial is deprecated on arrival so apps see every remaining use until
// 0.5.0 removes it.

import 'package:flutter/widgets.dart';
import 'package:shad/material.dart';
import 'package:shad/shad.dart';

/// Lets Material widgets in [child] follow the nearest zam_ui theme.
///
/// It installs what shad's `ShadMaterial` installs: a Material theme derived
/// from the active shad theme, a transparent Material and the Material and
/// Cupertino localizations when no ancestor provides them. It also applies
/// the theme's font family fallback to the derived Material text themes.
@Deprecated(
  'Move the wrapped widgets off Material. Removed in zam_ui 0.5.0.',
)
class ZamMaterial extends StatelessWidget {
  /// Wraps [child] with the Material setup that Material widgets need.
  @Deprecated(
    'Move the wrapped widgets off Material. Removed in zam_ui 0.5.0.',
  )
  const ZamMaterial({required this.child, super.key});

  /// The widget below this widget in the tree.
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final fallback = ShadTheme.of(context).textTheme.p.fontFamilyFallback;
    if (fallback == null || fallback.isEmpty) {
      return ShadMaterial(child: child);
    }
    return ShadMaterial(
      themeBuilder: (context, theme) => theme.copyWith(
        textTheme: theme.textTheme.apply(fontFamilyFallback: fallback),
        primaryTextTheme: theme.primaryTextTheme.apply(
          fontFamilyFallback: fallback,
        ),
      ),
      child: child,
    );
  }
}
