part of '../overlays.dart';

/// The pill that marks a sheet as draggable.
///
/// Screen readers get a dismiss button, because they cannot drag.
class _ZamSheetHandle extends StatelessWidget {
  const _ZamSheetHandle({required this.label, required this.onDismiss});

  final String label;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final palette = context.zamPalette;

    return Semantics(
      button: true,
      label: label,
      onTap: onDismiss,
      excludeSemantics: true,
      child: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: theme.spacing(3)),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: palette.mutedControl,
              borderRadius: theme.radius.pill,
            ),
            child: SizedBox(
              width: theme.spacing(8),
              height: theme.spacing.xs,
            ),
          ),
        ),
      ),
    );
  }
}
