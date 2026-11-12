part of '../controls.dart';

/// A checkbox that draws a box and a check mark.
///
/// It draws through shad's checkbox. The theme maps the palette onto it: the
/// checked fill is `primaryControl`, and the edge follows `primaryText` when
/// the theme sets that role. [color], [borderColor] and [checkedBorderColor]
/// override those per instance.
///
/// The box is [size] wide and tall, with shad's 1 pixel of top padding, and
/// adds no minimum hit target.
/// Callers put it in a row with their label and size the tap area they need,
/// which should be at least 44 by 44 logical pixels. The checkbox reports the
/// checked state and the tap action. Without a [semanticLabel] those merge
/// into the nearest labelled ancestor.
class ZamCheckbox extends StatelessWidget {
  /// Creates a [ZamCheckbox].
  const ZamCheckbox({
    required this.value,
    super.key,
    this.onChanged,
    this.enabled = true,
    this.size,
    this.color,
    this.borderColor,
    this.checkedBorderColor,
    this.focusNode,
    this.semanticLabel,
  });

  /// Whether the box is checked.
  final bool value;

  /// Called with the new value on a tap, on Enter and on Space.
  ///
  /// A null callback disables the checkbox.
  final ValueChanged<bool>? onChanged;

  /// Whether the checkbox reacts to input.
  final bool enabled;

  /// Width and height of the box.
  final double? size;

  /// Fill of the checked box.
  final Color? color;

  /// Color of the box edge.
  final Color? borderColor;

  /// Color of the box edge while checked, or [borderColor] when null.
  final Color? checkedBorderColor;

  /// Focus node for keyboard focus, or null to let the widget own one.
  final FocusNode? focusNode;

  /// Accessible name of the checkbox.
  final String? semanticLabel;

  @override
  Widget build(BuildContext context) {
    final interactive = enabled && onChanged != null;
    final edge = value ? (checkedBorderColor ?? borderColor) : borderColor;

    return Semantics(
      checked: value,
      label: semanticLabel,
      enabled: interactive,
      focusable: interactive,
      onTap: interactive ? () => onChanged!(!value) : null,
      child: ExcludeSemantics(
        child: ShadCheckbox(
          value: value,
          enabled: interactive,
          onChanged: onChanged,
          focusNode: focusNode,
          size: size,
          color: color,
          decoration: edge == null
              ? null
              : ShadDecoration(border: ShadBorder.all(color: edge)),
        ),
      ),
    );
  }
}
