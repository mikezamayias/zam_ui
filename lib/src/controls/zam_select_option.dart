part of '../controls.dart';

/// One choice in a [ZamSelect].
///
/// [value] identifies the option and is compared with `==`, so the values in
/// one select must be distinct. [label] is the text shown in the list, in the
/// closed select once the option is chosen, and to screen readers.
@immutable
class ZamSelectOption<T> {
  /// Creates a [ZamSelectOption].
  const ZamSelectOption({
    required this.value,
    required this.label,
    this.leading,
  });

  /// Value passed to [ZamSelect.onChanged] when this option is chosen.
  final T value;

  /// Text of the option.
  final String label;

  /// Widget shown before [label], such as an icon, or null for none.
  ///
  /// Screen readers skip it and read [label] only.
  final Widget? leading;
}
