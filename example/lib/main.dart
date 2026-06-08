import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/zam_ui.dart';
import 'package:zam_ui_example/presets.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({super.key});

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  bool _fitness = false;

  @override
  Widget build(BuildContext context) {
    final theme = _fitness ? fitnessTheme : wellnessTheme;

    return ZamTheme(
      data: theme,
      child: ShadApp(
        theme: theme.toShadThemeData(Brightness.light),
        darkTheme: theme.toShadThemeData(Brightness.dark),
        home: ExampleHome(
          presetName:
              _fitness ? 'Peakward-style fitness' : 'Healpen-style wellness',
          onTogglePreset: () => setState(() => _fitness = !_fitness),
        ),
      ),
    );
  }
}

class ExampleHome extends StatelessWidget {
  const ExampleHome({
    required this.presetName,
    required this.onTogglePreset,
    super.key,
  });

  final String presetName;
  final VoidCallback onTogglePreset;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;

    return ZamScreen(
      padding: theme.insets.screen,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ZamScreenHeader(
            title: 'zam_ui',
            subtitle: presetName,
            trailing: ZamIconButton(
              icon: Icon(context.zamIcons.info),
              semanticLabel: 'About zam_ui',
              onPressed: () => ZamToast.show(
                context,
                title: 'App-owned identity',
                description:
                    const Text('Colors, fonts, and icons come from the app.'),
              ),
            ),
          ),
          SizedBox(height: theme.spacing.sixteen),
          ZamSurface(
            withShadow: true,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const ZamSectionHeader(
                  title: 'Shared primitives',
                  subtitle: 'The same widgets adapt to each app preset.',
                ),
                SizedBox(height: theme.spacing.sixteen),
                Row(
                  children: [
                    const Expanded(
                      child: ZamStatTile(label: 'TOKENS', value: '12'),
                    ),
                    SizedBox(width: theme.spacing.twelve),
                    const Expanded(
                      child: ZamStatTile(label: 'PRESETS', value: '2'),
                    ),
                  ],
                ),
                SizedBox(height: theme.spacing.sixteen),
                Wrap(
                  spacing: theme.spacing.eight,
                  runSpacing: theme.spacing.eight,
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
                SizedBox(height: theme.spacing.sixteen),
                ZamButton(
                  label: 'Switch preset',
                  isExpanded: true,
                  onPressed: onTogglePreset,
                ),
              ],
            ),
          ),
          SizedBox(height: theme.spacing.sixteen),
          ZamEmptyState(
            icon: context.zamIcons.success,
            title: 'Ready for app migration',
            message:
                'Start with tokens and low-risk primitives before broader UI replacement.',
          ),
        ],
      ),
    );
  }
}
