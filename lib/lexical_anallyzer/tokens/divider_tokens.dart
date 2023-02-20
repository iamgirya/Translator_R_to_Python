import 'package:java_to_csharp_translator/lexical_anallyzer/token.dart';

enum DividerTokens implements Token {
  whitespace(" "), // 0
  startBracket("{"), // 1
  endBracket("}"), // 2
  startRoundBracket("("), // 3
  endRoundBracket(")"), // 4
  endl("\n"), // 5
  comma(","), // 6
  semicolon(";"), // 7
  quotes("\""); // 8

  @override
  final String mark;
  const DividerTokens(this.mark);
}
