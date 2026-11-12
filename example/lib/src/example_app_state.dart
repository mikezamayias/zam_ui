part of '../main.dart';

class _ExampleAppState extends State<ExampleApp> {
  ZamPreset _preset = wellnessPreset;
  ZamThemeMode _themeMode = ZamThemeMode.system;

  void _togglePreset() {
    setState(() {
      _preset = _preset is WellnessPreset ? fitnessPreset : wellnessPreset;
    });
  }

  void _cycleThemeMode() {
    setState(() {
      const modes = ZamThemeMode.values;
      _themeMode = modes[(_themeMode.index + 1) % modes.length];
    });
  }

  @override
  Widget build(BuildContext context) {
    return ZamApp(
      title: 'zam_ui example',
      theme: _preset.light,
      darkTheme: _preset.dark,
      themeMode: _themeMode,
      home: ExampleHome(
        presetName: _preset.name,
        themeMode: _themeMode,
        onTogglePreset: _togglePreset,
        onCycleThemeMode: _cycleThemeMode,
      ),
    );
  }
}
