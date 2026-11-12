part of '../controls.dart';

class _ZamReorderLocalizationsDelegate
    extends LocalizationsDelegate<WidgetsLocalizations> {
  const _ZamReorderLocalizationsDelegate({
    required this.base,
    required this.labels,
    required this.direction,
  });

  final WidgetsLocalizations base;
  final ZamReorderLabels labels;
  final TextDirection direction;

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<WidgetsLocalizations> load(Locale locale) =>
      SynchronousFuture<WidgetsLocalizations>(
        _ZamReorderLocalizations(
          base: base,
          labels: labels,
          direction: direction,
        ),
      );

  @override
  bool shouldReload(_ZamReorderLocalizationsDelegate old) =>
      old.base != base || old.labels != labels || old.direction != direction;
}
