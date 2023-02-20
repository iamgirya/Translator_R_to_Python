import 'package:java_to_csharp_translator/lexical_anallyzer/tokens/token.dart';

enum ValueTypeTokens implements Token {
  int("Ni"),
  float("Nf"),
  double("Nd"),
  string("S"),
  bool("B");

  @override
  final String mark;
  const ValueTypeTokens(this.mark);
}

class ValueToken {
  final int id;
  final ValueTypeTokens type;
  final dynamic value;

  ValueToken(this.id, this.type, this.value);

  String encode() => "${type.mark}_$id";
}
