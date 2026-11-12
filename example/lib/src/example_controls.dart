part of '../main.dart';

/// Example page showing text input and the platform-neutral controls.
class ExampleControls extends StatefulWidget {
  /// Creates an [ExampleControls] page.
  const ExampleControls({super.key});

  @override
  State<ExampleControls> createState() => _ExampleControlsState();
}

class _ExampleControlsState extends State<ExampleControls> {
  final _items = <String>['Color', 'Type', 'Motion', 'Spacing'];
  bool _checked = true;
  int _taps = 0;

  void _reorder(int oldIndex, int newIndex) {
    setState(() => _items.insert(newIndex, _items.removeAt(oldIndex)));
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final palette = context.zamPalette;

    return ZamScaffold(
      body: ZamScreen(
        scrollable: true,
        padding: theme.insets.screen,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ZamScreenHeader(
              title: 'Controls',
              subtitle: 'Swipe from the leading edge on iOS to go back.',
              onBack: () => Navigator.of(context).pop(),
            ),
            SizedBox(height: theme.spacing.md),
            ZamFormField(
              label: 'Note',
              description:
                  'ZamTextField is unstyled, so the app draws the box.',
              child: ZamSurface(
                child: ZamTextField(
                  placeholderText: 'Write something',
                  minLines: 3,
                  maxLines: 6,
                  style: TextStyle(color: palette.foreground),
                ),
              ),
            ),
            SizedBox(height: theme.spacing.md),
            ZamSurface(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ZamCheckbox(
                        value: _checked,
                        semanticLabel: 'Remind me',
                        onChanged: (value) => setState(() => _checked = value),
                      ),
                      SizedBox(width: theme.spacing.sm),
                      const Text('Remind me'),
                    ],
                  ),
                  SizedBox(height: theme.spacing.md),
                  const ZamProgress(value: 0.6, semanticLabel: 'Progress'),
                  SizedBox(height: theme.spacing.md),
                  Row(
                    children: [
                      const ZamSpinner(semanticLabel: 'Loading'),
                      SizedBox(width: theme.spacing.sm),
                      const Text('Indeterminate spinner'),
                    ],
                  ),
                  SizedBox(height: theme.spacing.md),
                  ZamPressable(
                    onTap: () => setState(() => _taps++),
                    child: Padding(
                      padding: theme.insets.card,
                      child: Text('ZamPressable tapped $_taps times'),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: theme.spacing.md),
            const ZamSectionHeader(
              title: 'Reorderable list',
              subtitle: 'Long press to drag, or use the screen reader actions.',
            ),
            SizedBox(height: theme.spacing.sm),
            ZamReorderableList(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              onReorderItem: _reorder,
              itemBuilder: (context, index) => ZamListTile(
                key: ValueKey(_items[index]),
                title: _items[index],
                showDivider: index < _items.length - 1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
