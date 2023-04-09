import '../lexical_anallyzer/models/lexical_analyzer_output.dart';

final class ReversePolishEntryOutput {
  final List<String> rezult;

  // create consctructor
  ReversePolishEntryOutput({
    required this.rezult,
  });

  String convertToText() {
    return rezult.fold(
      '',
      (previousValue, element) => '$previousValue $element',
    );
  }
}

class ReversePolishEntry {
  int _getPriority(String token) {
    if (['(', 'for', 'if', 'while', '[', 'АЭМ', 'Ф', '{'].contains(token)) {
      return 0;
    }
    if ([')', ',', ';', 'do', 'else', ']'].contains(token)) {
      return 1;
    }
    if (token == '=') {
      return 2;
    }
    if (token == '||') {
      return 3;
    }
    if (token == '&&') {
      return 4;
    }
    if (token == '!') {
      return 5;
    }
    if (['<', '<=', '!=', '=', '>', '>='].contains(token)) {
      return 6;
    }
    if (['+', '-', '+=', '-=', '*=', '/='].contains(token)) {
      return 7;
    }
    if (['*', '/', '%'].contains(token)) {
      return 8;
    }
    if ([
      '}',
      'public.static.void',
      'procedure',
      'int',
      'double',
      'boolean',
      'String',
      'float',
      'args',
      'return',
      'System.out.println',
      'main'
    ].contains(token)) {
      return 9;
    }
    return -1;
  }

  ReversePolishEntryOutput execute(LexicalAnalyzerOutput input) {
    List<String> identifiers = input.identifiers.map((e) => e.lexeme).toList();
    List<String> t = input.tokens.map((e) => e.lexeme).toList();

    List<String> stack = [], rezult = [];
    int aemCount = 1, procLevel = 1, operandCount = 1;
    int funcCount = 0,
        tagCount = 0,
        procNum = 0,
        ifCount = 0,
        whileCount = 0,
        beginCount = 0,
        endCount = 0,
        bracketCount = 0;
    int i = 0;

    bool isIf = false, isWhile = false, isDescriptionVar = false;

    while (i < t.length) {
      int p = _getPriority(t[i]);
      if (p == -1) {
        if (t[i] != '\n' && t[i] != '\t') {
          rezult.add('${t[i]} ');
        }
      } else {
        if (t[i] == '[') {
          aemCount += 1;
          stack.add('$aemCount АЭМ');
        } else if (t[i] == ']') {
          while (!(RegExp(r'^\d+ АЭМ$').hasMatch(stack.last))) {
            rezult.add('${stack.removeLast()} ');
          }
          rezult.add('${stack.removeLast()} ');
          aemCount = 1;
        } else if (t[i] == '(') {
          if (identifiers.contains(t[i - 1])) {
            if (t[i + 1] != ')') {
              funcCount += 1;
            }
            stack.add('$funcCount Ф');
          } else {
            stack.add(t[i]);
          }
          bracketCount += 1;
        } else if (t[i] == ')') {
          while (
              stack.last != '(' && !(RegExp(r'^\d+ Ф$').hasMatch(stack.last))) {
            rezult.add('${stack.removeLast()} ');
          }
          if (RegExp(r'^\d+ Ф$').hasMatch(stack.last)) {
            stack.add('${funcCount + 1} Ф');
            funcCount = 0;
          }
          stack.removeLast();
          bracketCount -= 1;
          if (bracketCount == 0) {
            if (isIf) {
              while (stack.last != 'if') {
                rezult.add('${stack.removeLast()} ');
              }
              tagCount += 1;
              stack.last += ' М$tagCount';
              rezult.add('М$tagCount УПЛ ');
              isIf = false;
            }
            if (isWhile) {
              while (!(RegExp(r'^while М\d+$').hasMatch(stack.last))) {
                rezult.add('${stack.removeLast()} ');
              }
              tagCount += 1;
              rezult.add('М$tagCount УПЛ ');
              stack.last += ' М$tagCount';
              isWhile = false;
            }
          }
        } else if (t[i] == ',') {
          while (!(RegExp(r'^\d+ АЭМ$').hasMatch(stack.last)) &&
              !(RegExp(r'^\d+ Ф$').hasMatch(stack.last)) &&
              !(RegExp(r'^var').hasMatch(stack.last))) {
            rezult.add('${stack.removeLast()} ');
          }
          if (RegExp(r'^\d+ АЭМ$').hasMatch(stack.last)) {
            aemCount += 1;
            stack.add('$aemCount АЭМ');
          }
          if (RegExp(r'^\d+ Ф$').hasMatch(stack.last)) {
            funcCount += 1;
            stack.add('$funcCount Ф');
          }
        } else if (t[i] == 'if') {
          stack.add(t[i]);
          ifCount += 1;
          bracketCount = 0;
          isIf = true;
        } else if (t[i] == 'else') {
          while (!(RegExp(r'^if М\d+$').hasMatch(stack.last))) {
            rezult.add('${stack.removeLast()} ');
          }
          stack.removeLast();
          tagCount += 1;
          stack.add('if М$tagCount');
          rezult.add('М$tagCount БП М${tagCount - 1} ) { ');
        } else if (t[i] == 'while') {
          tagCount += 1;
          stack.add('${t[i]} М$tagCount');
          rezult.add('М$tagCount ) { ');
          whileCount += 1;
          bracketCount = 0;
          isWhile = true;
        } else if (t[i] == 'for') {
          int j = i + 2;
          bracketCount = 1;
          List<String> a = [];
          while (t[j] != ';') {
            a.add(t[j]);
            j += 1;
            if (t[j] == '(') {
              bracketCount += 1;
            } else if (t[j] == ')') {
              bracketCount -= 1;
            }
          }
          j += 1;
          List<String> b = [];
          while (t[j] != ';') {
            b.add(t[j]);
            j += 1;
            if (t[j] == '(') {
              bracketCount += 1;
            } else if (t[j] == ')') {
              bracketCount -= 1;
            }
          }
          j += 1;
          List<String> c = [];
          while (bracketCount != 0) {
            c.add(t[j]);
            j += 1;
            if (t[j] == '(') {
              bracketCount += 1;
            } else if (t[j] == ')') {
              bracketCount -= 1;
            }
          }
          j += 1;
          List<String> d = [];
          while (t[j] != ';' && t[j] != '{') {
            d.add(t[j]);
            j += 1;
          }
          if (t[j] == '{') {
            j += 1;
            bracketCount = 1;
            d = ['{'];
            while (bracketCount != 0) {
              d.add(t[j]);
              j += 1;
              if (t[j] == '{') {
                bracketCount += 1;
              } else if (t[j] == '}') {
                bracketCount -= 1;
              }
            }
            d.add('}');
          }
          j += 1;
          //варнинг
          t = t.take(14).toList() +
              a +
              [';', '\n', 'while', '('] +
              b +
              [')', '{', '\n'] +
              d +
              ['\n'] +
              c +
              [';', '\n', '}'] +
              t.skip(46).toList();
          i -= 1;
        } else if (t[i] == 'sub') {
          procNum += 1;
          stack.add('PROC $procNum $procLevel');
        } else if (t[i] == '{') {
          if (stack.isNotEmpty && RegExp(r'^PROC').hasMatch(stack.last)) {
            final number = RegExp(r'\d+').allMatches(stack.last).toList();
            stack.removeLast();
            rezult.add('0 Ф ${number[0]} ${number[1]} НП ');
            stack.add('PROC $procNum $procLevel');
          }
          beginCount += 1;
          procLevel = beginCount - endCount + 1;
          stack.add(t[i]);
        } else if (t[i] == '}') {
          endCount += 1;
          procLevel = beginCount - endCount + 1;
          while (stack.last != '{') {
            rezult.add('${stack.removeLast()} ');
          }
          stack.removeLast();
          if (stack.isNotEmpty && RegExp(r'^PROC').hasMatch(stack.last)) {
            stack.removeLast();
            rezult.add('КП ');
          }
          if (ifCount > 0 && RegExp(r'^if М\d+$').hasMatch(stack.last)) {
            String tag = RegExp('М\d+').firstMatch(stack.last)!.input;
            int j = i + 1;
            while (j < t.length && t[j] == '\n') {
              j += 1;
            }
            if (j >= t.length || t[j] != 'else') {
              stack.removeLast();
              rezult.add('$tag ) { ');
              ifCount -= 1;
            }
          }
          if (whileCount > 0 &&
              RegExp(r'^while М\d+ М\d+$').hasMatch(stack.last)) {
            final tag = RegExp('М\d+').allMatches(stack.last).toList();
            stack.removeLast();
            rezult.add('${tag[0]} БП ${tag[1]} ) { ');
            whileCount -= 1;
          }
        } else if (t[i] == ';') {
          if (stack.isNotEmpty && RegExp(r'^PROC').hasMatch(stack.last)) {
            // toList ??
            final number = RegExp(r'\d+').allMatches(stack.last).toList();
            stack.removeLast();
            rezult.add('${number[0]} ${number[1]} НП ');
          } else if (stack.isNotEmpty && stack.last == 'end') {
            stack.removeLast();
            rezult.add('КП ');
          } else if (isDescriptionVar) {
            //??
            final tag = RegExp('\d+').allMatches(stack.last).toList();
            procNum = int.parse(tag[0].input);
            procLevel = int.parse(tag[1].input);
            stack.removeLast();
            rezult.add('$operandCount $procNum $procLevel КО ');
            isDescriptionVar = false;
          } else if (ifCount > 0 || whileCount > 0) {
            while (!(stack.isNotEmpty && stack.last == '{') &&
                !(ifCount > 0 && RegExp(r'^if М\d+$').hasMatch(stack.last)) &&
                !(whileCount > 0 &&
                    RegExp(r'^while М\d+ М\d+$').hasMatch(stack.last))) {
              rezult.add('${stack.removeLast()} ');
            }
            if (ifCount > 0 && RegExp(r'^if М\d+$').hasMatch(stack.last)) {
              //input ??
              String tag = RegExp('М\d+').allMatches(stack.last).first.input;
              int j = i + 1;
              while (t[j] == '\n') {
                j += 1;
              }
              if (t[j] != 'else') {
                stack.removeLast();
              }
              rezult.add('$tag ) { ');
              ifCount -= 1;
            }
            if (whileCount > 0 &&
                RegExp(r'^while М\d+ М\d+$').hasMatch(stack.last)) {
              final tag = RegExp('М\d+').allMatches(stack.last);
              String tag1 = tag.first.input;
              String tag2 = tag.skip(1).first.input;
              rezult.add('$tag1 БП $tag2 ) { ');
              whileCount -= 1;
            }
          } else {
            while (stack.isNotEmpty && stack.last != '{') {
              rezult.add('${stack.removeLast()} ');
            }
          }
        } else {
          while (stack.isNotEmpty && _getPriority(stack.last) >= p) {
            rezult.add('${stack.removeLast()} ');
          }
          stack.add(t[i]);
        }
        i += 1;
      }
    }

    while (stack.isNotEmpty) {
      rezult.add('${stack.removeLast()} ');
    }
    rezult[rezult.indexOf("System . out . println")] = "System.out.println";
    //rezult = re.sub(r'(\d) Ф', r'\1Ф', rezult);

    return ReversePolishEntryOutput(rezult: rezult);
  }
}
