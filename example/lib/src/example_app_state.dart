part of '../main.dart';

class _ExampleAppState extends State<ExampleApp> {
  ZamPreset _preset = wellnessPreset;

  void _togglePreset() {
    setState(() {
      _preset = _preset is WellnessPreset ? fitnessPreset : wellnessPreset;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = _preset.light;

    return ZamTheme(
      data: theme,
      child: ShadApp(
        theme: theme.toShadThemeData(Brightness.light),
        darkTheme: theme.toShadThemeData(Brightness.dark),
        home: ExampleHome(
          presetName: _preset.name,
          onTogglePreset: _togglePreset,
        ),
      ),
    );
  }
}
