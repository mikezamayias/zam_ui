import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';
import 'overlay_test_support.dart';

const _content = Key('content');

Finder get _clip => find.descendant(
  of: find.byType(ZamDialogSurface),
  matching: find.byType(ClipRRect),
);

/// An 800 by 600 view with one device pixel per logical pixel.
void _useLogicalPixels(WidgetTester tester) {
  tester.view
    ..devicePixelRatio = 1
    ..physicalSize = const Size(800, 600);
  addTearDown(tester.view.reset);
}

void main() {
  group('ZamDialogSurface', () {
    testWidgets('centers its child', (tester) async {
      await tester.pumpApp(
        const ZamDialogSurface(
          child: SizedBox(key: _content, width: 300, height: 100),
        ),
      );

      expect(tester.getCenter(find.byKey(_content)), const Offset(400, 300));
    });

    testWidgets('is at least 280 wide', (tester) async {
      await tester.pumpApp(
        const ZamDialogSurface(
          child: SizedBox(key: _content, width: 40, height: 40),
        ),
      );

      expect(tester.getSize(_clip).width, ZamDialogSurface.minWidth);
      expect(ZamDialogSurface.minWidth, 280);
    });

    testWidgets('grows with its child and obeys the maximum width', (
      tester,
    ) async {
      await tester.pumpApp(
        const ZamDialogSurface(
          constraints: BoxConstraints(maxWidth: 320),
          child: SizedBox(key: _content, width: 600, height: 40),
        ),
      );

      expect(tester.getSize(_clip).width, 320);
    });

    testWidgets('lets constraints below the minimum win', (tester) async {
      await tester.pumpApp(
        const ZamDialogSurface(
          constraints: BoxConstraints(maxWidth: 200),
          child: SizedBox(key: _content, width: 600, height: 40),
        ),
      );

      expect(tester.getSize(_clip).width, 200);
    });

    testWidgets('fills with the card color and borders with the border color', (
      tester,
    ) async {
      await tester.pumpApp(
        const ZamDialogSurface(child: SizedBox(width: 300, height: 40)),
      );
      final palette = tester.element(find.byType(ZamDialogSurface)).zamPalette;

      final fill = tester.widget<ColoredBox>(
        find.descendant(of: _clip, matching: find.byType(ColoredBox)),
      );
      expect(fill.color, palette.card);

      final border = tester
          .widgetList<DecoratedBox>(
            find.descendant(of: _clip, matching: find.byType(DecoratedBox)),
          )
          .map((box) => box.decoration)
          .whereType<BoxDecoration>()
          .firstWhere((decoration) => decoration.border != null);
      expect(border.border!.top.color, palette.border);
      expect(border.borderRadius, testTheme.radius.dialog);
    });

    testWidgets('honors color, radius and clip overrides', (tester) async {
      const red = Color(0xFFCC0000);
      const green = Color(0xFF00CC00);
      await tester.pumpApp(
        const ZamDialogSurface(
          backgroundColor: red,
          borderColor: green,
          radius: BorderRadius.all(Radius.circular(3)),
          clipBehavior: Clip.hardEdge,
          child: SizedBox(width: 300, height: 40),
        ),
      );

      final clip = tester.widget<ClipRRect>(_clip);
      expect(clip.clipBehavior, Clip.hardEdge);
      expect(clip.borderRadius, const BorderRadius.all(Radius.circular(3)));
      expect(
        tester
            .widget<ColoredBox>(
              find.descendant(of: _clip, matching: find.byType(ColoredBox)),
            )
            .color,
        red,
      );
    });

    testWidgets('colors unstyled text with the card foreground', (
      tester,
    ) async {
      await tester.pumpApp(const ZamDialogSurface(child: Text('hello')));
      final palette = tester.element(find.byType(ZamDialogSurface)).zamPalette;

      final style = DefaultTextStyle.of(tester.element(find.text('hello')));
      expect(style.style.color, palette.cardForeground);
    });

    testWidgets('applies the inset padding around the surface', (tester) async {
      await tester.pumpApp(
        const ZamDialogSurface(
          insetPadding: EdgeInsets.fromLTRB(10, 20, 30, 40),
          child: SizedBox(key: _content, width: 2000, height: 2000),
        ),
      );

      expect(
        tester.getRect(find.byKey(_content)),
        const Rect.fromLTRB(10, 20, 770, 560),
      );
    });

    testWidgets('lifts above the keyboard and removes the inset below', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      double? insetBelow;
      await tester.pumpApp(
        ZamDialogSurface(
          child: Builder(
            builder: (context) {
              insetBelow = MediaQuery.viewInsetsOf(context).bottom;
              return const SizedBox(key: _content, width: 300, height: 100);
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // The space above the keyboard is 300 tall, so the surface centers in it.
      expect(tester.getCenter(find.byKey(_content)).dy, 150);
      expect(insetBelow, 0);
    });

    testWidgets('animates the keyboard inset instead of jumping', (
      tester,
    ) async {
      _useLogicalPixels(tester);
      await tester.pumpApp(
        const ZamDialogSurface(
          child: SizedBox(key: _content, width: 300, height: 100),
        ),
      );
      expect(tester.getCenter(find.byKey(_content)).dy, 300);

      tester.view.viewInsets = const FakeViewPadding(bottom: 300);
      addTearDown(tester.view.resetViewInsets);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 50));

      final midway = tester.getCenter(find.byKey(_content)).dy;
      expect(midway, lessThan(300));
      expect(midway, greaterThan(150));
      await tester.pumpAndSettle();
      expect(tester.getCenter(find.byKey(_content)).dy, 150);
    });

    testWidgets('mirrors directional insets in right-to-left', (tester) async {
      await pumpRtlApp(
        tester,
        const ZamDialogSurface(
          insetPadding: EdgeInsetsDirectional.only(start: 100, end: 20),
          child: SizedBox(key: _content, width: 2000, height: 40),
        ),
      );

      final rect = tester.getRect(find.byKey(_content));
      expect(rect.right, 700);
      expect(rect.left, 20);
    });

    testWidgets('resolves a directional radius in right-to-left', (
      tester,
    ) async {
      await pumpRtlApp(
        tester,
        const ZamDialogSurface(
          radius: BorderRadiusDirectional.only(topStart: Radius.circular(12)),
          child: SizedBox(width: 300, height: 40),
        ),
      );

      final clip = tester.widget<ClipRRect>(_clip);
      expect(
        clip.borderRadius.resolve(TextDirection.rtl).topRight,
        const Radius.circular(12),
      );
    });
  });
}
