part of '../main.dart';

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
