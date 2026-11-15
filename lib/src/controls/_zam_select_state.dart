part of '../controls.dart';

class _ZamSelectState<T> extends State<ZamSelect<T>> {
  final _popover = ShadPopoverController();
  late final ShadSelectController<T> _selection = ShadSelectController<T>(
    initialValue: _chosenValues(),
  );

  FocusNode? _ownFocusNode;

  FocusNode get _focusNode =>
      widget.focusNode ?? (_ownFocusNode ??= FocusNode());

  bool get _enabled => widget.onChanged != null;

  ZamSelectOption<T>? get _chosen {
    for (final option in widget.options) {
      if (option.value == widget.value) return option;
    }
    return null;
  }

  Set<T> _chosenValues() => {?_chosen?.value};

  @override
  void didUpdateWidget(covariant ZamSelect<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    _selection.value = _chosenValues();
    if (!_enabled) _popover.hide();
  }

  @override
  void dispose() {
    _popover.dispose();
    _selection.dispose();
    _ownFocusNode?.dispose();
    super.dispose();
  }

  // shad updates its selection before calling back. Restoring it keeps
  // [ZamSelect.value] the only source of truth, so a parent that ignores the
  // pick keeps showing the old option.
  void _onShadChanged(T? value) {
    _selection.value = _chosenValues();
    if (value is T && _enabled) widget.onChanged!(value);
  }

  // The screen reader tap action of an option, which bypasses shad's row.
  void _pick(T value) {
    _popover.hide();
    _focusNode.requestFocus();
    if (value != widget.value) widget.onChanged?.call(value);
  }

  // The trigger's semantics node belongs to shad's popover, which hosts the
  // option list as its child and supplies the focus and tap actions. This
  // annotation sits inside the trigger, so it merges into that node and adds
  // the role, the name, the value and the expanded state.
  Widget _trigger(Widget visible, {required String? valueLabel}) =>
      ListenableBuilder(
        listenable: _popover,
        builder: (context, child) => Semantics(
          button: true,
          enabled: true,
          expanded: _popover.isOpen,
          label: widget.semanticLabel,
          value: valueLabel,
          child: child,
        ),
        child: ExcludeSemantics(child: visible),
      );

  Widget _content(ZamSelectOption<T> option, ZamThemeData theme) {
    final label = Text(
      option.label,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
    final leading = option.leading;
    if (leading == null) return label;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ExcludeSemantics(child: leading),
        SizedBox(width: theme.spacing.sm),
        Flexible(child: label),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final palette = context.zamPalette;
    final strokes = theme.strokes;
    final radius = theme.radius.md;
    final ring = strokes.focusRing;
    final tapTarget = theme.sizes.minTapTarget;
    final chosen = _chosen;

    final select = ShadSelect<T>(
      controller: _selection,
      popoverController: _popover,
      focusNode: _focusNode,
      enabled: _enabled,
      minHeight: tapTarget,
      padding: theme.insets.symmetric(horizontal: theme.spacing(3)),
      decoration: ShadDecoration(
        border: ShadBorder.all(
          width: strokes.hairline,
          color: palette.input,
          radius: radius,
        ),
        focusedBorder: ShadBorder.all(
          width: strokes.hairline,
          color: palette.input,
          radius: radius,
        ),
        secondaryFocusedBorder: ShadBorder.all(
          width: ring,
          color: palette.ring,
          radius: radius.add(BorderRadius.circular(ring)),
          offset: ring,
        ),
      ),
      placeholder: _trigger(
        Text(
          widget.placeholder ?? '',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        valueLabel: widget.placeholder,
      ),
      selectedOptionBuilder: (context, value) {
        for (final option in widget.options) {
          if (option.value == value) {
            return _trigger(_content(option, theme), valueLabel: option.label);
          }
        }
        return const SizedBox.shrink();
      },
      onChanged: _onShadChanged,
      options: [
        for (final option in widget.options)
          Semantics(
            container: true,
            button: true,
            inMutuallyExclusiveGroup: true,
            selected: identical(option, chosen),
            label: option.label,
            onTap: () => _pick(option.value),
            excludeSemantics: true,
            child: ShadOption<T>(
              value: option.value,
              padding: theme.insets.symmetric(horizontal: theme.spacing.sm),
              radius: theme.radius.sm,
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: tapTarget),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _content(option, theme),
                ),
              ),
            ),
          ),
      ],
    );

    // shad's trigger keeps its tap action while disabled, so a disabled
    // select hides it and reads as one disabled button. The wrapper stays in
    // the tree while enabled, so toggling onChanged keeps shad's state.
    final disabled = !_enabled;
    return Semantics(
      container: disabled,
      button: disabled ? true : null,
      enabled: disabled ? false : null,
      label: disabled ? widget.semanticLabel : null,
      value: disabled ? chosen?.label ?? widget.placeholder : null,
      excludeSemantics: disabled,
      child: select,
    );
  }
}
