import 'package:flutter/gestures.dart';
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

const _disabledColors = ZamButtonStyle(
  backgroundColor: _fill,
  foregroundColor: _label,
  disabledBackgroundColor: _disabledFill,
  disabledForegroundColor: _disabledLabel,
);

ZamButton _labeled({
  VoidCallback? onPressed,
  bool? enabled,
  ZamButtonStyle? style,
}) =>
    ZamButton(
      label: 'Save',
      onPressed: onPressed,
      enabled: enabled,
      style: style,
    );

ZamButton _childOnly({
  VoidCallback? onPressed,
  bool? enabled,
  ZamButtonStyle? style,
}) =>
    ZamButton(
      onPressed: onPressed,
      enabled: enabled,
      style: style,
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

ShadButtonTheme _variantTheme(WidgetTester tester, ZamButtonVariant variant) {
  final theme = ShadTheme.of(tester.element(find.byType(ZamButton)));
  return switch (variant) {
    ZamButtonVariant.primary => theme.primaryButtonTheme,
    ZamButtonVariant.secondary => theme.secondaryButtonTheme,
    ZamButtonVariant.outline => theme.outlineButtonTheme,
    ZamButtonVariant.ghost => theme.ghostButtonTheme,
    ZamButtonVariant.destructive => theme.destructiveButtonTheme,
    ZamButtonVariant.link => theme.linkButtonTheme,
  };
}

Future<TestGesture> _hover(WidgetTester tester) async {
  final mouse = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await mouse.addPointer(location: Offset.zero);
  await mouse.moveTo(tester.getCenter(find.byType(ZamButton)));
  await tester.pump();
  return mouse;
}

void main() {
  // The same button with a label or with only a child.
  const forms = {'labeled': _labeled, 'child-only': _childOnly};

  for (final MapEntry(key: form, value: build) in forms.entries) {
    group('$form ZamButton', () {
      testWidgets('draws the fill and label color overrides', (tester) async {
        await tester.pumpApp(
          build(
            onPressed: () {},
            style: const ZamButtonStyle(
              backgroundColor: _fill,
              foregroundColor: _label,
            ),
          ),
        );

        expect(_decoration(tester).color, _fill);
        expect(_labelStyle(tester).color, _label);
      });

      testWidgets('draws the pressed fill while pressed', (tester) async {
        await tester.pumpApp(
          build(
            onPressed: () {},
            style: const ZamButtonStyle(
              backgroundColor: _fill,
              foregroundColor: _label,
              pressedBackgroundColor: _pressedFill,
            ),
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
            style: ZamButtonStyle(
              foregroundColor: _label,
              radius: radius,
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );

        final decoration = _decoration(tester);
        expect(decoration.border!.radius, radius);
        final ring = decoration.secondaryFocusedBorder!;
        expect(
          ring.radius,
          radius.add(BorderRadius.circular(ring.offset ?? 0)),
        );

        final style = _labelStyle(tester);
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w600);
        expect(style.color, _label);
      });

      testWidgets('merges the text style onto the variant style', (
        tester,
      ) async {
        await tester.pumpApp(build(onPressed: () {}));
        final base = _labelStyle(tester);

        await tester.pumpApp(
          build(
            onPressed: () {},
            style: const ZamButtonStyle(
              textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        );

        final style = _labelStyle(tester);
        expect(style.fontFamily, 'Test Sans');
        expect(style.fontFamily, base.fontFamily);
        expect(style.height, base.height);
        expect(style.letterSpacing, base.letterSpacing);
        expect(style.fontSize, 16);
        expect(style.fontWeight, FontWeight.w600);
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
      'draw at full opacity as one disabled node',
      (tester) async {
        final handle = tester.ensureSemantics();
        var taps = 0;
        await tester.pumpApp(
          _labeled(
            onPressed: () => taps++,
            enabled: false,
            style: _disabledColors,
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

    testWidgets('fall back to the fade and disabled semantics without a label',
        (tester) async {
      final handle = tester.ensureSemantics();
      await tester.pumpApp(_childOnly(style: _disabledColors));

      // The debug hint is reported, not thrown, so the build below is the
      // same one a release build shows.
      expect(tester.takeException(), isFlutterError);
      expect(
        _opacities(tester).where((o) => o.opacity == .5),
        hasLength(1),
      );
      expect(_buttonNodes(tester), 1);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Save')),
        isSemantics(isButton: true, isEnabled: false, hasTapAction: false),
      );
      handle.dispose();
    });

    testWidgets('keep the default colors while loading', (tester) async {
      final handle = tester.ensureSemantics();
      var taps = 0;
      await tester.pumpApp(
        ZamButton(
          label: 'Save',
          onPressed: () => taps++,
          isLoading: true,
          style: _disabledColors,
        ),
      );

      expect(_opacities(tester).where((o) => o.opacity < 1), isEmpty);
      expect(_decoration(tester).color, _fill);
      expect(_labelStyle(tester).color, _label);

      await tester.tap(find.byType(ZamButton), warnIfMissed: false);
      await tester.pump();
      expect(taps, 0);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Save')),
        isSemantics(isButton: true, isEnabled: false, hasTapAction: false),
      );
      handle.dispose();
    });

    testWidgets('keep the ShadButton state when the button disables', (
      tester,
    ) async {
      await tester.pumpApp(
        _labeled(onPressed: () {}, style: _disabledColors),
      );
      final state = tester.state(find.byType(ShadButton));

      await tester.pumpApp(
        _labeled(onPressed: () {}, enabled: false, style: _disabledColors),
      );
      expect(_decoration(tester).color, _disabledFill);
      expect(tester.state(find.byType(ShadButton)), same(state));
    });
  });

  group('without overrides', () {
    for (final variant in ZamButtonVariant.values) {
      testWidgets('${variant.name} keeps the theme look', (tester) async {
        await tester.pumpApp(
          ZamButton(label: 'Save', onPressed: () {}, variant: variant),
        );
        final theme = _variantTheme(tester, variant);

        final decoration = _decoration(tester);
        expect(decoration.color, theme.backgroundColor);
        expect(decoration.border?.radius, theme.decoration?.border?.radius);
        expect(
          decoration.secondaryFocusedBorder,
          theme.decoration?.secondaryFocusedBorder,
        );
        expect(_labelStyle(tester).color, theme.foregroundColor);

        final mouse = await _hover(tester);
        expect(_decoration(tester).color, theme.hoverBackgroundColor);
        expect(_labelStyle(tester).color, theme.hoverForegroundColor);
        await mouse.removePointer();
      });
    }

    testWidgets('the primary label keeps the contrast-picked color', (
      tester,
    ) async {
      await tester.pumpApp(ZamButton(label: 'Save', onPressed: () {}));

      expect(
        _labelStyle(tester).color,
        ZamColorUtils.readableOn(testTheme.colors.primary),
      );
    });
  });

  group('a foreground override without a fill', () {
    // Figma Ghost: no fill and an accent label.
    const accent = Color(0xFF06B6D4);
    const stateLayer = Color(0x1A000000);

    for (final variant in [
      ZamButtonVariant.ghost,
      ZamButtonVariant.outline,
      ZamButtonVariant.link,
    ]) {
      testWidgets('${variant.name} keeps the idle fill on hover and press', (
        tester,
      ) async {
        await tester.pumpApp(
          ZamButton(
            label: 'Save',
            onPressed: () {},
            variant: variant,
            style: const ZamButtonStyle(foregroundColor: accent),
          ),
        );
        final idle = _decoration(tester).color;
        expect(idle?.a ?? 0, 0);

        final mouse = await _hover(tester);
        expect(_decoration(tester).color, idle);
        expect(_labelStyle(tester).color, accent);
        await mouse.removePointer();

        final press = await tester.startGesture(
          tester.getCenter(find.byType(ZamButton)),
        );
        await tester.pump();
        expect(_decoration(tester).color, idle);
        expect(_labelStyle(tester).color, accent);
        await press.up();
      });
    }

    testWidgets('ghost draws the given pressed fill', (tester) async {
      await tester.pumpApp(
        ZamButton(
          label: 'Save',
          onPressed: () {},
          variant: ZamButtonVariant.ghost,
          style: const ZamButtonStyle(
            foregroundColor: accent,
            pressedBackgroundColor: stateLayer,
          ),
        ),
      );

      final press = await tester.startGesture(
        tester.getCenter(find.byType(ZamButton)),
      );
      await tester.pump();
      expect(_decoration(tester).color, stateLayer);
      expect(_labelStyle(tester).color, accent);
      await press.up();
    });
  });

  group('ZamButtonStyle', () {
    test('compares by value', () {
      // copyWith builds a new instance, so this is not const identity.
      final style = const ZamButtonStyle(backgroundColor: _fill).copyWith(
        radius: BorderRadius.circular(24),
      );
      final same = ZamButtonStyle(
        backgroundColor: _fill,
        radius: BorderRadius.circular(24),
      );
      expect(identical(style, same), isFalse);
      expect(style, same);
      expect(style.hashCode, same.hashCode);
      expect(style, isNot(same.copyWith(backgroundColor: _label)));
    });

    test('copyWith replaces only the given fields', () {
      const style = ZamButtonStyle(
        backgroundColor: _fill,
        foregroundColor: _label,
      );
      expect(
        style.copyWith(foregroundColor: _disabledLabel),
        const ZamButtonStyle(
          backgroundColor: _fill,
          foregroundColor: _disabledLabel,
        ),
      );
      expect(style.copyWith(), style);
    });

    test('reports whether a disabled color is set', () {
      expect(const ZamButtonStyle().hasDisabledColors, isFalse);
      expect(
        const ZamButtonStyle(disabledForegroundColor: _disabledLabel)
            .hasDisabledColors,
        isTrue,
      );
      expect(
        const ZamButtonStyle(disabledBackgroundColor: _disabledFill)
            .hasDisabledColors,
        isTrue,
      );
    });
  });
}
