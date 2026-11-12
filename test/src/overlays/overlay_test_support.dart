import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:zam_ui/zam_ui.dart';

import '../../helpers/helpers.dart';

/// Pumps a page with a labeled opener and hands out its [BuildContext].
class OverlayHost {
  OverlayHost(this.tester);

  final WidgetTester tester;
  late BuildContext context;

  Future<void> pump({
    TextDirection? direction,
    Widget Function(Widget child)? wrap,
  }) async {
    Widget page = Builder(
      builder: (ctx) {
        context = ctx;
        return const Center(child: Text('page'));
      },
    );
    if (direction != null) {
      page = Directionality(textDirection: direction, child: page);
    }
    await tester.pumpApp(wrap?.call(page) ?? page);
  }
}

/// The ZamApp host with the given text direction wrapped around the whole app.
Future<void> pumpRtlApp(WidgetTester tester, Widget home) {
  return tester.pumpWidget(
    ZamApp(
      theme: testTheme,
      themeMode: ZamThemeMode.light,
      builder: (context, child) =>
          Directionality(textDirection: TextDirection.rtl, child: child!),
      home: home,
    ),
  );
}

/// Whether a semantics scope that names a route sits above [finder].
bool inRouteScope(WidgetTester tester, Finder finder) {
  var node = tester.getSemantics(finder).parent;
  while (node != null) {
    if (node.flagsCollection.scopesRoute) return true;
    node = node.parent;
  }
  return false;
}

/// The semantics nodes that are buttons labeled [label].
SemanticsFinder buttonsLabeled(String label) => find.semantics.byPredicate(
  (node) => node.label == label && node.flagsCollection.isButton,
);
