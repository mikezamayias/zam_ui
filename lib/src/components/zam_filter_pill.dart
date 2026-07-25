part of '../components.dart';

/// Filter pill button component supporting toggle selection states.
class ZamFilterPill extends StatelessWidget {
  /// Creates a [ZamFilterPill].
  const ZamFilterPill({
    required this.label,
    required this.selected,
    required this.onTap,
    super.key,
  });

  /// Filter pill label text.
  final String label;

  /// Whether the pill is selected.
  final bool selected;

  /// Tap selection callback.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = context.zam;
    final scheme = ShadTheme.of(context).colorScheme;

    return Semantics(
      button: true,
      selected: selected,
      label: label,
      onTap: onTap,
      child: GestureDetector(
        onTap: onTap,
        child: ConstrainedBox(
          constraints: theme.sizes.minTapTargetConstraints,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: selected ? scheme.secondary : theme.colors.transparent,
              borderRadius: theme.radius.pill,
              border:
                  Border.fromBorderSide(theme.strokes.border(scheme.border)),
            ),
            child: Padding(
              padding: theme.insets.symmetric(
                horizontal: theme.spacing.twelve,
                vertical: theme.spacing.six,
              ),
              child: Text(
                label,
                style:
                    theme.typography.label(context, color: scheme.foreground),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
