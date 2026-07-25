# Changelog

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
