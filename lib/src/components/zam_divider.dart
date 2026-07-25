part of '../components.dart';

/// Tokenized horizontal and vertical divider component.
class ZamDivider extends StatelessWidget {
  /// Creates a horizontal [ZamDivider].
  const ZamDivider({
    super.key,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
    this.vertical = false,
  });

  /// Creates a vertical [ZamDivider].
  const ZamDivider.vertical({
    super.key,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
  }) : vertical = true;

  /// Custom divider color.
  final Color? color;

  /// Custom stroke thickness.
  final double? thickness;

  /// Leading indent padding.
  final double? indent;

  /// Trailing indent padding.
  final double? endIndent;

  /// Whether the divider is orientation vertical.
  final bool vertical;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;
    final effectiveColor = color ?? scheme.border;
    final effectiveThickness = thickness ?? theme.strokes.hairline;

    if (vertical) {
      return Padding(
        padding: EdgeInsets.only(
          top: indent ?? theme.spacing.zero,
          bottom: endIndent ?? theme.spacing.zero,
        ),
        child: SizedBox(
          width: effectiveThickness,
          child: ColoredBox(color: effectiveColor),
        ),
      );
    }

    return Padding(
      padding: EdgeInsets.only(
        left: indent ?? theme.spacing.zero,
        right: endIndent ?? theme.spacing.zero,
      ),
      child: SizedBox(
        height: effectiveThickness,
        width: double.infinity,
        child: ColoredBox(color: effectiveColor),
      ),
    );
  }
}
