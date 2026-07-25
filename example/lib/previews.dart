import 'package:flutter/widget_previews.dart';
import 'package:flutter/widgets.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/zam_ui.dart';
import 'package:zam_ui_example/presets.dart';

Widget _themed(Widget child) {
  return ZamTheme(
    data: wellnessPreset.light,
    child: ShadApp(home: Center(child: child)),
  );
}

// -- Buttons --

@Preview(name: 'Primary', group: 'Buttons')
Widget primaryButtonPreview() => _themed(
      ZamButton(label: 'Label', onPressed: () {}),
    );

@Preview(name: 'Secondary', group: 'Buttons')
Widget secondaryButtonPreview() => _themed(
      ZamButton(
        label: 'Label',
        variant: ZamButtonVariant.secondary,
        onPressed: () {},
      ),
    );

@Preview(name: 'Outline', group: 'Buttons')
Widget outlineButtonPreview() => _themed(
      ZamButton(
        label: 'Label',
        variant: ZamButtonVariant.outline,
        onPressed: () {},
      ),
    );

@Preview(name: 'Ghost', group: 'Buttons')
Widget ghostButtonPreview() => _themed(
      ZamButton(
        label: 'Label',
        variant: ZamButtonVariant.ghost,
        onPressed: () {},
      ),
    );

@Preview(name: 'Link', group: 'Buttons')
Widget linkButtonPreview() => _themed(
      ZamButton(
        label: 'Label',
        variant: ZamButtonVariant.link,
        onPressed: () {},
      ),
    );

@Preview(name: 'Icon Button', group: 'Buttons')
Widget iconButtonPreview() => _themed(
      ZamIconButton(
        icon: const Icon(LucideIcons.plus),
        semanticLabel: 'Add',
        onPressed: () {},
      ),
    );

// -- Containers --

@Preview(name: 'Surface (Flat)', group: 'Containers')
Widget surfaceFlatPreview() => _themed(
      const ZamSurface(child: Text('Surface content')),
    );

@Preview(name: 'Surface (Elevated)', group: 'Containers')
Widget surfaceElevatedPreview() => _themed(
      const ZamSurface(withShadow: true, child: Text('Elevated surface')),
    );

// -- Layout --

@Preview(name: 'Screen Header', group: 'Layout')
Widget screenHeaderPreview() => _themed(
      const ZamScreenHeader(
        title: 'Screen Title',
        subtitle: 'Optional subtitle',
      ),
    );

@Preview(name: 'Section Header', group: 'Layout')
Widget sectionHeaderPreview() => _themed(
      const ZamSectionHeader(
        title: 'Section',
        subtitle: 'Description',
      ),
    );

// -- Data --

@Preview(name: 'Stat Tile', group: 'Data')
Widget statTilePreview() => _themed(
      const ZamStatTile(label: 'USERS', value: '1,234'),
    );

// -- Inputs --

@Preview(name: 'Filter Pill (Selected)', group: 'Inputs')
Widget filterPillSelectedPreview() => _themed(
      ZamFilterPill(label: 'Active', selected: true, onTap: () {}),
    );

@Preview(name: 'Filter Pill (Unselected)', group: 'Inputs')
Widget filterPillUnselectedPreview() => _themed(
      ZamFilterPill(label: 'Active', selected: false, onTap: () {}),
    );

// -- Feedback --

@Preview(name: 'Empty State', group: 'Feedback')
Widget emptyStatePreview() => _themed(
      const ZamEmptyState(
        icon: LucideIcons.inbox,
        title: 'No items',
        message: 'There are no items to display.',
      ),
    );

@Preview(name: 'Skeleton', group: 'Feedback', size: Size(300, 100))
Widget skeletonPreview() => _themed(
      const ZamSkeleton(
        child: SizedBox.expand(),
      ),
    );

@Preview(name: 'Toast Content', group: 'Feedback')
Widget toastContentPreview() => _themed(
      ZamToastContent(
        style: wellnessPreset.light.toastStyle(
          Brightness.light,
          ZamToastVariant.success,
        ),
        title: 'Success',
        description: const Text('Operation completed.'),
      ),
    );
