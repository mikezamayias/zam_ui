import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/pump_app.dart';

/// A fake system clipboard for the platform channel.
class FakeClipboard {
  /// The last text copied, or null.
  String? text;

  /// Installs this clipboard for the current test.
  void install(WidgetTester tester) {
    final messenger = tester.binding.defaultBinaryMessenger;
    messenger.setMockMethodCallHandler(SystemChannels.platform, _handle);
    addTearDown(
      () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
    );
  }

  Future<Object?> _handle(MethodCall call) async {
    switch (call.method) {
      case 'Clipboard.setData':
        text = (call.arguments as Map<Object?, Object?>)['text'] as String?;
        return null;
      case 'Clipboard.getData':
        return text == null ? null : <String, Object?>{'text': text};
      case 'Clipboard.hasStrings':
        return <String, Object?>{'value': text?.isNotEmpty ?? false};
    }
    return null;
  }
}

/// Pumps [child] at the top start of a 400 by 800 screen, [width] wide and
/// inset by [padding], under a status bar of [viewPadding] and a keyboard of
/// [viewInsets].
Future<void> pumpField(
  WidgetTester tester,
  Widget child, {
  double width = 300,
  TextDirection textDirection = TextDirection.ltr,
  TextScaler textScaler = TextScaler.noScaling,
  bool systemContextMenu = false,
  ZamThemeData? theme,
  EdgeInsetsGeometry padding = const EdgeInsets.all(40),
  EdgeInsets viewPadding = EdgeInsets.zero,
  EdgeInsets viewInsets = EdgeInsets.zero,
}) async {
  tester.view.physicalSize = const Size(400, 800);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);
  // The app reads the platform's media query from this one, so the system
  // menu flag reaches the overlay that builds the menu.
  final media = MediaQueryData.fromView(tester.view).copyWith(
    textScaler: textScaler,
    supportsShowingSystemContextMenu: systemContextMenu,
    padding: viewPadding,
    viewPadding: viewPadding,
    viewInsets: viewInsets,
  );
  await tester.pumpWidget(
    MediaQuery(
      data: media,
      child: ZamApp(
        theme: theme ?? testTheme,
        themeMode: ZamThemeMode.light,
        home: Directionality(
          textDirection: textDirection,
          child: Align(
            alignment: AlignmentDirectional.topStart,
            child: Padding(
              padding: padding,
              child: SizedBox(width: width, child: child),
            ),
          ),
        ),
      ),
    ),
  );
}

/// Whether a handle painted by [painterName] is on screen.
Finder findHandlePainter(String painterName) => find.byWidgetPredicate(
  (widget) =>
      widget is CustomPaint &&
      widget.painter.runtimeType.toString() == painterName,
);

/// The global position of the caret slot before [offset] in the only
/// [EditableText], a little above the baseline.
Offset textOffsetToPosition(WidgetTester tester, int offset) {
  final editable = tester
      .state<EditableTextState>(find.byType(EditableText))
      .renderEditable;
  final endpoints = editable.getEndpointsForSelection(
    TextSelection.collapsed(offset: offset),
  );
  return editable.localToGlobal(endpoints.first.point + const Offset(0, -2));
}
