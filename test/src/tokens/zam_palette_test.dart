import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

ZamPalette _copy(ZamPalette p, {Color? ring}) => ZamPalette(
  brightness: p.brightness,
  background: p.background,
  foreground: p.foreground,
  card: p.card,
  cardForeground: p.cardForeground,
  popover: p.popover,
  popoverForeground: p.popoverForeground,
  primary: p.primary,
  primaryForeground: p.primaryForeground,
  secondary: p.secondary,
  secondaryForeground: p.secondaryForeground,
  muted: p.muted,
  mutedForeground: p.mutedForeground,
  accent: p.accent,
  accentForeground: p.accentForeground,
  destructive: p.destructive,
  destructiveForeground: p.destructiveForeground,
  border: p.border,
  input: p.input,
  ring: ring ?? p.ring,
  selection: p.selection,
  primaryText: p.primaryText,
  primaryControl: p.primaryControl,
  mutedControl: p.mutedControl,
  placeholderText: p.placeholderText,
  destructiveText: p.destructiveText,
  status: p.status,
);

/// A surface built from [base] with only the optional role [role] set.
ZamSurfaceColors _withRole(ZamSurfaceColors base, String role) {
  const c = Color(0xFF123456);
  return ZamSurfaceColors(
    background: base.background,
    foreground: base.foreground,
    card: base.card,
    muted: base.muted,
    mutedForeground: base.mutedForeground,
    border: base.border,
    input: base.input,
    destructive: base.destructive,
    cardForeground: role == 'cardForeground' ? c : null,
    popover: role == 'popover' ? c : null,
    popoverForeground: role == 'popoverForeground' ? c : null,
    secondary: role == 'secondary' ? c : null,
    secondaryForeground: role == 'secondaryForeground' ? c : null,
    accent: role == 'accent' ? c : null,
    accentForeground: role == 'accentForeground' ? c : null,
    ring: role == 'ring' ? c : null,
    selection: role == 'selection' ? c : null,
    primaryText: role == 'primaryText' ? c : null,
    primaryControl: role == 'primaryControl' ? c : null,
    mutedControl: role == 'mutedControl' ? c : null,
    placeholderText: role == 'placeholderText' ? c : null,
    destructiveText: role == 'destructiveText' ? c : null,
  );
}

void main() {
  group('ZamPalette', () {
    test('compares by value', () {
      final palette = testTheme.palette(Brightness.light);
      final copy = _copy(palette);

      expect(copy, palette);
      expect(copy.hashCode, palette.hashCode);
      expect(
        _copy(palette, ring: const Color(0xFF000001)),
        isNot(palette),
      );
      expect(palette, isNot(testTheme.palette(Brightness.dark)));
    });
  });

  group('ZamSurfaceColors optional roles', () {
    const roles = [
      'cardForeground',
      'popover',
      'popoverForeground',
      'secondary',
      'secondaryForeground',
      'accent',
      'accentForeground',
      'ring',
      'selection',
      'primaryText',
      'primaryControl',
      'mutedControl',
      'placeholderText',
      'destructiveText',
    ];
    final base = testTheme.colors.light;

    test('default to null', () {
      expect(base.cardForeground, isNull);
      expect(base.popover, isNull);
      expect(base.popoverForeground, isNull);
      expect(base.secondary, isNull);
      expect(base.secondaryForeground, isNull);
      expect(base.accent, isNull);
      expect(base.accentForeground, isNull);
      expect(base.ring, isNull);
      expect(base.selection, isNull);
      expect(base.primaryText, isNull);
      expect(base.primaryControl, isNull);
      expect(base.mutedControl, isNull);
      expect(base.placeholderText, isNull);
      expect(base.destructiveText, isNull);
    });

    for (final role in roles) {
      test('$role takes part in equality', () {
        final plain = _withRole(base, '');
        final one = _withRole(base, role);

        expect(_withRole(base, role), one);
        expect(_withRole(base, role).hashCode, one.hashCode);
        expect(one, isNot(plain));
        expect(plain, base);
      });
    }
  });
}
