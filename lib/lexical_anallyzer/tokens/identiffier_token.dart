import 'token.dart';

class IdentifierToken implements Token {
  final int id;

  final dynamic value;

  @override
  final String lexeme = "I";
  IdentifierToken(this.id, this.value);

  @override
  String encode() => "${lexeme}_$id";
}
