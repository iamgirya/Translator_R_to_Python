import '../../core/extensions.dart';
import 'token.dart';

enum KeyWordTokens implements Token {
  classStatement("class"), // 0
  ifStatement("if"), // 1
  elseStatement("else"), // 2
  whileStatement("while"), // 3
  integerStatement("int"), // 4
  floatStatement("float"), // 5
  doubleStatement("double"), // 6
  stringStatement("string"), // 7
  nameSpaceStatement("namespace"), // 8
  voidStatement("void"), // 9
  staticStatement("static"), // 10
  usingStatement("using"), // 11
  systemStatement("System"), // 12
  breakStatement("break"); // 13

  @override
  final String mark;
  const KeyWordTokens(this.mark);

  static KeyWordTokens? check(String str) =>
      KeyWordTokens.values.where((e) => e.mark == str).firstOrNull;

  @override
  String encode() => "${Tokens.keyWord.mark}_$index";
}
