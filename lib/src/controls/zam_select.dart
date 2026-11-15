part of '../controls.dart';

/// A closed field that opens a list of [options] and picks one of them.
///
/// It draws through shad's select. The closed field shows the label of the
/// option whose value equals [value], or [placeholder] when no option
/// matches. A tap, Enter or Space opens the list below the field, or above it
/// when there is no room. In the list the arrow keys move between options,
/// Enter picks the focused one, and Escape or a tap outside closes it.
///
/// The field is at least the theme's minimum tap target tall, and so is each
/// option, with the content centred vertically. It draws a hairline border
/// on the theme's medium radius and the theme's focus ring while focused.
///
/// [value] is the source of truth: picking an option calls [onChanged], and
/// the field shows the new option only once the parent passes it back as
/// [value]. A null [onChanged] disables the select.
///
/// Screen readers find one button with [semanticLabel] as its name, the
/// chosen label or [placeholder] as its value, and its expanded state. Each
/// option reads as a selectable button in one group.
class ZamSelect<T> extends StatefulWidget {
  /// Creates a [ZamSelect].
  const ZamSelect({
    required this.options,
    super.key,
    this.value,
    this.onChanged,
    this.placeholder,
    this.semanticLabel,
    this.focusNode,
  });

  /// Choices in list order. Their values must be distinct.
  final List<ZamSelectOption<T>> options;

  /// Value of the chosen option, or null when nothing is chosen.
  ///
  /// A value that matches no option counts as nothing chosen.
  final T? value;

  /// Called with the value of an option when the user picks it.
  ///
  /// Picking the option that is already chosen does not call it. A null
  /// callback disables the select.
  final ValueChanged<T>? onChanged;

  /// Text shown in the closed field while nothing is chosen.
  final String? placeholder;

  /// Accessible name of the select, such as the label of its form field.
  final String? semanticLabel;

  /// Focus node of the closed field, or null to let the widget own one.
  final FocusNode? focusNode;

  @override
  State<ZamSelect<T>> createState() => _ZamSelectState<T>();
}
