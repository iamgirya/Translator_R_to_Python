import '../../core/extensions.dart';
import 'token.dart';

enum KeyWordTokens implements Token {
  class_("class"), // 0
  if_("if"), // 1
  else_("else"), // 2
  while_("while"), // 3
  integer_("int"), // 4
  float_("float"), // 5
  double_("double"), // 6
  string_("string"), // 7
  nameSpace_("namespace"), // 8
  void_("void"), // 9
  static_("static"), // 10
  using_("using"), // 11
  system_("System"), // 12
  break_("break"); // 13

  @override
  final String mark;
  const KeyWordTokens(this.mark);

  static KeyWordTokens? check(String str) =>
      KeyWordTokens.values.where((e) => e.mark == str).firstOrNull;

  @override
  String encode() => "${Tokens.keyWord.mark}_$index";
}
