import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

const _labels = ZamReorderLabels(
  moveUp: 'Pano',
  moveDown: 'Kato',
  moveToStart: 'Stin arxi',
  moveToEnd: 'Sto telos',
);

Widget _list({
  required List<(int, int)> moves,
  int count = 3,
  ZamReorderLabels labels = const ZamReorderLabels(),
  ReorderItemProxyDecorator? proxyDecorator,
  Widget Function(int index)? item,
}) => Align(
  alignment: Alignment.topCenter,
  child: SizedBox(
    height: 300,
    child: ZamReorderableList(
      itemCount: count,
      labels: labels,
      proxyDecorator: proxyDecorator,
      onReorderItem: (oldIndex, newIndex) => moves.add((oldIndex, newIndex)),
      itemBuilder: (context, index) =>
          item?.call(index) ??
          SizedBox(
            key: ValueKey(index),
            height: 50,
            child: Text('Item $index'),
          ),
    ),
  ),
);

Set<String> _actions(WidgetTester tester, String item) {
  final data = tester.getSemantics(find.text(item)).getSemanticsData();
  return {
    for (final id in data.customSemanticsActionIds ?? <int>[])
      CustomSemanticsAction.getAction(id)!.label!,
  };
}

void _perform(WidgetTester tester, String item, String label) {
  final node = tester.getSemantics(find.text(item));
  final id = (node.getSemanticsData().customSemanticsActionIds ?? <int>[])
      .firstWhere((id) => CustomSemanticsAction.getAction(id)!.label == label);
  tester.semantics.performAction(
    find.semantics.byLabel(item),
    SemanticsAction.customAction,
    args: id,
  );
}

Future<void> _longPressDrag(
  WidgetTester tester,
  String item,
  Offset offset,
) async {
  final gesture = await tester.startGesture(tester.getCenter(find.text(item)));
  await tester.pump(kLongPressTimeout + kPressTimeout);
  await gesture.moveBy(offset / 4);
  await tester.pump(const Duration(milliseconds: 50));
  await gesture.moveBy(offset * 3 / 4);
  await tester.pump(const Duration(milliseconds: 50));
  await gesture.up();
  await tester.pumpAndSettle();
}

void main() {
  group('ZamReorderLabels', () {
    test('defaults to English wording', () {
      const labels = ZamReorderLabels();
      expect(labels.moveUp, 'Move up');
      expect(labels.moveDown, 'Move down');
      expect(labels.moveToStart, 'Move to the start');
      expect(labels.moveToEnd, 'Move to the end');
    });

    test('differs in every label', () {
      const base = ZamReorderLabels();
      expect(base, isNot(const ZamReorderLabels(moveUp: 'x')));
      expect(base, isNot(const ZamReorderLabels(moveDown: 'x')));
      expect(base, isNot(const ZamReorderLabels(moveToStart: 'x')));
      expect(base, isNot(const ZamReorderLabels(moveToEnd: 'x')));
      expect(base == Object(), isFalse);
    });

    test('compares by value', () {
      expect(const ZamReorderLabels(), const ZamReorderLabels());
      expect(
        const ZamReorderLabels().hashCode,
        const ZamReorderLabels().hashCode,
      );
      expect(const ZamReorderLabels(), isNot(_labels));
    });
  });

  group('ZamReorderableList', () {
    testWidgets('builds its items', (tester) async {
      await tester.pumpApp(_list(moves: []));

      expect(find.text('Item 0'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('reports a long press drag with the adjusted index', (
      tester,
    ) async {
      final moves = <(int, int)>[];
      await tester.pumpApp(_list(moves: moves));

      await _longPressDrag(tester, 'Item 0', const Offset(0, 80));

      expect(moves, [(0, 2)]);
    });

    testWidgets('does not drag on a plain swipe on a touch platform', (
      tester,
    ) async {
      final moves = <(int, int)>[];
      await tester.pumpApp(_list(moves: moves));

      await tester.drag(find.text('Item 0'), const Offset(0, 60));
      await tester.pumpAndSettle();

      expect(moves, isEmpty);
    });

    testWidgets('drags at once on a desktop platform', (tester) async {
      debugDefaultTargetPlatformOverride = TargetPlatform.macOS;
      addTearDown(() => debugDefaultTargetPlatformOverride = null);
      final moves = <(int, int)>[];
      await tester.pumpApp(_list(moves: moves));

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Item 0')),
      );
      await gesture.moveBy(const Offset(0, 30));
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.moveBy(const Offset(0, 40));
      await tester.pump(const Duration(milliseconds: 100));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(moves, [(0, 1)]);
    });

    testWidgets('decorates the dragged item through proxyDecorator', (
      tester,
    ) async {
      final decorated = <int>[];
      await tester.pumpApp(
        _list(
          moves: [],
          proxyDecorator: (child, index, animation) {
            decorated.add(index);
            return child;
          },
        ),
      );

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Item 1')),
      );
      await tester.pump(kLongPressTimeout + const Duration(milliseconds: 100));
      await gesture.moveBy(const Offset(0, 5));
      await tester.pump();
      await gesture.up();
      await tester.pumpAndSettle();

      expect(decorated, contains(1));
    });

    testWidgets('offers only the moves that are possible', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(_list(moves: [], labels: _labels));

      expect(_actions(tester, 'Item 0'), {'Kato', 'Sto telos'});
      expect(_actions(tester, 'Item 1'), {
        'Pano',
        'Kato',
        'Stin arxi',
        'Sto telos',
      });
      expect(_actions(tester, 'Item 2'), {'Pano', 'Stin arxi'});
      handle.dispose();
    });

    testWidgets('words the actions once, with the default labels too', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(_list(moves: []));

      final data = tester.getSemantics(find.text('Item 1')).getSemanticsData();
      expect(data.customSemanticsActionIds, hasLength(4));
      expect(_actions(tester, 'Item 1'), {
        'Move up',
        'Move down',
        'Move to the start',
        'Move to the end',
      });
      handle.dispose();
    });

    testWidgets('semantic actions report already adjusted indexes', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final moves = <(int, int)>[];
      await tester.pumpApp(_list(moves: moves, count: 4, labels: _labels));

      _perform(tester, 'Item 1', 'Kato');
      _perform(tester, 'Item 2', 'Pano');
      _perform(tester, 'Item 2', 'Stin arxi');
      _perform(tester, 'Item 1', 'Sto telos');

      expect(moves, [(1, 2), (2, 1), (2, 0), (1, 3)]);
      handle.dispose();
    });

    testWidgets('forwards every other wording to the app localizations', (
      tester,
    ) async {
      WidgetsLocalizations? seen;
      WidgetsLocalizations? app;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            app = WidgetsLocalizations.of(context);
            return _list(
              moves: [],
              labels: _labels,
              item: (index) => Builder(
                key: ValueKey(index),
                builder: (context) {
                  seen = WidgetsLocalizations.of(context);
                  return SizedBox(height: 50, child: Text('Item $index'));
                },
              ),
            );
          },
        ),
      );

      final local = seen!;
      final base = app!;
      expect(local.reorderItemUp, 'Pano');
      expect(local.reorderItemLeft, base.reorderItemLeft);
      expect(local.reorderItemRight, base.reorderItemRight);
      expect(local.searchResultsFound, base.searchResultsFound);
      expect(local.noResultsFound, base.noResultsFound);
      expect(local.copyButtonLabel, base.copyButtonLabel);
      expect(local.cutButtonLabel, base.cutButtonLabel);
      expect(local.pasteButtonLabel, base.pasteButtonLabel);
      expect(local.selectAllButtonLabel, base.selectAllButtonLabel);
      expect(local.lookUpButtonLabel, base.lookUpButtonLabel);
      expect(local.searchWebButtonLabel, base.searchWebButtonLabel);
      expect(local.shareButtonLabel, base.shareButtonLabel);
      expect(
        local.radioButtonUnselectedLabel,
        base.radioButtonUnselectedLabel,
      );
      expect(local.textDirection, TextDirection.ltr);
    });

    testWidgets('keeps the ambient text direction', (tester) async {
      TextDirection? direction;
      await tester.pumpApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: _list(
            moves: [],
            item: (index) => Builder(
              key: ValueKey(index),
              builder: (context) {
                direction = Directionality.of(context);
                return SizedBox(height: 50, child: Text('Item $index'));
              },
            ),
          ),
        ),
      );

      expect(direction, TextDirection.rtl);
    });

    testWidgets('follows a change of labels', (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(_list(moves: []));
      expect(_actions(tester, 'Item 0'), contains('Move down'));

      await tester.pumpApp(_list(moves: [], labels: _labels));

      expect(_actions(tester, 'Item 0'), {'Kato', 'Sto telos'});
      handle.dispose();
    });

    testWidgets('accepts items that carry a global key', (tester) async {
      final keys = List.generate(3, (_) => GlobalKey());
      await tester.pumpApp(
        _list(
          moves: [],
          item: (index) => SizedBox(
            key: keys[index],
            height: 50,
            child: Text('Item $index'),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(find.text('Item 2'), findsOneWidget);
    });

    testWidgets('requires a key on every item', (tester) async {
      await tester.pumpApp(
        _list(moves: [], item: (index) => Text('Item $index')),
      );

      expect(tester.takeException(), isAssertionError);
    });

    testWidgets('lays out in right-to-left and with padding', (tester) async {
      await tester.pumpApp(
        Directionality(
          textDirection: TextDirection.rtl,
          child: Align(
            alignment: Alignment.topCenter,
            child: SizedBox(
              height: 300,
              child: ZamReorderableList(
                itemCount: 2,
                padding: const EdgeInsetsDirectional.only(start: 20),
                onReorderItem: (_, _) {},
                itemBuilder: (context, index) => SizedBox(
                  key: ValueKey(index),
                  height: 50,
                  child: Text('Item $index'),
                ),
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull);
      expect(tester.getTopRight(find.text('Item 0')).dx, lessThan(800 - 19));
    });

    testWidgets('shrink wraps and scrolls with the given physics', (
      tester,
    ) async {
      await tester.pumpApp(
        Align(
          alignment: Alignment.topCenter,
          child: ZamReorderableList(
            itemCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            onReorderItem: (_, _) {},
            itemBuilder: (context, index) => SizedBox(
              key: ValueKey(index),
              height: 50,
              child: Text('Item $index'),
            ),
          ),
        ),
      );

      expect(tester.getSize(find.byType(ZamReorderableList)).height, 100);
    });
  });
}
