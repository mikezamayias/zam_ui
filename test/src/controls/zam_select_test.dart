import 'package:flutter/gestures.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shad/shad.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

const List<ZamSelectOption<String>> _options = [
  ZamSelectOption(value: 'a', label: 'Alpha'),
  ZamSelectOption(value: 'b', label: 'Beta'),
  ZamSelectOption(value: 'c', label: 'Gamma'),
];

/// A parent that owns the value, as an app would.
class _Host extends StatefulWidget {
  const _Host({
    this.initial,
    this.enabled = true,
    this.focusNode,
    this.changes,
  });

  final String? initial;
  final bool enabled;
  final FocusNode? focusNode;
  final List<String>? changes;

  @override
  State<_Host> createState() => _HostState();
}

class _HostState extends State<_Host> {
  late String? _value = widget.initial;

  @override
  Widget build(BuildContext context) => Align(
    alignment: Alignment.topCenter,
    child: SizedBox(
      width: 240,
      child: ZamSelect<String>(
        options: _options,
        value: _value,
        placeholder: 'Pick a letter',
        semanticLabel: 'Letter',
        focusNode: widget.focusNode,
        onChanged: widget.enabled
            ? (value) {
                widget.changes?.add(value);
                setState(() => _value = value);
              }
            : null,
      ),
    ),
  );
}

Future<void> _pumpHost(
  WidgetTester tester,
  _Host host, {
  ZamThemeMode mode = ZamThemeMode.light,
}) => tester.pumpWidget(
  ZamApp(theme: testTheme, darkTheme: testTheme, themeMode: mode, home: host),
);

Finder get _field => find.byType(ShadSelect<String>);

void main() {
  group('ZamSelect', () {
    testWidgets('shows the placeholder while nothing is chosen', (
      tester,
    ) async {
      await _pumpHost(tester, const _Host());

      expect(find.text('Pick a letter'), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('a value that matches no option shows the placeholder', (
      tester,
    ) async {
      await _pumpHost(tester, const _Host(initial: 'z'));

      expect(find.text('Pick a letter'), findsOneWidget);
    });

    testWidgets('shows the label of the chosen option', (tester) async {
      await _pumpHost(tester, const _Host(initial: 'b'));

      expect(find.text('Beta'), findsOneWidget);
      expect(find.text('Pick a letter'), findsNothing);
    });

    testWidgets('opens on a tap and picks an option', (tester) async {
      final changes = <String>[];
      await _pumpHost(tester, _Host(changes: changes));

      await tester.tap(_field);
      await tester.pumpAndSettle();
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Gamma'), findsOneWidget);

      await tester.tap(find.text('Gamma'));
      await tester.pumpAndSettle();

      expect(changes, ['c']);
      expect(find.text('Gamma'), findsOneWidget);
      expect(find.text('Alpha'), findsNothing);
    });

    testWidgets('opens on a mouse click and picks an option', (tester) async {
      final changes = <String>[];
      await _pumpHost(tester, _Host(changes: changes));

      await tester.tap(_field, kind: PointerDeviceKind.mouse);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta'), kind: PointerDeviceKind.mouse);
      await tester.pumpAndSettle();

      expect(changes, ['b']);
      expect(find.text('Beta'), findsOneWidget);
    });

    testWidgets('picking the chosen option does not call onChanged', (
      tester,
    ) async {
      final changes = <String>[];
      await _pumpHost(tester, _Host(initial: 'a', changes: changes));

      await tester.tap(_field);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Alpha').last);
      await tester.pumpAndSettle();

      expect(changes, isEmpty);
    });

    testWidgets('keeps showing the value its parent passes', (tester) async {
      String? picked;
      await tester.pumpApp(
        Center(
          child: SizedBox(
            width: 240,
            child: ZamSelect<String>(
              options: _options,
              value: 'a',
              onChanged: (value) => picked = value,
            ),
          ),
        ),
      );

      await tester.tap(_field);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      expect(picked, 'b');
      expect(find.text('Alpha'), findsOneWidget);
      expect(find.text('Beta'), findsNothing);
    });

    testWidgets('does not open without onChanged', (tester) async {
      await _pumpHost(tester, const _Host(enabled: false));

      await tester.tap(_field, warnIfMissed: false);
      await tester.pumpAndSettle();

      expect(find.text('Alpha'), findsNothing);
      expect(tester.widget<ShadSelect<String>>(_field).enabled, isFalse);
    });

    testWidgets('opens with Enter and picks with the arrow keys', (
      tester,
    ) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final changes = <String>[];
      await _pumpHost(
        tester,
        _Host(initial: 'a', focusNode: focusNode, changes: changes),
      );

      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(find.text('Beta'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();

      expect(changes, ['b']);
      expect(find.text('Alpha'), findsNothing);
      expect(focusNode.hasFocus, isTrue);
    });

    testWidgets('Escape closes the list without picking', (tester) async {
      final focusNode = FocusNode();
      addTearDown(focusNode.dispose);
      final changes = <String>[];
      await _pumpHost(
        tester,
        _Host(initial: 'a', focusNode: focusNode, changes: changes),
      );

      focusNode.requestFocus();
      await tester.pump();
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      await tester.pumpAndSettle();
      expect(find.text('Beta'), findsOneWidget);

      await tester.sendKeyEvent(LogicalKeyboardKey.escape);
      await tester.pumpAndSettle();

      expect(find.text('Beta'), findsNothing);
      expect(changes, isEmpty);
    });

    testWidgets('the field and each option meet the minimum tap target', (
      tester,
    ) async {
      await _pumpHost(tester, const _Host(initial: 'a'));
      final minTap = testTheme.sizes.minTapTarget;

      expect(tester.getSize(_field).height, greaterThanOrEqualTo(minTap));

      await tester.tap(_field);
      await tester.pumpAndSettle();
      for (final option in find.byType(ShadOption<String>).evaluate()) {
        final size = tester.getSize(find.byWidget(option.widget));
        expect(size.height, greaterThanOrEqualTo(minTap));
      }

      // The chosen label sits in the vertical centre of the field.
      final field = tester.getRect(_field);
      final label = tester.getRect(find.text('Alpha').first);
      expect(label.center.dy, moreOrLessEquals(field.center.dy, epsilon: 1));
    });

    testWidgets('shows a leading widget beside the label', (tester) async {
      await tester.pumpApp(
        Center(
          child: SizedBox(
            width: 240,
            child: ZamSelect<int>(
              options: const [
                ZamSelectOption(
                  value: 1,
                  label: 'One',
                  leading: SizedBox.square(
                    key: ValueKey('lead'),
                    dimension: 16,
                  ),
                ),
              ],
              value: 1,
              onChanged: (_) {},
            ),
          ),
        ),
      );

      expect(find.byKey(const ValueKey('lead')), findsOneWidget);
      expect(find.text('One'), findsOneWidget);
    });

    testWidgets('reads as a button with its name, value and expanded state', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      final changes = <String>[];
      await _pumpHost(tester, _Host(initial: 'a', changes: changes));

      expect(
        tester.getSemantics(find.bySemanticsLabel('Letter')),
        isSemantics(
          label: 'Letter',
          value: 'Alpha',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasExpandedState: true,
          isExpanded: false,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );

      tester.semantics.tap(find.semantics.byLabel('Letter'));
      await tester.pumpAndSettle();
      expect(
        tester.getSemantics(find.bySemanticsLabel('Letter')),
        isSemantics(
          label: 'Letter',
          value: 'Alpha',
          isButton: true,
          hasEnabledState: true,
          isEnabled: true,
          isFocusable: true,
          hasExpandedState: true,
          isExpanded: true,
          hasTapAction: true,
          hasFocusAction: true,
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Alpha')),
        isSemantics(
          label: 'Alpha',
          isButton: true,
          hasSelectedState: true,
          isSelected: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
        ),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Beta')),
        isSemantics(
          label: 'Beta',
          isButton: true,
          hasSelectedState: true,
          isInMutuallyExclusiveGroup: true,
          hasTapAction: true,
        ),
      );

      tester.semantics.tap(find.semantics.byLabel('Beta'));
      await tester.pumpAndSettle();
      expect(changes, ['b']);
      expect(find.bySemanticsLabel('Gamma'), findsNothing);
      handle.dispose();
    });

    testWidgets('reads the placeholder as its value while empty', (
      tester,
    ) async {
      final handle = tester.ensureSemantics();
      await _pumpHost(tester, const _Host());

      expect(
        tester.getSemantics(find.bySemanticsLabel('Letter')),
        isSemantics(label: 'Letter', value: 'Pick a letter'),
      );
      handle.dispose();
    });

    testWidgets('can be disabled and enabled again', (tester) async {
      final changes = <String>[];
      Widget select({required bool enabled}) => Center(
        child: SizedBox(
          width: 240,
          child: ZamSelect<String>(
            options: _options,
            value: 'a',
            onChanged: enabled ? changes.add : null,
          ),
        ),
      );
      await tester.pumpApp(select(enabled: false));
      await tester.pumpApp(select(enabled: true));

      await tester.tap(_field);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Beta'));
      await tester.pumpAndSettle();

      expect(changes, ['b']);
    });

    testWidgets('a disabled select has no tap action', (tester) async {
      final handle = tester.ensureSemantics();
      await _pumpHost(tester, const _Host(initial: 'a', enabled: false));

      expect(
        tester.getSemantics(find.bySemanticsLabel('Letter')),
        isSemantics(
          label: 'Letter',
          value: 'Alpha',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
          hasTapAction: false,
        ),
      );
      handle.dispose();
    });

    for (final mode in [ZamThemeMode.light, ZamThemeMode.dark]) {
      testWidgets('draws the theme border and focus ring in ${mode.name}', (
        tester,
      ) async {
        final focusNode = FocusNode();
        addTearDown(focusNode.dispose);
        await _pumpHost(
          tester,
          _Host(initial: 'a', focusNode: focusNode),
          mode: mode,
        );
        final brightness = mode == ZamThemeMode.dark
            ? Brightness.dark
            : Brightness.light;
        final palette = testTheme.palette(brightness);
        final decoration = tester
            .widget<ShadSelect<String>>(_field)
            .decoration!;

        expect(decoration.border!.top!.color, palette.input);
        expect(decoration.border!.top!.width, testTheme.strokes.hairline);
        expect(decoration.border!.radius, testTheme.radius.md);
        expect(decoration.secondaryFocusedBorder!.top!.color, palette.ring);
        expect(
          decoration.secondaryFocusedBorder!.top!.width,
          testTheme.strokes.focusRing,
        );

        focusNode.requestFocus();
        await tester.pump();
        await tester.tap(_field);
        await tester.pumpAndSettle();
        expect(find.text('Gamma'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });
}
