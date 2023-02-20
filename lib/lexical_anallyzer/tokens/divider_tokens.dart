import '../../core/extensions.dart';
import 'token.dart';

enum DividerTokens implements Token {
  whitespace(" "), // 0
  startBracket("{"), // 1
  endBracket("}"), // 2
  startRoundBracket("("), // 3
  endRoundBracket(")"), // 4
  newline("\n"), // 5
  comma(","), // 6
  semicolon(";"), // 7
  quotes("\""); // 8

  @override
  final String mark;
  const DividerTokens(this.mark);

  static DividerTokens? check(String str) =>
      DividerTokens.values.where((e) => e.mark == str).firstOrNull;

  @override
  String encode() => "${Tokens.divider.mark}_$index";
}
