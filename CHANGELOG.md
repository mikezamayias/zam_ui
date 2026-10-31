# Changelog

## 0.3.0

### Breaking

- Moved from `shadcn_ui` to `shad` 1.0 and `lucide_icons_flutter` 4.
  Requires Dart 3.11 and Flutter 3.41. The `ZamX = ShadX` aliases now point
  at shad, so shad's
  [migration guide](https://github.com/serverpod/shad/blob/main/MIGRATION.md)
  applies to them.
- `zam_ui.dart` no longer re-exports `flutter_animate`, `intl` or
  `lucide_icons_flutter`. Apps add them to their own `pubspec.yaml` and
  import them where used.
- `ZamSpacingTokens` is now shad's step scale: `ZamSpacingTokens(step: 4)`,
  `spacing(n)`, and the named steps `xs`, `sm`, `md`, `lg`, `xl`.
  `ZamThemeData` passes it to shad, so one step size drives both. The
  numeric names (`spacing.twelve`) still work, deprecated, with the same
  values: replace `twelve` with `spacing(3)`, `sixteen` with `md`, and so
  on. The constructor no longer takes the numeric names, so single values
  can no longer be overridden; change `step` instead. The minimum tap target
  stays 44 at any step.
- `ZamButton` sizes have their own heights: small 44, medium 48, large 56.
  `buttonLargeHeight` is now 56; use `buttonMediumHeight` for the old 48.
- `ZamColorTokens.fromSeed` defaults to a neutral zinc palette. To keep the
  previous look, pass the old values:

  | Parameter | 0.3.0 | Before |
  | --- | --- | --- |
  | `lightBackground` | `#FFFFFF` | `#FAF9F7` |
  | `lightMuted` | `#F4F4F5` | `#F0EEEA` |
  | `lightMutedForeground` | `#71717A` | `#73706A` |
  | `lightBorder` | `#E4E4E7` | `#E4E0D9` |
  | `lightDestructive` | `#DC2626` | `#FF3B30` |
  | `darkCard` | `#18181B` | `#1A1A1C` |
  | `darkDestructive` | `#EF4444` | `#D92D20` |
  | `oledCard` | `#09090B` | `#0A0A0A` |

- Removed `ZamMotionTokens.reducedMotion`, which nothing used.

### Added

- `ZamStatusColors`: success, warning, info and error, each with a readable
  foreground, from `ZamSurfaceColors.status` or `context.zamStatus`.
  `fromSeed` takes light and dark values for each.
- `ZamAsyncButton`, which disables itself and shows the loading indicator
  while its async `onPressed` runs.
- Configurable typography scale: every size, line height and weight in
  `ZamTypographyTokens` is a constructor parameter with the old default.
- Value equality for `ZamThemeData` and every token class it holds, so an
  equal rebuilt theme no longer rebuilds its readers.
- `ZamButtonStyle` overrides (#4).

### Changed

- Buttons follow shad's styles: outline rests on the background and hovers
  to muted, ghost and outline labels use the foreground color, and buttons
  shift 1px while pressed. Destructive buttons keep a solid fill with
  `destructiveForeground`, which passes WCAG AA where shad's tint does not.
- Success, warning and info toasts use the status colors. Progress toasts
  stay up for `motion.progressToast` by default.
- `ZamDialog` stacks its actions on every screen size, and its barrier
  matches `showZamDialog` and `showZamSheet`.
- `showZamSheet` lifts sheets above the keyboard and removes the keyboard
  inset from the sheet's content. Drop any keyboard padding the app adds
  itself.
- `ZamApp` keeps Material widgets and Material page routes working.
- Pumping an unchanged `ZamApp` again no longer rebuilds every theme
  reader. Tests that change a mocked state without emitting it, and relied
  on that rebuild, must emit it.
- Deprecated `ZamButtonSize.sm`, `regular` and `lg`. Use `small`, `medium`
  and `large`. The aliases keep working.
- Deprecated the 28 `ZamX = ShadX` aliases, such as `ZamCard` and
  `ZamInput`. Use the shad widget named in each warning. `zam_ui` does not
  re-export shad, so add `shad: ">=1.0.2 <1.1.0"` to the app's
  `pubspec.yaml` and import `package:shad/shad.dart`. `ZamApp` still themes
  the widget. The aliases are removed in 0.4.0.
- `ZamThemeData.fallback()` uses a neutral blue primary, and the example
  presets use generic names and colors.
- Relicensed under BSD-3-Clause, restructured to the VGV package layout,
  documented the full public API, and added manual self-hosted CI.

### Fixed

- `ZamApp` scopes the dark `ZamThemeData` in dark mode, so `context.zam`
  matches the active brightness.
- `ZamDialog.showMessage` and `showConfirmation` no longer throw on wide
  screens.
- `ZamFilterPill`, tappable `ZamListTile` and `ZamSurface`, and the
  `ZamScreenHeader` back button take keyboard focus, activate with Enter and
  Space on every platform including web, and show hover and press feedback.
- `ZamIconButton` reports its enabled state to screen readers. Buttons read
  as one semantics node, and primary and destructive foregrounds default to
  black or white by contrast (#3).
- The button loading indicator takes the label color, so it shows on
  outline, ghost and link buttons, and it pulses unless reduce motion is on.
  Tests that call `pumpAndSettle` on a loading `ZamButton` or a running
  `ZamAsyncButton` must pump a fixed duration instead.
- `ZamSkeleton` stops animating when idle or when reduce motion is on.
- `ZamDivider` and `ZamListTile` indent from the start side in
  right-to-left layouts.
- `ZamFormField` labels wrap at large text sizes instead of overflowing.
- The `TextDirection` that intl exported no longer shadows Flutter's.

## 0.2.0

- Added `ZamFormField` wrapper for label, description, error, and required
  indicator around any input widget.
- Added `ZamListTile` with leading/trailing slots, title/subtitle,
  tap semantics, optional divider, and dense mode.
- Added `ZamDivider` horizontal and vertical divider using tokenized
  stroke width and theme border color.
- Added `ZamThemeData.copyWith()` for composing theme variants without
  full reconstruction.
- Added widget previews for all new components.
- Added 15 new tests covering `copyWith`, `ZamDivider`, `ZamListTile`,
  and `ZamFormField`.

## 0.1.3

- Added `ZamPreset` abstract interface for type-safe app-owned brand presets.
- Added `ZamColorUtils.barrier` tokenized constant for dialog/sheet overlays.
- Added widget previews to the example app for interactive component testing.
- Replaced hard-coded barrier colors in `showZamSheet` and `showZamDialog`
  with `ZamColorUtils.barrier`.

## 0.1.2

- Documented that apps must load/register font assets themselves while
  `zam_ui` only consumes configured font family names.

## 0.1.1

- Split each class into its own source file across tokens, theme, utilities,
  components, example classes, and script helpers.
- Preserved the public `package:zam_ui/zam_ui.dart` API surface.

## 0.1.0

- Initial private release of the Zam Flutter UI foundation.
- Added configurable design tokens, shadcn theme generation, color utilities,
  reusable UI primitives, example presets, tests, and token scanning.
