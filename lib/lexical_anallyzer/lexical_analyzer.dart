import 'package:flutter/material.dart';

import '../core/logger.dart';
import 'tokens/divider_tokens.dart';
import 'tokens/identiffier_token.dart';
import 'tokens/key_words_tokens.dart';
import 'tokens/operation_tokens.dart';
import 'tokens/token.dart';
import 'tokens/value_tokens.dart';

enum SemanticProcedures {
  p1,
  p2,
  p3,
  p4,
  p5,
  p6,
}

class LexicalAnalyzer {
  List<Token> outputTokens = [];
  List<IdentifierToken> identifiers = [];
  List<ValueToken> valuesNums = [];
  List<ValueToken> valuesBool = [];
  List<ValueToken> valuesString = [];

  void addToken(Token? token) {
    if (token != null) {
      outputTokens.add(token);
    }
  }

  void addAllTokens(List<Token?> tokens) => tokens.forEach(addToken);

  List<Token> execute(String inputCode) {
    logger.log(Log.info, title: "Start Lexical Analyze", message: inputCode);

    final buffer = StringBuffer();

    for (int i = 0; i < inputCode.characters.length; i++) {
      var char = inputCode.characters.elementAt(i);

      var divider = DividerTokens.check(char);

      if (divider != null) {
      } else {
        buffer.write(char);
      }
    }

    return outputTokens;
  }

  void handleKeyWordsAndOperations(String str) {
    Token? token = KeyWordTokens.check(str);
    token ??= OperationTokens.check(str);

    if (token != null) {
      addToken(token);
    } else {
      handleIdentifiers(str);
    }
  }

  bool handleOperations(String str, DividerTokens divider) {
    OperationTokens? token = OperationTokens.check(str);
    if (token != null) {
      addToken(token);
    }
    return token != null;
  }

  void handleIdentifiers(String str) {
    IdentifierToken? token;
    for (final identifier in identifiers) {
      if (identifier.value == str) token = identifier;
    }

    token ??= IdentifierToken(identifiers.length, str);
    identifiers.add(token);
    addToken(token);
  }

  void handleNumbers(String str) {
    ValueToken? token;

    if (num.tryParse(str) != null) {
      if (int.tryParse(str) != null) {
        token = ValueToken(valuesNums.length, ValueTypeTokens.int, str);
      } else {
        token = ValueToken(valuesNums.length, ValueTypeTokens.double, str);
      }
      valuesNums.add(token);
      addToken(token);
    } else {
      throw Exception("handleNumbers error");
    }
  }

  void handleString(String str, DividerTokens divider) {
    final token = ValueToken(valuesString.length, ValueTypeTokens.string, str);
    valuesString.add(token);
    addToken(token);
  }
}
