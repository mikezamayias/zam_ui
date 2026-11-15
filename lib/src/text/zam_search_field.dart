part of '../text.dart';

/// A styled search input built on [ZamTextField].
///
/// It draws a box in the theme's card color with a hairline border in the
/// palette's `border` role and the theme's medium radius. While the field
/// has focus, a ring in the palette's `ring` role and the `focusRing` stroke
/// width is drawn over the border, so the text does not move. The box is at
/// least the kit's minimum tap target tall.
///
/// A search icon from [ZamIconSet.search] leads the field, and none shows
/// when the role is null. While there is text, a clear button trails it.
/// The button uses [ZamIconSet.clear], or a plain drawn cross when that role
/// is null. A tap on it empties the field, calls [onChanged] with an empty
/// string and keeps focus in the field.
///
/// The keyboard shows a search action, and [onSubmitted] receives the text
/// when it is pressed. Autofill is off, because a search query is not a
/// value the platform should fill or remember.
///
/// For screen readers, the field is one text field node named by
/// [semanticsLabel], with [placeholderText] as its hint while it is empty.
/// The clear button is a separate button named by [clearSemanticsLabel].
class ZamSearchField extends StatefulWidget {
  /// Creates a [ZamSearchField].
  const ZamSearchField({
    required this.semanticsLabel,
    required this.clearSemanticsLabel,
    super.key,
    this.controller,
    this.focusNode,
    this.placeholderText,
    this.onChanged,
    this.onSubmitted,
    this.enabled = true,
    this.autofocus = false,
  });

  /// The name screen readers announce for the field, such as "Search".
  ///
  /// It is required because a placeholder is a hint, not a name, and it is
  /// no longer shown once text is typed.
  final String semanticsLabel;

  /// The name screen readers announce for the clear button, such as
  /// "Clear search".
  final String clearSemanticsLabel;

  /// Controls the text and the selection.
  ///
  /// When null, the field keeps a controller of its own.
  final TextEditingController? controller;

  /// The focus node of the field.
  ///
  /// When null, the field keeps a focus node of its own.
  final FocusNode? focusNode;

  /// The text shown while the field is empty, such as "Search skills".
  final String? placeholderText;

  /// Called with the new text after each change, including the empty text
  /// after the clear button is pressed.
  final ValueChanged<String>? onChanged;

  /// Called with the text when the keyboard's search action is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Whether the field can be focused and edited.
  ///
  /// A disabled field is drawn at the theme's `disabled` opacity, ignores
  /// pointers, cannot take focus, shows no clear button and reports itself
  /// as disabled to screen readers.
  final bool enabled;

  /// Whether the field takes focus when it is first built.
  final bool autofocus;

  @override
  State<ZamSearchField> createState() => _ZamSearchFieldState();
}
