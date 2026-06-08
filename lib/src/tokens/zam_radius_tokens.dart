part of '../tokens.dart';

class ZamRadiusTokens {
  const ZamRadiusTokens({
    this.two = 2,
    this.four = 4,
    this.six = 6,
    this.eight = 8,
    this.ten = 10,
    this.twelve = 12,
    this.fourteen = 14,
    this.sixteen = 16,
    this.twenty = 20,
    this.twentyFour = 24,
    this.full = 128,
  });

  final double two;
  final double four;
  final double six;
  final double eight;
  final double ten;
  final double twelve;
  final double fourteen;
  final double sixteen;
  final double twenty;
  final double twentyFour;
  final double full;

  BorderRadius circular(double value) => BorderRadius.circular(value);
  BorderRadius get zero => BorderRadius.zero;
  BorderRadius get sm => BorderRadius.circular(six);
  BorderRadius get md => BorderRadius.circular(eight);
  BorderRadius get lg => BorderRadius.circular(twelve);
  BorderRadius get xl => BorderRadius.circular(sixteen);
  BorderRadius get dialog => BorderRadius.circular(twenty);
  BorderRadius get toast => BorderRadius.circular(twelve);
  BorderRadius get pill => BorderRadius.circular(full);
}
