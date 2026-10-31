part of '../check_design_tokens.dart';

class _TokenRule {
  const _TokenRule(this.message, this.pattern);

  final String message;
  final RegExp pattern;
}
