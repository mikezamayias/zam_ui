part of '../text.dart';

// Flutter's default space around a field that scrolls into view.
const double _kScrollPadding = 20;

/// An unstyled text input with platform selection handles, a magnifier and
/// an edit menu.
///
/// It draws no border, fill or padding, and is no taller than one line of
/// text unless [minLines], [maxLines] or the placeholder ask for more. The
/// caller draws the box around it.
///
/// On touch devices, a long press or a double tap selects a word and shows
/// [ZamTextSelectionControls] handles in the theme's `primaryControl` color.
/// Dragging a handle or the caret shows the iOS or Android magnifier. The
/// edit menu is the iOS system menu where the platform can show it, and
/// shad's menu with localized cut, copy, paste and select-all items
/// elsewhere.
///
/// The placeholder shows while the text is empty. Unlike shad's input, it
/// takes part in layout, so a placeholder that wraps makes the field taller.
///
/// For screen readers the field is one text field node. [semanticsLabel]
/// names it, [placeholderText] is its hint while the text is empty, and
/// [semanticsValidationResult] marks it invalid while an error shows.
class ZamTextField extends StatefulWidget {
  /// Creates a [ZamTextField].
  const ZamTextField({
    super.key,
    this.controller,
    this.focusNode,
    this.placeholder,
    this.placeholderText,
    this.placeholderStyle,
    this.placeholderMaxLines,
    this.maintainPlaceholderSize = true,
    this.style,
    this.textAlign = TextAlign.start,
    this.verticalAlignment = AlignmentDirectional.topStart,
    this.keyboardType,
    this.textInputAction,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.readOnly = false,
    this.enabled = true,
    this.obscureText = false,
    this.autocorrect = true,
    this.enableSuggestions = true,
    this.enableIMEPersonalizedLearning = true,
    this.smartDashesType,
    this.smartQuotesType,
    this.minLines,
    this.maxLines = 1,
    this.maxLength,
    this.inputFormatters,
    this.autofillHints = const <String>[],
    this.onChanged,
    this.onSubmitted,
    this.onEditingComplete,
    this.onTapOutside,
    this.cursorColor,
    this.selectionColor,
    this.scrollPadding = const EdgeInsets.all(_kScrollPadding),
    this.scrollController,
    this.scrollPhysics,
    this.semanticsLabel,
    this.semanticsValidationResult = SemanticsValidationResult.none,
  });

  /// Controls the text and the selection.
  ///
  /// When null, the field keeps a controller of its own.
  final TextEditingController? controller;

  /// The focus node of the field.
  ///
  /// When null, the field keeps a focus node of its own.
  final FocusNode? focusNode;

  /// The widget shown while the text is empty.
  ///
  /// It takes [placeholderStyle], [textAlign] and [placeholderMaxLines] as
  /// its default text style. It wins over [placeholderText] for display, and
  /// it is hidden from screen readers, so pass [placeholderText] as well to
  /// announce it.
  final Widget? placeholder;

  /// The text shown while the text is empty, when [placeholder] is null.
  ///
  /// It is also the field's semantics hint while the text is empty.
  final String? placeholderText;

  /// The style of the placeholder, merged over the field's [style] in the
  /// palette's `placeholderText` color.
  final TextStyle? placeholderStyle;

  /// The most lines the placeholder takes before it ends in an ellipsis.
  ///
  /// When null, the placeholder wraps without limit.
  final int? placeholderMaxLines;

  /// Whether the field stays at least as tall as its placeholder after text
  /// is typed.
  ///
  /// When false, the placeholder leaves the layout as soon as the text is
  /// not empty.
  final bool maintainPlaceholderSize;

  /// The style of the typed text, merged over shad's input text style.
  final TextStyle? style;

  /// How the typed text and the placeholder align horizontally.
  final TextAlign textAlign;

  /// Where the text and the placeholder sit when the field is taller than
  /// their content, for example at the top or in the middle.
  ///
  /// The default is the top start corner, which follows the text direction.
  final AlignmentGeometry verticalAlignment;

  /// The kind of keyboard to show.
  ///
  /// When null, a one-line field shows a text keyboard and any other a
  /// multiline keyboard.
  final TextInputType? keyboardType;

  /// The action button of the keyboard.
  final TextInputAction? textInputAction;

  /// How the keyboard capitalizes typed text.
  final TextCapitalization textCapitalization;

  /// Whether the field takes focus when it is first built.
  final bool autofocus;

  /// Whether the text can be selected and copied but not changed.
  final bool readOnly;

  /// Whether the field can be focused and edited.
  ///
  /// A disabled field ignores pointers, cannot take focus and reports itself
  /// as disabled to screen readers. It does not change how it is drawn.
  final bool enabled;

  /// Whether to hide the text, as for a password.
  final bool obscureText;

  /// Whether the keyboard corrects spelling.
  final bool autocorrect;

  /// Whether the keyboard offers suggestions.
  final bool enableSuggestions;

  /// Whether the keyboard may learn from what is typed.
  final bool enableIMEPersonalizedLearning;

  /// How the keyboard handles dashes.
  ///
  /// When null, smart dashes are on unless [obscureText] is true.
  final SmartDashesType? smartDashesType;

  /// How the keyboard handles quotes.
  ///
  /// When null, smart quotes are on unless [obscureText] is true.
  final SmartQuotesType? smartQuotesType;

  /// The fewest lines the field shows.
  final int? minLines;

  /// The most lines the field shows before it scrolls, or null to grow
  /// without limit.
  final int? maxLines;

  /// The most characters the field accepts, or null for no limit.
  final int? maxLength;

  /// Formatters applied to typed text, before [maxLength].
  final List<TextInputFormatter>? inputFormatters;

  /// Hints for the platform's autofill service.
  ///
  /// Null switches autofill off for this field, as with [EditableText]. An
  /// empty list keeps the field in the platform's autofill context without
  /// hints.
  final Iterable<String>? autofillHints;

  /// Called with the new text after each change.
  final ValueChanged<String>? onChanged;

  /// Called with the text when the keyboard's action button is pressed.
  final ValueChanged<String>? onSubmitted;

  /// Called when the keyboard's action button is pressed, before
  /// [onSubmitted].
  final VoidCallback? onEditingComplete;

  /// Called for a tap outside the field while it has focus.
  final TapRegionCallback? onTapOutside;

  /// The caret color, or null for the theme's primary color.
  final Color? cursorColor;

  /// The color of selected text while the field has focus, or null for the
  /// palette's `selection` role.
  final Color? selectionColor;

  /// The space kept around the field when it scrolls into view.
  final EdgeInsets scrollPadding;

  /// The scroll controller of the scroll view that holds the field.
  final ScrollController? scrollController;

  /// The scroll physics of the field when its text is taller than it.
  final ScrollPhysics? scrollPhysics;

  /// The name screen readers announce for the field.
  ///
  /// Pass the visible label here when it is drawn outside the field.
  final String? semanticsLabel;

  /// Whether screen readers report the field as valid or invalid.
  ///
  /// Pass [SemanticsValidationResult.invalid] while an error shows for the
  /// field. The caller still draws and announces the error message.
  final SemanticsValidationResult semanticsValidationResult;

  @override
  State<ZamTextField> createState() => _ZamTextFieldState();
}
