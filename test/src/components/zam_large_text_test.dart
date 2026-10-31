import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

const _long =
    'A considerably long title that must wrap instead of overflowing the row';

Future<void> _pumpLarge(WidgetTester tester, Widget child) async {
  tester.view.physicalSize = const Size(360, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  await tester.pumpApp(
    Builder(
      builder: (context) => MediaQuery(
        data: MediaQuery.of(
          context,
        ).copyWith(textScaler: const TextScaler.linear(2)),
        child: SingleChildScrollView(child: child),
      ),
    ),
  );
  await tester.pump();
}

void main() {
  final cases = <String, Widget Function()>{
    'ZamScreenHeader': () => ZamScreenHeader(
      title: _long,
      subtitle: _long,
      onBack: () {},
      trailing: ZamIconButton(
        icon: const Text('x'),
        semanticLabel: 'More',
        onPressed: () {},
      ),
    ),
    'ZamListTile': () => ZamListTile(
      title: _long,
      subtitle: _long,
      semanticLabel: 'Row',
      onTap: () {},
      leading: const SizedBox(width: 24, height: 24),
      trailing: const Text('Trailing'),
      showDivider: true,
    ),
    'ZamEmptyState': () => SizedBox(
      height: 700,
      child: ZamEmptyState(
        icon: const IconData(0xe88e, fontFamily: 'TestIcons'),
        title: _long,
        message: _long,
        action: ZamButton(label: 'Retry now', onPressed: () {}),
      ),
    ),
    'ZamFormField': () => const ZamFormField(
      label: _long,
      description: _long,
      error: _long,
      isRequired: true,
      child: ShadInput(),
    ),
    'ZamStatTile': () => const ZamStatTile(label: _long, value: '1,234,567'),
    'ZamFilterPill': () =>
        ZamFilterPill(label: _long, selected: true, onTap: () {}),
    'ZamDialog': () => ZamDialog(
      title: _long,
      message: _long,
      actions: [ZamButton(label: 'Confirm', onPressed: () {})],
    ),
  };

  for (final entry in cases.entries) {
    testWidgets(
      '${entry.key} does not overflow at 2x text',
      (tester) async {
        await _pumpLarge(tester, entry.value());
        expect(tester.takeException(), isNull);
      },
    );
  }
}
