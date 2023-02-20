abstract class Token {
  final String mark;
  Token(this.mark);
}

enum Tokens implements Token {
  keyWord("W"),
  identifier("I"),
  operation("O"),
  divider("D"),
  numberConstant("N"),
  stringConstant("S");

  @override
  final String mark;
  const Tokens(this.mark);
}
