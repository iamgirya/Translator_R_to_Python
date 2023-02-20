import 'package:java_to_csharp_translator/lexical_anallyzer/token.dart';

class IdentifierToken {
  final int id;

  final dynamic value;

  IdentifierToken(this.id, this.value);

  String encode() => "${Tokens.identifier.mark}_$id";
}
