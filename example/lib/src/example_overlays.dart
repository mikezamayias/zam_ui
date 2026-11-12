part of '../main.dart';

Future<void> _showExampleDialog(BuildContext context) {
  return showZamDialog<void>(
    context: context,
    builder: (dialogContext) {
      final theme = dialogContext.zam;
      return ZamDialogSurface(
        child: Padding(
          padding: theme.insets.card,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const ZamSectionHeader(
                title: 'Fade-only dialog',
                subtitle: 'No blur, focus stays inside until it closes.',
              ),
              SizedBox(height: theme.spacing.md),
              ZamButton(
                label: 'Close',
                onPressed: () => Navigator.of(dialogContext).pop(),
              ),
            ],
          ),
        ),
      );
    },
  );
}

Future<void> _showExampleSheet(BuildContext context) {
  return showZamSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      final theme = sheetContext.zam;
      return Padding(
        padding: theme.insets.card,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const ZamSectionHeader(
              title: 'Bottom sheet',
              subtitle: 'Swipe down, tap the barrier or go back to close.',
            ),
            SizedBox(height: theme.spacing.md),
            ZamButton(
              label: 'Done',
              onPressed: () => Navigator.of(sheetContext).pop(),
            ),
          ],
        ),
      );
    },
  );
}

void _showExampleToast(BuildContext context) {
  final palette = context.zamPalette;
  final theme = context.zam;
  ZamToast.showCustom(
    context,
    semanticLabel: 'Saved',
    content: DecoratedBox(
      decoration: BoxDecoration(
        color: palette.primary,
        borderRadius: theme.radius.lg,
      ),
      child: Padding(
        padding: theme.insets.card,
        child: Text(
          'Saved',
          style: TextStyle(color: palette.primaryForeground),
        ),
      ),
    ),
  );
}
