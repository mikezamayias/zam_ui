part of '../components.dart';

class ZamDivider extends StatelessWidget {
  const ZamDivider({
    super.key,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
    this.vertical = false,
  });

  const ZamDivider.vertical({
    super.key,
    this.color,
    this.thickness,
    this.indent,
    this.endIndent,
  }) : vertical = true;

  final Color? color;
  final double? thickness;
  final double? indent;
  final double? endIndent;
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
