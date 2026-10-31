import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

int _tappableNodes(WidgetTester tester) => find.semantics
    .byPredicate(
      (node) =>
          !node.isMergedIntoParent &&
          node.getSemanticsData().hasAction(SemanticsAction.tap),
    )
    .evaluate()
    .length;

void main() {
  testWidgets('an enabled button is one tappable node with its label', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(ZamButton(label: 'Save', onPressed: () {}));

    expect(_tappableNodes(tester), 1);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Save')),
      isSemantics(
        label: 'Save',
        isButton: true,
        isEnabled: true,
        hasTapAction: true,
      ),
    );
    handle.dispose();
  });

  testWidgets('a disabled button keeps its label to itself', (tester) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(
      Semantics(
        container: true,
        label: 'Card',
        child: const ZamButton(label: 'Save'),
      ),
    );

    expect(find.bySemanticsLabel('Card'), findsOneWidget);
    expect(
      tester.getSemantics(find.bySemanticsLabel('Save')),
      isSemantics(
        label: 'Save',
        isButton: true,
        isEnabled: false,
        hasTapAction: false,
      ),
    );
    expect(_tappableNodes(tester), 0);
    handle.dispose();
  });

  testWidgets('a button without a label reads its child once', (
    tester,
  ) async {
    final handle = tester.ensureSemantics();
    await tester.pumpApp(
      ZamButton(onPressed: () {}, child: const Text('Share')),
    );

    expect(_tappableNodes(tester), 1);
    expect(find.bySemanticsLabel('Share'), findsOneWidget);
    handle.dispose();
  });
}
