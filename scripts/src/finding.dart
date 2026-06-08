part of '../check_design_tokens.dart';

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
