import '../lexical_anallyzer/models/lexical_analyzer_output.dart';
import '../lexical_anallyzer/tokens/token.dart';
import 'polish_models.dart';

class ReversePolishEntry {
  List<InfoString> structStack = [];
  List<String> stack = [];
  List<String> rezult = [];
  int funcCount = 0,
      markCount = 0,
      procNum = 0,
      ifCount = 0,
      whileCount = 0,
      beginCount = 0,
      endCount = 0,
      bracketCount = 0,
      aemCount = 0,
      procLevel = 0,
      operandCount = 0,
      indexCount = 0;

  bool isIf = false, isWhile = false, isDescriptionVar = false;

  int _getPriority(String token) {
    if (['('].contains(token)) {
      return 0;
    }
    if ([')', ','].contains(token)) {
      return 1;
    }
    if (['<-', '=', 'in'].contains(token)) {
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
    if (['+', '-', '+=', '-=', '++', '--'].contains(token)) {
      return 7;
    }
    if (['*', '/', '%', '*=', '/='].contains(token)) {
      return 8;
    }
    if (['**', ':'].contains(token)) {
      return 9;
    }
    if ([
      '}',
      'procedure',
      'int',
      'double',
      'length',
      'boolean',
      'String',
      'float',
      'args',
      'return',
      'main'
    ].contains(token)) {
      return 10;
    }
    return -1;
  }

  ReversePolishEntryOutput execute(LexicalAnalyzerOutput input) {
    List<String> identifiers =
        input.identifiers.map((e) => e.value.toString()).toList()
          ..addAll(input.numberValues.map((e) => e.value.toString()))
          ..addAll(input.stringValues.map((e) => '"${e.value}"'));
    List<String> t = input.tokens
        .map(
          (e) => e is ValToken ? e.value.toString() : e.lexeme,
        )
        .toList()
      ..removeWhere((element) => element == ' ');

    for (int i = 0; i < t.length; i++) {
      if (i - 1 >= 0 &&
          i + 1 < t.length &&
          t[i - 1] == '"' &&
          t[i + 1] == '"') {
        t[i] = '"${t[i]}"';
        t.removeAt(i - 1);
        t.removeAt(i);
      }
    }

    for (int i = 0; i < t.length; i++) {
      String token = t[i];

      if (identifiers.contains(token)) {
        rezult.add(token);
      } else if (structStack.isNotEmpty &&
          [StructType.AEM, StructType.F].contains(structStack.last.token) &&
          token == ',') {
        //index and func add args
        while (stack.last != InfoString.mark) {
          rezult.add(stack.removeLast());
        }
        structStack.last.info++;
      } else if (structStack.isNotEmpty &&
          token == structStack.last.token.getEndName()) {
        //end of struct
        while (stack.last != InfoString.mark) {
          rezult.add(stack.removeLast());
        }
        structStack.last.writeToRezult(rezult);
        stack.removeLast();
        structStack.removeLast();
      } else {
        if (token == '[') {
          //index start
          stack.add(InfoString.mark);
          structStack.add(InfoString(StructType.AEM, 2));
        } else if (i > 0 && identifiers.contains(t[i - 1]) && token == '(') {
          //func start
          bool isProcedure = i + 1 < t.length && t[i + 1] == ')';
          stack.add(InfoString.mark);
          structStack.add(InfoString(StructType.F, isProcedure ? 1 : 2));
        } else if (token == '(') {
          //bracket start
          stack.add(InfoString.mark);
          structStack.add(InfoString(StructType.bracket, -1));
        } else if (token == 'if') {
          //if start
          stack.add(InfoString.mark);
          markCount++;
          structStack.add(InfoString(StructType.ifThen, markCount));
          structStack.add(InfoString(StructType.ifCondition, -1));
          i++;
        } else if (token == 'else') {
          //else start
          stack.add(InfoString.mark);
          markCount++;
          rezult.insert(rezult.length - 1, '${markCount}M BP');
          structStack.add(InfoString(StructType.ifElse, markCount));
          i++;
        } else if (token == 'while') {
          //while start
          stack.add(InfoString.mark);
          markCount++;
          rezult.add('${markCount}M:');
          markCount++;
          structStack.add(InfoString(StructType.whileThen, markCount));
          structStack.add(InfoString(StructType.whileCondition, -1));
          i++;
        } else if (token == 'for') {
          //for start
          stack.add(InfoString.mark);
          markCount++;
          rezult.add('${markCount}M:');
          markCount++;
          structStack.add(InfoString(StructType.forThen, markCount));
          structStack.add(InfoString(StructType.forCondition, -1));
          i++;
        } else if (structStack.isNotEmpty &&
            [StructType.ifThen, StructType.whileThen, StructType.forThen]
                .contains(structStack.last.token) &&
            token == '{') {
          //all then start
          stack.add(InfoString.mark);
          rezult.add('${markCount}M YPL');
        } else if (token == '\n') {
          //новая строка
          while (stack.isNotEmpty && _getPriority(stack.last) > 1) {
            rezult.add(stack.removeLast());
          }
        } else {
          //priority
          int priotiry = _getPriority(token);
          if (stack.isEmpty) {
            stack.add(token);
          } else if (_getPriority(stack.last) < priotiry) {
            stack.add(token);
          } else {
            while (stack.isNotEmpty && _getPriority(stack.last) >= priotiry) {
              rezult.add(stack.removeLast());
            }
            stack.add(token);
          }
        }
      }
    }

    while (stack.isNotEmpty) {
      rezult.add('${stack.removeLast()} ');
    }

    return ReversePolishEntryOutput(rezult: rezult);
  }
}
