import 'package:java_to_csharp_translator/lexical_anallyzer/token.dart';

enum OperationTokens implements Token {
  plus("+"), // 0
  minus("-"), // 1
  multiplier("*"), // 2
  divider("/"), // 3
  remainder("%"), // 4
  equalTo("="), // 5
  exclamationMark("!"), // 6,

  doublePlus("++"), // 7
  doubleMinus("--"), // 8
  plusEqualTo("+="), // 9
  minusEqualTo("-="), // 10
  divideEqualTo("/="), // 11
  multiplyEqualTo("*="), // 12
  remaindEqualTo("%="), // 13,

  less("<"), // 14
  lessOrEqual("<="), // 15
  more(">"), // 16
  moreOrEqual(">="), // 17
  isEqual("=="), // 18
  notEqual("!="); // 19

  @override
  final String mark;
  const OperationTokens(this.mark);
}
