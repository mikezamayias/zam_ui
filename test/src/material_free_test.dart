import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

// Material and Cupertino libraries that package:zam_ui/zam_ui.dart and
// everything it exports must not import. Only lib/material.dart may.
final _forbidden = RegExp(
  r'''^\s*(import|export)\s+['"]package:(flutter/(material|cupertino)\.dart|material_ui/|cupertino_ui/|shad/material\.dart)''',
  multiLine: true,
);

void main() {
  test('the core library imports no Material or Cupertino library', () {
    final offenders = <String>[
      for (final file in Directory('lib').listSync(recursive: true))
        if (file is File &&
            file.path.endsWith('.dart') &&
            file.path != 'lib/material.dart' &&
            _forbidden.hasMatch(file.readAsStringSync()))
          file.path,
    ];

    expect(offenders, isEmpty);
  });

  test('the check catches a forbidden import', () {
    expect(
      _forbidden.hasMatch("import 'package:flutter/material.dart';"),
      true,
    );
    expect(_forbidden.hasMatch("export 'package:shad/material.dart';"), true);
    expect(
      _forbidden.hasMatch("import 'package:flutter/widgets.dart';"),
      false,
    );
  });
}
