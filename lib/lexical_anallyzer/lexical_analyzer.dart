import 'package:flutter/material.dart';

import 'tokens/divider_tokens.dart';
import 'tokens/identiffier_token.dart';
import 'tokens/key_words_tokens.dart';
import 'tokens/operation_tokens.dart';
import 'tokens/token.dart';
import 'tokens/value_tokens.dart';

class LexicalAnalyzer {
  String sampleCode = """

		    double c = 3;
        int b;
        String f;
        int a = 1;
        int e3 = 2;
        int chh = 0;
        if (c > 2.79) {
            b = a * e3;
         
            chh += 1;
        }
        int count = 0;
        while(true) {
            count++;
            if (count == 12) {
                break;
            }
        }

""";

  String sampleCode2 = """
public class Main
{
	public static void main(String[] args) {
		    double c = 3;
        int b;
        String f;
        int a = 1;
        int e3 = 2;
        int chh = 0;
        if (c > 2.79) {
            b = a * e3;
            f = "as ;ds";
            chh += 1;
        }
        int count = 0;
        while(true) {
            count++;
            if (count == 12) {
                break;
            }
        }
	}
}
""";

  List<Token> outputTokens = [];

  List<IdentifierToken> identifiers = [];
  List<ValueToken> values = [];

  void addToken(Token? token) {
    if (token != null) {
      outputTokens.add(token);
    }
  }

  void addAllTokens(List<Token?> tokens) => tokens.forEach(addToken);

  List<Token> execute(String inputCode) {
    final buffer = StringBuffer();
    var isInString = false;

    for (final char in inputCode.characters) {
      var divider = DividerTokens.check(char);

      if (divider != null) {
        var str = buffer.toString();
        if (!handleKeyWords(str, divider)) {
          if (!handleOperations(str, divider)) {
            if (!handleValues(str, divider)) {
              if (!handleIdentifiers(str, divider)) {}
            }
          }
        }

        addToken(divider);

        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    return outputTokens;
  }

  bool handleKeyWords(String str, DividerTokens divider) {
    KeyWordTokens? token = KeyWordTokens.check(str);
    if (token != null) {
      addToken(token);
    }
    return token != null;
  }

  bool handleOperations(String str, DividerTokens divider) {
    OperationTokens? token = OperationTokens.check(str);
    if (token != null) {
      addToken(token);
    }
    return token != null;
  }

  bool handleIdentifiers(String str, DividerTokens divider) {
    IdentifierToken? token;
    if (str.isNotEmpty && int.tryParse(str[0]) == null) {
      token = IdentifierToken(identifiers.length, str);
    }

    if (token != null) {
      addToken(token);
      identifiers.add(token);
    }
    return token != null;
  }

  bool handleValues(String str, DividerTokens divider) {
    ValueToken? token;
    if (num.tryParse(str) != null) {
      if (int.tryParse(str) != null) {
        token = ValueToken(values.length, ValueTypeTokens.int, str);
      } else {
        token = ValueToken(values.length, ValueTypeTokens.double, str);
      }
    }
    if (token != null) {
      addToken(token);
      values.add(token);
    }
    return token != null;
  }
}
