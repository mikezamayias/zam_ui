# zam_ui

[![manual CI](https://github.com/mikezamayias/zam_ui/actions/workflows/main.yaml/badge.svg)](https://github.com/mikezamayias/zam_ui/actions/workflows/main.yaml)
[![style: very good analysis](https://img.shields.io/badge/style-very_good_analysis-B22C89.svg)](https://pub.dev/packages/very_good_analysis)
[![License: BSD-3-Clause](https://img.shields.io/badge/license-BSD--3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)

Private, app-agnostic Flutter UI foundation for cohesive Zam apps.

`zam_ui` provides configurable design tokens, shadcn theme generation, and
small reusable UI primitives. Apps own their fonts, icon package, routing, state
management, and brand presets.

## Architecture

`zam_ui` enforces a strict unidirectional dependency flow across modular layers. Higher layers depend only on lower layers, ensuring zero circular coupling:

```mermaid
graph TD
    App["Consumer App (Zam App)"] -->|imports| PublicAPI["package:zam_ui/zam_ui.dart"]
    
    subgraph zam_ui ["zam_ui Package (lib/src/)"]
        PublicAPI --> Components["components/ (UI Primitives & Adapters)"]
        PublicAPI --> Theme["theme/ (Theme Adapters & Context)"]
        PublicAPI --> Tokens["tokens/ (Color, Type, Spacing, Radius)"]
        PublicAPI --> Utils["utils/ (Color & Geometry Calculations)"]
        
        Components --> Theme
        Components --> Tokens
        Theme --> Tokens
        Theme --> Utils
    end
    
    Components -->|Wraps & Type-Aliases| ShadCN["shadcn_ui package"]
```

- **Tokens (`lib/src/tokens/`)**: Pure configuration data contracts (`ZamColorTokens`, `ZamTypographyTokens`, `ZamSpacingTokens`, etc.) with zero widget dependencies.
- **Theme (`lib/src/theme/`)**: Bridges design tokens to the widget tree (`ZamTheme`, `ZamThemeData`, `ZamPreset`) and adapts to `ShadThemeData`.
- **Components (`lib/src/components/`)**: Visual UI primitives (`ZamButton`, `ZamSurface`, `ZamListTile`, `ZamFormField`, `ZamDialog`) and type-aliased shadcn widgets (`ZamCard`, `ZamInput`, `ZamTabs`).
- **Utils (`lib/src/utils/`)**: Standalone mathematical color & geometry utilities (`ZamColorUtils`, `ZamOklchColor`).

## Install

Local development:

```yaml
dependency_overrides:
  zam_ui:
    path: ../zam_ui
```

Private git dependency:

```yaml
dependencies:
  zam_ui:
    git:
      url: git@github.com:mikezamayias/zam_ui.git
      ref: v0.2.0
```

This package is intentionally marked with `publish_to: "none"` so it cannot be
published to public pub.dev by accident. To publish to a hosted private pub
repository, replace `publish_to` with that private repository URL and run
`dart pub publish` after configuring repository authentication.

## Configure

```dart
final ui = ZamThemeData(
  colors: ZamColorTokens.fromSeed(primary: brandColor),
  typography: const ZamTypographyTokens(
    fontFamily: 'Inter',
    monoFontFamily: 'JetBrains Mono',
  ),
  icons: ZamIconSet(
    info: MyIcons.info,
    success: MyIcons.check,
    warning: MyIcons.warning,
    error: MyIcons.error,
    back: MyIcons.back,
    chevronRight: MyIcons.chevronRight,
  ),
);

ZamTheme(
  data: ui,
  child: ShadApp.router(
    theme: ui.toShadThemeData(Brightness.light),
    darkTheme: ui.toShadThemeData(Brightness.dark),
    routerConfig: router,
  ),
);
```

### Fonts

`zam_ui` only consumes font family names through `ZamTypographyTokens`. Each
app is responsible for loading or registering those fonts before using them,
usually in the app's own `pubspec.yaml`:

```yaml
flutter:
  fonts:
    - family: Inter
      fonts:
        - asset: assets/fonts/Inter-Regular.ttf
        - asset: assets/fonts/Inter-SemiBold.ttf
          weight: 600
    - family: JetBrains Mono
      fonts:
        - asset: assets/fonts/JetBrainsMono-Regular.ttf
```

Then reference the family names from the app preset:

```dart
typography: const ZamTypographyTokens(
  fontFamily: 'Inter',
  monoFontFamily: 'JetBrains Mono',
),
```

### Brand Presets

Implement the `ZamPreset` interface to define type-safe brand configurations
for your app:

```dart
class MyAppPreset implements ZamPreset {
  const MyAppPreset();

  @override
  String get name => 'My App';

  @override
  ZamThemeData get light => ZamThemeData(
    colors: ZamColorTokens.fromSeed(primary: brandColor),
    typography: const ZamTypographyTokens(
      fontFamily: 'Inter',
      monoFontFamily: 'JetBrains Mono',
    ),
    icons: myIcons,
  );

  @override
  ZamThemeData get dark => light;
}
```

Then use the preset to configure `ZamApp`:

```dart
const preset = MyAppPreset();

ZamApp.router(
  theme: preset.light,
  darkTheme: preset.dark,
  routerConfig: router,
);
```

## Continuous integration policy

This public repository intentionally does not run automatic checks for pull requests.
Its self-hosted workflow accepts only a manual dispatch of protected `main` and validates that default-branch commit, not pull-request code.
Do not use a manual default-branch result as evidence that an open pull request was tested.

Only the Captain initiates a run, and only after the intended repository changes have landed on protected `main`.
The repository-scoped runner registration and default-branch protection are separate account prerequisites.
The workflow has no inputs, persisted checkout credentials, secrets, deployment behavior, repository writes, cache publication, or artifact upload.

The Captain's exact dispatch procedure is:

1. Confirm the intended changes are already on protected `main` and that the separately registered runner has labels `self-hosted`, `macOS`, `ARM64`, and `zam-ui-manual`.
2. In GitHub, open **Actions**, select **Manual self-hosted CI**, and choose **Run workflow**.
3. Select `main` in the branch selector, leave the input-free form unchanged, and choose **Run workflow**.
4. Confirm the run reports the expected `main` commit SHA and review every job result.

The workflow rejects any other branch, unprotected default branch, non-default workflow source, or mismatched checkout before project commands run.

## Verify

The authoritative SDK contract is [`.github/toolchain.json`](.github/toolchain.json).
Verification fails before dependency resolution unless the selected Flutter SDK and its Flutter-owned Dart SDK match that contract exactly.

```bash
ruby scripts/verify_toolchain.rb .github/toolchain.json
ruby test/workflow_policy_test.rb
flutter pub get
dart format --output=none --set-exit-if-changed .
flutter analyze
dart run scripts/check_design_tokens.dart --self-test
dart run scripts/check_design_tokens.dart
flutter test
```
