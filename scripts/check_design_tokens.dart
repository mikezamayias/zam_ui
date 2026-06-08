import 'dart:io';

const _defaultRoots = ['lib', 'example/lib'];

const _generatedSuffixes = [
  '.g.dart',
  '.freezed.dart',
  '.mocks.dart',
  '.config.dart',
];

const _allowedPathFragments = [
  '/src/tokens.dart',
  '/src/utils.dart',
  '/presets.dart',
];

final _rules = <_TokenRule>[
  _TokenRule(
    'Use ZamTheme.insets instead of raw EdgeInsets values',
    RegExp(
      r'\b(?:const\s+)?EdgeInsets\.(all|only|symmetric|fromLTRB)\(\s*-?\d',
    ),
  ),
  _TokenRule(
    'Use ZamTheme.insets.zero instead of EdgeInsets.zero',
    RegExp(r'\bEdgeInsets\.zero\b'),
  ),
  _TokenRule(
    'Use ZamTheme spacing/sizes instead of raw SizedBox dimensions',
    RegExp(r'\b(?:const\s+)?SizedBox\(\s*(width|height):\s*-?\d'),
  ),
  _TokenRule(
    'Use ZamTheme.radius instead of raw BorderRadius values',
    RegExp(r'\bBorderRadius\.circular\(\s*-?\d'),
  ),
  _TokenRule(
    'Use ZamTheme.motion/ZamDurationToken instead of raw animation durations',
    RegExp(r'\b(?:const\s+)?Duration\((milliseconds|seconds):\s*-?\d'),
  ),
  _TokenRule(
    'Use ZamColorTokens or app presets instead of hard-coded Color values',
    RegExp(r'\bColor\(0x[0-9A-Fa-f]+'),
  ),
  _TokenRule(
    'Use configured theme colors instead of raw Colors.*',
    RegExp(r'\bColors\.'),
  ),
  _TokenRule(
    'Use ZamTypographyTokens instead of raw fontSize',
    RegExp(r'\bfontSize:\s*-?\d'),
  ),
  _TokenRule(
    'Use ZamStrokeTokens instead of raw strokeWidth',
    RegExp(r'\bstrokeWidth:\s*-?\d'),
  ),
  _TokenRule(
    'Use ZamOpacityTokens instead of raw alpha values',
    RegExp(r'\bwithValues\(alpha:\s*-?\d'),
  ),
];

void main(List<String> args) {
  if (args.contains('--self-test')) {
    _runSelfTest();
    return;
  }

  final roots = args.isEmpty ? _defaultRoots : args;
  final findings = <_Finding>[];

  for (final root in roots) {
    final directory = Directory(root);
    final file = File(root);
    if (directory.existsSync()) {
      for (final entity in directory.listSync(recursive: true)) {
        if (entity is! File || !entity.path.endsWith('.dart')) continue;
        final path = _normalize(entity.path);
        if (!_shouldScan(path)) continue;
        findings.addAll(_scanText(path, entity.readAsStringSync()));
      }
    } else if (file.existsSync() && root.endsWith('.dart')) {
      final path = _normalize(file.path);
      if (_shouldScan(path)) {
        findings.addAll(_scanText(path, file.readAsStringSync()));
      }
    }
  }

  if (findings.isEmpty) {
    stdout.writeln('Design token scan passed.');
    return;
  }

  stderr.writeln('Design token scan failed: ${findings.length} issue(s).');
  for (final finding in findings) {
    stderr.writeln(
      '${finding.path}:${finding.line}: ${finding.rule}\n'
      '  ${finding.source.trim()}',
    );
  }
  exitCode = 1;
}

bool _shouldScan(String path) {
  if (_generatedSuffixes.any(path.endsWith)) return false;
  if (_allowedPathFragments.any(path.contains)) return false;
  return path.startsWith('lib/') || path.startsWith('example/lib/');
}

List<_Finding> _scanText(String path, String text) {
  final findings = <_Finding>[];
  final lines = text.split('\n');
  for (var index = 0; index < lines.length; index++) {
    final line = lines[index];
    for (final rule in _rules) {
      if (rule.pattern.hasMatch(line)) {
        findings.add(
          _Finding(
            path: path,
            line: index + 1,
            rule: rule.message,
            source: line,
          ),
        );
      }
    }
  }
  return findings;
}

void _runSelfTest() {
  const badSample = '''
Widget build(BuildContext context) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Color(0xFFFFFFFF),
      borderRadius: BorderRadius.circular(18),
    ),
    child: const SizedBox(height: 12),
  );
}
''';

  const goodSample = '''
Widget build(BuildContext context) {
  final theme = context.zam;
  return Container(
    padding: theme.insets.card,
    decoration: BoxDecoration(
      color: ShadTheme.of(context).colorScheme.card,
      borderRadius: theme.radius.lg,
    ),
    child: SizedBox(height: theme.spacing.twelve),
  );
}
''';

  final badFindings = _scanText('self_test_bad.dart', badSample);
  final goodFindings = _scanText('self_test_good.dart', goodSample);

  if (badFindings.isEmpty) {
    stderr.writeln('Design token self-test failed: bad sample passed.');
    exitCode = 1;
    return;
  }
  if (goodFindings.isNotEmpty) {
    stderr.writeln('Design token self-test failed: good sample failed.');
    for (final finding in goodFindings) {
      stderr.writeln('${finding.line}: ${finding.rule}');
    }
    exitCode = 1;
    return;
  }

  stdout.writeln('Design token self-test passed.');
}

String _normalize(String path) => path.replaceAll(r'\', '/');

class _TokenRule {
  const _TokenRule(this.message, this.pattern);

  final String message;
  final RegExp pattern;
}

class _Finding {
  const _Finding({
    required this.path,
    required this.line,
    required this.rule,
    required this.source,
  });

  final String path;
  final int line;
  final String rule;
  final String source;
}
