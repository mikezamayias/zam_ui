import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

Widget _list({Axis axis = Axis.vertical}) => ListView(
  scrollDirection: axis,
  children: [
    for (var i = 0; i < 50; i++)
      SizedBox.square(dimension: 50, child: Text('$i')),
  ],
);

void main() {
  group('ZamScrollBehavior', () {
    testWidgets(
      'draws a ZamScrollbar on vertical lists',
      (tester) async {
        await tester.pumpApp(_list());

        expect(find.byType(ZamScrollbar), findsOneWidget);
        expect(find.byType(RawScrollbar), findsOneWidget);
      },
      variant: const TargetPlatformVariant({
        TargetPlatform.iOS,
        TargetPlatform.macOS,
        TargetPlatform.linux,
        TargetPlatform.windows,
      }),
    );

    testWidgets(
      'draws no scrollbar on Android and Fuchsia',
      (tester) async {
        await tester.pumpApp(_list());

        expect(find.byType(ZamScrollbar), findsNothing);
        expect(find.byType(RawScrollbar), findsNothing);
      },
      variant: const TargetPlatformVariant({
        TargetPlatform.android,
        TargetPlatform.fuchsia,
      }),
    );

    testWidgets('draws no scrollbar on horizontal lists', (tester) async {
      await tester.pumpApp(_list(axis: Axis.horizontal));

      expect(find.byType(RawScrollbar), findsNothing);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('bounces on iOS', (tester) async {
      late ScrollPhysics physics;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            physics = ScrollConfiguration.of(context).getScrollPhysics(context);
            return const SizedBox();
          },
        ),
      );

      expect(physics, isA<BouncingScrollPhysics>());
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));

    testWidgets('clamps on Android', (tester) async {
      late ScrollPhysics physics;
      await tester.pumpApp(
        Builder(
          builder: (context) {
            physics = ScrollConfiguration.of(context).getScrollPhysics(context);
            return const SizedBox();
          },
        ),
      );

      expect(physics, isA<ClampingScrollPhysics>());
    }, variant: TargetPlatformVariant.only(TargetPlatform.android));
  });

  group('ZamScrollbar', () {
    testWidgets('passes its options to the thumb', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      const color = Color(0xFF00FF00);
      await tester.pumpApp(
        ZamScrollbar(
          controller: controller,
          thumbVisibility: true,
          thickness: 4,
          thumbColor: color,
          child: ListView(
            controller: controller,
            children: [
              for (var i = 0; i < 50; i++)
                SizedBox(height: 50, child: Text('$i')),
            ],
          ),
        ),
      );

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(scrollbar.controller, controller);
      expect(scrollbar.thumbVisibility, isTrue);
      expect(scrollbar.thickness, 4);
      expect(scrollbar.thumbColor, color);
    });

    testWidgets('defaults to the palette border and replaces the behavior '
        'scrollbar', (tester) async {
      await tester.pumpApp(ZamScrollbar(child: _list()));

      final scrollbar = tester.widget<RawScrollbar>(find.byType(RawScrollbar));
      expect(scrollbar.thumbColor, testTheme.palette(Brightness.light).border);
      expect(scrollbar.thumbVisibility, isFalse);
      expect(find.byType(RawScrollbar), findsOneWidget);
    }, variant: TargetPlatformVariant.only(TargetPlatform.iOS));
  });
}
