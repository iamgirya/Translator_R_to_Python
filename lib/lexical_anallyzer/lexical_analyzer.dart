import 'package:flutter/material.dart';

import 'tokens/divider_tokens.dart';
import 'tokens/identiffier_token.dart';
import 'tokens/token.dart';
import 'tokens/value_tokens.dart';

class LexicalAnalyzer {
  String sampleCode = """
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

  List<Token> execute(String inputCode) {
    final buffer = StringBuffer();
    var isInString = false;

    for (final char in inputCode.characters) {
      var divider = DividerTokens.check(char);

      if (divider != null) {
        if (divider != DividerTokens.whitespace &&
            divider != DividerTokens.newline) {
          outputTokens.add(divider);
        }

        buffer.clear();
      } else {
        buffer.write(char);
      }
    }

    return outputTokens;
  }
}
