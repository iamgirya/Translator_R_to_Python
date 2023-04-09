// ignore_for_file: constant_identifier_names

import '../../core/extensions.dart';
import 'token.dart';

enum KeyWordTokens implements Token {
  asm_("asm"),
  continue_("continue"),
  new_("new"),
  signed_("signed"),
  try_("try"),
  auto_("auto"),
  default_("default"),
  for_("for"),
  operator_("operator"),
  sizeof_("sizeof"),
  typedef_("typedef"),
  break_("break"),
  delete_("delete"),
  friend_("friend"),
  private_("private"),
  static_("static"),
  union_("union"),
  do_("do"),
  goto_("goto"),
  protected_("protected"),
  long__("long"),
  protected__("protected"),
  struct_("struct"),
  length_("length"),
  print_("print"),
  unsigned_("unsigned"),
  catch_("catch"),
  double_("double"),
  if_("if"),
  public_("public"),
  switch_("switch"),
  virtual_("virtual"),
  char_("char"),
  else_("else"),
  inline_("inline"),
  register_("register"),
  template_("template"),
  void_("void"),
  class_("class"),
  enum_("enum"),
  int_("int"),
  return_("return"),
  this_("this"),
  volatile_("volatile"),
  const_("const"),
  long_("long"),
  short_("short"),
  throw_("throw"),
  while_("while");

  @override
  final String lexeme;
  const KeyWordTokens(this.lexeme);

  static KeyWordTokens? check(String str) =>
      KeyWordTokens.values.where((e) => e.lexeme == str).firstOrNull;

  @override
  String encode() => "${Tokens.keyWord.lexeme}_$index";
}
