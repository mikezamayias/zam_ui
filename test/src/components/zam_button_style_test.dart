import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

const _fill = Color(0xFF004C98);
const _label = Color(0xFFFFFFFF);
const _pressedFill = Color(0xFF1A5DA1);
const _disabledFill = Color(0xFFE4EBF3);
const _disabledLabel = Color(0xFF5B6675);

ZamButton _labeled({
  VoidCallback? onPressed,
  bool? enabled,
  Color? backgroundColor,
  Color? foregroundColor,
  Color? pressedBackgroundColor,
  Color? disabledBackgroundColor,
  Color? disabledForegroundColor,
  BorderRadius? borderRadius,
  TextStyle? textStyle,
}) =>
    ZamButton(
      label: 'Save',
      onPressed: onPressed,
      enabled: enabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      borderRadius: borderRadius,
      textStyle: textStyle,
    );

ZamButton _childOnly({
  VoidCallback? onPressed,
  bool? enabled,
  Color? backgroundColor,
  Color? foregroundColor,
  Color? pressedBackgroundColor,
  Color? disabledBackgroundColor,
  Color? disabledForegroundColor,
  BorderRadius? borderRadius,
  TextStyle? textStyle,
}) =>
    ZamButton(
      onPressed: onPressed,
      enabled: enabled,
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      pressedBackgroundColor: pressedBackgroundColor,
      disabledBackgroundColor: disabledBackgroundColor,
      disabledForegroundColor: disabledForegroundColor,
      borderRadius: borderRadius,
      textStyle: textStyle,
      child: const Text('Save'),
    );

ShadDecoration _decoration(WidgetTester tester) => tester
    .widget<ShadDecorator>(
      find.descendant(
        of: find.byType(ZamButton),
        matching: find.byType(ShadDecorator),
      ),
    )
    .decoration!;

TextStyle _labelStyle(WidgetTester tester) => tester
    .widget<RichText>(
      find.descendant(
        of: find.byType(ZamButton),
        matching: find.byType(RichText),
      ),
    )
    .text
    .style!;

Iterable<Opacity> _opacities(WidgetTester tester) => tester.widgetList<Opacity>(
      find.descendant(
        of: find.byType(ZamButton),
        matching: find.byType(Opacity),
      ),
    );

int _buttonNodes(WidgetTester tester) => find.semantics
    .byPredicate(
      (node) =>
          !node.isMergedIntoParent &&
          node.getSemanticsData().flagsCollection.isButton,
    )
    .evaluate()
    .length;

void main() {
  // The same button with a label or with only a child.
  const forms = {'labeled': _labeled, 'child-only': _childOnly};

  for (final MapEntry(key: form, value: build) in forms.entries) {
    group('$form ZamButton', () {
      testWidgets('draws the fill and label color overrides', (tester) async {
        await tester.pumpApp(
          build(
            onPressed: () {},
            backgroundColor: _fill,
            foregroundColor: _label,
          ),
        );

        expect(_decoration(tester).color, _fill);
        expect(_labelStyle(tester).color, _label);
      });

      testWidgets('draws the pressed fill while pressed', (tester) async {
        await tester.pumpApp(
          build(
            onPressed: () {},
            backgroundColor: _fill,
            foregroundColor: _label,
            pressedBackgroundColor: _pressedFill,
          ),
        );

        final gesture = await tester.startGesture(
          tester.getCenter(find.byType(ZamButton)),
        );
        await tester.pump();

        expect(_decoration(tester).color, _pressedFill);
        expect(_labelStyle(tester).color, _label);

        await gesture.up();
        await tester.pump();
        expect(_decoration(tester).color, _fill);
      });

      testWidgets('applies the radius and text style overrides', (
        tester,
      ) async {
        final radius = BorderRadius.circular(24);
        await tester.pumpApp(
          build(
            onPressed: () {},
            foregroundColor: _label,
            borderRadius: radius,
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        );

        final decoration = _decoration(tester);
        expect(decoration.border!.radius, radius);
        final ring = decoration.secondaryFocusedBorder!;
        expect(
          ring.radius,
          radius + BorderRadius.circular(ring.offset ?? 0),
        );

        final style = _labelStyle(tester);
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.color, _label);
      });

      testWidgets('keeps the 50% fade when disabled without overrides', (
        tester,
      ) async {
        await tester.pumpApp(build());

        expect(
          _opacities(tester).where((o) => o.opacity == .5),
          hasLength(1),
        );
      });
    });
  }

  group('disabled colors', () {
    testWidgets(
      'draws disabled colors at full opacity as one disabled node',
      (tester) async {
        final handle = tester.ensureSemantics();
        var taps = 0;
        await tester.pumpApp(
          _labeled(
            onPressed: () => taps++,
            enabled: false,
            backgroundColor: _fill,
            foregroundColor: _label,
            disabledBackgroundColor: _disabledFill,
            disabledForegroundColor: _disabledLabel,
          ),
        );

        expect(_opacities(tester).where((o) => o.opacity < 1), isEmpty);
        expect(_decoration(tester).color, _disabledFill);
        expect(_labelStyle(tester).color, _disabledLabel);

        await tester.tap(find.byType(ZamButton), warnIfMissed: false);
        await tester.pump();
        expect(taps, 0);

        expect(_buttonNodes(tester), 1);
        expect(
          tester.getSemantics(find.bySemanticsLabel('Save')),
          isSemantics(
            label: 'Save',
            isButton: true,
            isEnabled: false,
            isFocusable: false,
            hasTapAction: false,
          ),
        );
        handle.dispose();
      },
    );

    test('need a label', () {
      expect(
        () => _childOnly(disabledBackgroundColor: _disabledFill),
        throwsAssertionError,
      );
      expect(
        () => _childOnly(disabledForegroundColor: _disabledLabel),
        throwsAssertionError,
      );
    });
  });
}
