part of '../tokens.dart';

/// Shadow tokens providing elevation box shadows for cards and navigation bars.
class ZamShadowTokens {
  /// Creates a [ZamShadowTokens] set.
  const ZamShadowTokens();

  /// Returns card elevation shadows tuned for specified [brightness].
  List<BoxShadow> card(Brightness brightness) => brightness == Brightness.dark
      ? const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 22,
            spreadRadius: -8,
            color: Color.fromRGBO(0, 0, 0, 0.36),
          ),
        ]
      : const [
          BoxShadow(
            offset: Offset(0, 8),
            blurRadius: 22,
            spreadRadius: -10,
            color: Color.fromRGBO(30, 26, 20, 0.08),
          ),
        ];

  /// Returns navigation bar shadows tuned for specified [brightness].
  List<BoxShadow> nav(Brightness brightness) => brightness == Brightness.dark
      ? const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 30,
            spreadRadius: -10,
            color: Color.fromRGBO(0, 0, 0, 0.4),
          ),
        ]
      : const [
          BoxShadow(
            offset: Offset(0, 10),
            blurRadius: 30,
            spreadRadius: -12,
            color: Color.fromRGBO(30, 26, 20, 0.14),
          ),
        ];
}
