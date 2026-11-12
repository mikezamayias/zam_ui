part of '../main.dart';

/// Example home page showcasing the shell, presets and component primitives.
class ExampleHome extends StatelessWidget {
  /// Creates an [ExampleHome] widget.
  const ExampleHome({
    required this.presetName,
    required this.themeMode,
    required this.onTogglePreset,
    required this.onCycleThemeMode,
    super.key,
  });

  /// Name of the active brand preset.
  final String presetName;

  /// The theme mode the app currently uses.
  final ZamThemeMode themeMode;

  /// Callback executed when toggling preset.
  final VoidCallback onTogglePreset;

  /// Callback executed when cycling the theme mode.
  final VoidCallback onCycleThemeMode;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;

    return ZamScaffold(
      body: ZamScreen(
        scrollable: true,
        padding: theme.insets.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZamScreenHeader(
              title: 'zam_ui',
              subtitle: presetName,
              trailing: ZamTooltip(
                message: 'About zam_ui',
                child: ZamIconButton(
                  icon: Icon(context.zamIcons.info),
                  semanticLabel: 'About zam_ui',
                  onPressed: () => ZamToast.show(
                    context,
                    title: 'App-owned identity',
                    description: const Text(
                      'Colors, fonts, and icons come from the app.',
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: theme.spacing.md),
            ZamSurface(
              withShadow: true,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ZamSectionHeader(
                    title: 'Shared primitives',
                    subtitle: 'The same widgets adapt to each app preset.',
                  ),
                  SizedBox(height: theme.spacing.md),
                  Row(
                    children: [
                      const Expanded(
                        child: ZamStatTile(label: 'TOKENS', value: '12'),
                      ),
                      SizedBox(width: theme.spacing(3)),
                      const Expanded(
                        child: ZamStatTile(label: 'PRESETS', value: '2'),
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.md),
                  Wrap(
                    spacing: theme.spacing.sm,
                    runSpacing: theme.spacing.sm,
                    children: [
                      ZamFilterPill(
                        label: 'Color',
                        selected: true,
                        onTap: () {},
                      ),
                      ZamFilterPill(
                        label: 'Type',
                        selected: false,
                        onTap: () {},
                      ),
                      ZamFilterPill(
                        label: 'Motion',
                        selected: false,
                        onTap: () {},
                      ),
                    ],
                  ),
                  SizedBox(height: theme.spacing.md),
                  ZamButton(
                    label: 'Switch preset',
                    isExpanded: true,
                    onPressed: onTogglePreset,
                  ),
                  SizedBox(height: theme.spacing.sm),
                  ZamButton(
                    label: 'Theme mode: ${themeMode.name}',
                    variant: ZamButtonVariant.outline,
                    isExpanded: true,
                    onPressed: onCycleThemeMode,
                  ),
                ],
              ),
            ),
            SizedBox(height: theme.spacing.md),
            ZamSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const ZamSectionHeader(
                    title: 'Overlays',
                    subtitle: 'Dialogs, sheets and toasts need no Material.',
                  ),
                  SizedBox(height: theme.spacing.md),
                  ZamButton(
                    label: 'Show dialog',
                    variant: ZamButtonVariant.secondary,
                    isExpanded: true,
                    onPressed: () => _showExampleDialog(context),
                  ),
                  SizedBox(height: theme.spacing.sm),
                  ZamButton(
                    label: 'Show sheet',
                    variant: ZamButtonVariant.secondary,
                    isExpanded: true,
                    onPressed: () => _showExampleSheet(context),
                  ),
                  SizedBox(height: theme.spacing.sm),
                  ZamButton(
                    label: 'Show custom toast',
                    variant: ZamButtonVariant.secondary,
                    isExpanded: true,
                    onPressed: () => _showExampleToast(context),
                  ),
                ],
              ),
            ),
            SizedBox(height: theme.spacing.md),
            ZamSurface(
              child: ZamListTile(
                title: 'Controls and text',
                subtitle: 'Opens a page with a platform route.',
                leading: Icon(context.zamIcons.chevronRight),
                semanticLabel: 'Open controls and text',
                onTap: () => Navigator.of(context).push(
                  ZamPageRoute<void>(builder: (_) => const ExampleControls()),
                ),
              ),
            ),
            SizedBox(height: theme.spacing.md),
            ZamEmptyState(
              icon: context.zamIcons.success,
              title: 'Ready for app migration',
              message:
                  'Start with tokens and low-risk primitives before broader '
                  'UI replacement.',
            ),
          ],
        ),
      ),
    );
  }
}
