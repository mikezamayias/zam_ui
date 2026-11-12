part of '../text.dart';

class _ZamTextFieldState extends State<ZamTextField> {
  final _inputKey = GlobalKey<ShadInputState>();
  final _isEmpty = ValueNotifier<bool>(true);
  TextEditingController? _localController;
  FocusNode? _localFocusNode;
  TextEditingController? _listenedController;

  TextEditingController get _controller =>
      widget.controller ?? (_localController ??= TextEditingController());

  FocusNode get _focusNode =>
      widget.focusNode ?? (_localFocusNode ??= FocusNode());

  @override
  void initState() {
    super.initState();
    _listenToController();
  }

  @override
  void didUpdateWidget(ZamTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller == null && oldWidget.controller != null) {
      _localController = TextEditingController.fromValue(
        oldWidget.controller!.value,
      );
    } else if (widget.controller != null && _localController != null) {
      _disposeAfterFrame(_localController!);
      _localController = null;
    }
    if (widget.focusNode != null && _localFocusNode != null) {
      _disposeAfterFrame(_localFocusNode!);
      _localFocusNode = null;
    }
    _listenToController();
  }

  @override
  void dispose() {
    _listenedController?.removeListener(_updateIsEmpty);
    _isEmpty.dispose();
    _localController?.dispose();
    _localFocusNode?.dispose();
    super.dispose();
  }

  // The input below still holds the old notifier until it rebuilds in this
  // frame, so it is disposed only after that.
  void _disposeAfterFrame(ChangeNotifier notifier) {
    WidgetsBinding.instance.addPostFrameCallback((_) => notifier.dispose());
  }

  void _listenToController() {
    final controller = _controller;
    if (identical(controller, _listenedController)) return;
    _listenedController?.removeListener(_updateIsEmpty);
    _listenedController = controller..addListener(_updateIsEmpty);
    _updateIsEmpty();
  }

  void _updateIsEmpty() => _isEmpty.value = _controller.text.isEmpty;

  // Focuses the field, or brings the keyboard back when it already has focus,
  // with the caret at the end when there is no valid selection.
  void _requestKeyboard() {
    final controller = _controller;
    if (!controller.selection.isValid) {
      controller.selection = TextSelection.collapsed(
        offset: controller.text.length,
      );
    }
    if (_focusNode.hasFocus) {
      _inputKey.currentState?.editableTextKey.currentState?.requestKeyboard();
    } else {
      _focusNode.requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final shadTheme = ShadTheme.of(context);
    final palette = context.zamPalette;
    final zeroInsets = context.zam.insets.zero;
    final textStyle = shadTheme.textTheme.muted
        .copyWith(color: palette.foreground)
        .merge(shadTheme.inputTheme.style)
        .merge(widget.style);
    final placeholderStyle = textStyle
        .copyWith(color: palette.placeholderText)
        .merge(widget.placeholderStyle);

    final input = ShadInput(
      key: _inputKey,
      controller: _controller,
      focusNode: _focusNode,
      decoration: ShadDecoration.none,
      padding: zeroInsets,
      inputPadding: zeroInsets,
      // No minimum height beyond the one line EditableText itself takes.
      constraints: const BoxConstraints(),
      style: textStyle,
      textAlign: widget.textAlign,
      keyboardType: widget.keyboardType,
      textInputAction: widget.textInputAction,
      textCapitalization: widget.textCapitalization,
      autofocus: widget.autofocus,
      readOnly: widget.readOnly,
      obscureText: widget.obscureText,
      autocorrect: widget.autocorrect,
      enableSuggestions: widget.enableSuggestions,
      enableIMEPersonalizedLearning: widget.enableIMEPersonalizedLearning,
      smartDashesType: widget.smartDashesType,
      smartQuotesType: widget.smartQuotesType,
      minLines: widget.minLines,
      maxLines: widget.maxLines,
      maxLength: widget.maxLength,
      inputFormatters: widget.inputFormatters,
      autofillHints: widget.autofillHints,
      onChanged: widget.onChanged,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      onPressedOutside: widget.onTapOutside,
      cursorColor: widget.cursorColor,
      selectionColor: widget.selectionColor ?? palette.selection,
      scrollPadding: widget.scrollPadding,
      scrollController: widget.scrollController,
      scrollPhysics: widget.scrollPhysics,
      selectionControls: _zamTextSelectionControls,
      magnifierConfiguration: _zamMagnifierConfiguration(),
      contextMenuBuilder: _zamEditableTextContextMenu,
    );

    final placeholderContent =
        widget.placeholder ??
        (widget.placeholderText == null ? null : Text(widget.placeholderText!));
    final placeholder = placeholderContent == null
        ? null
        : ValueListenableBuilder<bool>(
            valueListenable: _isEmpty,
            // The field announces placeholderText as its hint instead.
            child: IgnorePointer(
              child: ExcludeSemantics(
                child: SizedBox(
                  width: double.infinity,
                  child: DefaultTextStyle(
                    style: placeholderStyle,
                    textAlign: widget.textAlign,
                    maxLines: widget.placeholderMaxLines,
                    overflow: widget.placeholderMaxLines == null
                        ? TextOverflow.clip
                        : TextOverflow.ellipsis,
                    child: placeholderContent,
                  ),
                ),
              ),
            ),
            builder: (context, isEmpty, child) {
              if (isEmpty) return child!;
              if (widget.maintainPlaceholderSize) {
                return Visibility.maintain(visible: false, child: child!);
              }
              return const SizedBox.shrink();
            },
          );

    final field = Stack(
      alignment: widget.verticalAlignment,
      children: [
        // A tap where the field is taller than its text, such as below a
        // short line under a wrapped placeholder, still focuses it.
        Positioned.fill(
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            excludeFromSemantics: true,
            onTap: _requestKeyboard,
          ),
        ),
        ?placeholder,
        input,
      ],
    );

    final canEdit = widget.enabled && !widget.readOnly;
    final semanticsMaxLength = widget.maxLength != null && widget.maxLength! > 0
        ? widget.maxLength
        : null;

    return ExcludeFocus(
      excluding: !widget.enabled,
      child: ListenableBuilder(
        listenable: _controller,
        child: IgnorePointer(ignoring: !widget.enabled, child: field),
        // shad's input holds a scroll view between this and the text field
        // node, so the label would land on a node of its own. Merging makes
        // one text field node with the label, hint and state.
        builder: (context, child) => MergeSemantics(
          child: Semantics(
            label: widget.semanticsLabel,
            hint: _controller.text.isEmpty ? widget.placeholderText : null,
            enabled: widget.enabled,
            validationResult: widget.semanticsValidationResult,
            maxValueLength: semanticsMaxLength,
            currentValueLength: semanticsMaxLength == null
                ? null
                : _controller.text.characters.length,
            onTap: canEdit ? _requestKeyboard : null,
            // The platform asks for focus, for example when a screen reader
            // user moves to the field on the web.
            onFocus: widget.enabled ? _requestKeyboard : null,
            child: child,
          ),
        ),
      ),
    );
  }
}
