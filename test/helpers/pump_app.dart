import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:zam_ui/zam_ui.dart';

const _testIcons = ZamIconSet(
  info: IconData(0xe88e, fontFamily: 'TestIcons'),
  success: IconData(0xe876, fontFamily: 'TestIcons'),
  warning: IconData(0xe002, fontFamily: 'TestIcons'),
  error: IconData(0xe000, fontFamily: 'TestIcons'),
  back: IconData(0xe5c4, fontFamily: 'TestIcons'),
  chevronRight: IconData(0xe5cc, fontFamily: 'TestIcons'),
);

final testTheme = ZamThemeData(
  colors: ZamColorTokens.fromSeed(primary: const Color(0xFF06B6D4)),
  typography: const ZamTypographyTokens(fontFamily: 'Test Sans'),
  icons: _testIcons,
);

extension PumpApp on WidgetTester {
  Future<void> pumpApp(Widget widget, {ZamThemeData? theme}) async {
    final effectiveTheme = theme ?? testTheme;
    return pumpWidget(
      ZamTheme(
        data: effectiveTheme,
        child: ShadApp(
          theme: effectiveTheme.toShadThemeData(Brightness.light),
          home: widget,
        ),
      ),
    );
  }
}
