import '../lexical_anallyzer/models/lexical_analyzer_output.dart';
import 'error_models.dart';
import 'syntaxis_analyzers_models.dart';

class SyntaxisAnalyzer {
  List<String> token = [];
  List<String> identifiers = [];
  List<String> gotoMarks = [];
  List<String> labelMarks = [];
  List<bool> isVarDeclared = [];
  List<bool> needToDeclare = [];
  String nextSymbol = '';
  int i = 0;
  bool tabLevel = false;

  void get scan {
    nextSymbol = token[i++];
    AnalyzerErrorsHolder.tokenCount++;
  }

  void parseTextToToken() {
    for (int i = 0; i < token.length; i++) {
      if (token[i].contains('\n')) {
        List<String> tmp = token[i].replaceFirst('\n', ' ').split(' ');
        token[i] = tmp.last;
        token.insert(i, '\n');
        token.insert(i, tmp.first);
        i += 2;
      }
    }
    for (int i = 0; i < token.length; i++) {
      if (token[i].contains('(')) {
        List<String> tmp = token[i].replaceFirst('(', ' ').split(' ');
        token[i] = tmp.last;
        token.insert(i, '(');
        token.insert(i, tmp.first);
        i += 2;
      }
    }
    for (int i = 0; i < token.length; i++) {
      if (token[i].contains(')')) {
        List<String> tmp = token[i].replaceFirst(')', ' ').split(' ');
        token[i] = tmp.last;
        token.insert(i, ')');
        token.insert(i, tmp.first);
        i += 2;
      }
    }
    for (int i = 0; i < token.length; i++) {
      if (token[i].contains('[')) {
        List<String> tmp = token[i].replaceFirst('[', ' ').split(' ');
        token[i] = tmp.last;
        token.insert(i, '[');
        token.insert(i, tmp.first);
        i += 2;
      }
    }
    for (int i = 0; i < token.length; i++) {
      if (token[i].contains(']')) {
        List<String> tmp = token[i].replaceFirst(']', ' ').split(' ');
        token[i] = tmp.last;
        token.insert(i, ']');
        token.insert(i, tmp.first);
        i += 2;
      }
    }
    for (int i = 0; i < token.length; i++) {
      if (token[i].contains(',')) {
        List<String> tmp = token[i].replaceFirst(',', ' ').split(' ');
        token[i] = tmp.last;
        token.insert(i, ',');
        token.insert(i, tmp.first);
        i += 2;
      }
    }
    token.removeWhere((element) => element == '');
    token.add('');
  }

  bool _isIdentifier(String token) {
    final isInd = identifiers.contains(token);
    if (isInd) {
      needToDeclare[identifiers.indexOf(token)] = true;
    }
    return isInd;
  }

  bool _isIdentifierOrConst(String token) {
    return (identifiers.contains(token) &&
            isVarDeclared[identifiers.indexOf(token)]) ||
        num.tryParse(token) != null ||
        (token[0] == '"' && token[token.length - 1] == '"');
  }

  bool _isOperator(String token) {
    return [
      '<',
      '<=',
      '!=',
      '>',
      '>=',
      '+',
      '-',
      '*',
      '/',
      '%',
      '**',
      '&&',
      '||'
    ].contains(token);
  }

  SyntaxisAnalyzerOutput? _term() {
    bool isNeedNext = true;
    while (isNeedNext) {
      isNeedNext = false;
      if (!_isIdentifierOrConst(nextSymbol)) {
        if (identifiers.contains(nextSymbol) &&
            !isVarDeclared[identifiers.indexOf(nextSymbol)]) {
          return AnalyzerErrorsHolder.errorNotDeclare;
        }
        return AnalyzerErrorsHolder.errorCommon;
      }
      scan;

      if (nextSymbol == '(') {
        scan;
        final rezult = _func();
        if (rezult != null) {
          return rezult;
        }
      } else if (nextSymbol == '[') {
        scan;
        final rezult = _array();
        if (rezult != null) {
          return rezult;
        }
      }

      if (_isOperator(nextSymbol)) {
        isNeedNext = true;
        scan;
      }
    }
    return null;
  }

  SyntaxisAnalyzerOutput? _func() {
    bool needIdentificator = true;
    while (nextSymbol != ')') {
      if (needIdentificator) {
        if (!_isIdentifierOrConst(nextSymbol)) {
          if (identifiers.contains(nextSymbol) &&
              !isVarDeclared[identifiers.indexOf(nextSymbol)]) {
            return AnalyzerErrorsHolder.errorNotDeclare;
          }
          return AnalyzerErrorsHolder.errorCommon;
        }
      } else {
        if (nextSymbol != ',') {
          return AnalyzerErrorsHolder.errorCommon;
        }
      }
      scan;
      needIdentificator = !needIdentificator;
    }
    scan;
    return null;
  }

  SyntaxisAnalyzerOutput? _array() {
    bool needIdentificator = true;
    while (nextSymbol != ']') {
      if (needIdentificator) {
        if (!_isIdentifierOrConst(nextSymbol)) {
          if (identifiers.contains(nextSymbol) &&
              !isVarDeclared[identifiers.indexOf(nextSymbol)]) {
            return AnalyzerErrorsHolder.errorNotDeclare;
          }
          return AnalyzerErrorsHolder.errorCommon;
        }
      } else {
        if (nextSymbol != ',') {
          return AnalyzerErrorsHolder.errorCommon;
        }
      }
      scan;
      needIdentificator = !needIdentificator;
    }
    scan;
    return null;
  }

  SyntaxisAnalyzerOutput? _startOfTerm() {
    if (!_isIdentifier(nextSymbol)) {
      return AnalyzerErrorsHolder.errorCommon;
    }
    scan;

    if (nextSymbol == '=' || nextSymbol == '<-') {
      scan;
      return _term();
    } else if (nextSymbol == '(') {
      scan;
      return _func();
    } else if (nextSymbol == '[') {
      scan;
      return _array();
    } else if (nextSymbol != '\n' && nextSymbol != ':') {
      return AnalyzerErrorsHolder.errorCommon;
    }
    return null;
  }

  SyntaxisAnalyzerOutput? _startOfProg() {
    scan;
    if (nextSymbol != 'from') {
      return AnalyzerErrorsHolder.errorOfStart;
    }
    scan;
    if (nextSymbol != 'goto') {
      return AnalyzerErrorsHolder.errorOfStart;
    }
    scan;
    if (nextSymbol != 'import') {
      return AnalyzerErrorsHolder.errorOfStart;
    }
    scan;
    if (nextSymbol != 'with_goto') {
      return AnalyzerErrorsHolder.errorOfStart;
    }
    scan;
    return null;
  }

  SyntaxisAnalyzerOutput? _label() {
    scan;
    if (RegExp(r'\.(\d+)M').hasMatch(nextSymbol)) {
      String tmp = nextSymbol.substring(1, nextSymbol.length - 1);
      if (labelMarks.contains(tmp)) {
        return AnalyzerErrorsHolder.errorNumberMark;
      }
      labelMarks.add(tmp);
      scan;
    } else {
      return AnalyzerErrorsHolder.errorLostMark;
    }
    return null;
  }

  SyntaxisAnalyzerOutput? _goto() {
    scan;
    if (RegExp(r'\.(\d+)M').hasMatch(nextSymbol)) {
      String tmp = nextSymbol.substring(1, nextSymbol.length - 1);
      if (gotoMarks.contains(tmp)) {
        return AnalyzerErrorsHolder.errorNumberMark;
      }
      gotoMarks.add(tmp);
      scan;
    } else {
      return AnalyzerErrorsHolder.errorLostMark;
    }
    return null;
  }

  SyntaxisAnalyzerOutput? _if() {
    scan;
    if (nextSymbol == 'not') {
      scan;
    }
    final extension = _startOfTerm();
    if (extension != null) {
      return extension;
    }
    if (nextSymbol != ':') {
      return AnalyzerErrorsHolder.errorNotEndIf;
    }
    tabLevel = true;
    scan;
    return null;
  }

  SyntaxisAnalyzerOutput? _for() {
    scan;
    if (!_isIdentifier(nextSymbol)) {
      return AnalyzerErrorsHolder.errorNotIdentificator;
    }
    scan;
    if (nextSymbol != 'in') {
      return AnalyzerErrorsHolder.errorWrongFor;
    }
    scan;
    if (!RegExp(r'range').hasMatch(nextSymbol)) {
      return AnalyzerErrorsHolder.errorWrongFor;
    }
    scan;
    if (nextSymbol != '(') {
      return AnalyzerErrorsHolder.errorWrongFor;
    } else {
      scan;
      final rezult = _func();
      if (rezult != null) {
        return rezult;
      }
    }

    if (nextSymbol != ':') {
      return AnalyzerErrorsHolder.errorWrongFor;
    }
    scan;

    tabLevel = true;
    return null;
  }

  SyntaxisAnalyzerOutput? _extension() {
    final start = _startOfProg();
    if (start != null) {
      return start;
    }

    while (i < token.length) {
      while (nextSymbol == '\n') {
        AnalyzerErrorsHolder.lineCount++;
        AnalyzerErrorsHolder.tokenCount = 0;
        scan;
      }
      if (tabLevel) {
        if (nextSymbol.startsWith('\t')) {
          nextSymbol = nextSymbol.substring(1);
          tabLevel = false;
        } else {
          return AnalyzerErrorsHolder.errorTabLevel;
        }
      }
      SyntaxisAnalyzerOutput? rezult;
      if (nextSymbol == 'goto') {
        rezult = _goto();
      } else if (nextSymbol == 'label') {
        rezult = _label();
      } else if (nextSymbol == 'if') {
        rezult = _if();
      } else if (nextSymbol == 'for') {
        rezult = _for();
      } else if (_isIdentifier(nextSymbol)) {
        rezult = _startOfTerm();
      } else {
        rezult = AnalyzerErrorsHolder.errorCommon;
      }

      if (rezult != null) {
        return rezult;
      }

      for (int i = 0; i < needToDeclare.length; i++) {
        isVarDeclared[i] = needToDeclare[i];
      }
    }
    return null;
  }

  SyntaxisAnalyzerOutput execute(
    String input,
    LexicalAnalyzerOutput lexicalInput,
    int costilAddVars,
  ) {
    AnalyzerErrorsHolder.lineCount = 1;
    AnalyzerErrorsHolder.tokenCount = 0;
    token = input.split(' ');

    parseTextToToken();

    identifiers =
        lexicalInput.identifiers.map((e) => e.value.toString()).toList();

    for (int i = 0; i < identifiers.length; i++) {
      if (identifiers[i] == 'sum' ||
          identifiers[i] == 'print' ||
          identifiers[i] == 'b') {
        isVarDeclared.add(true);
        needToDeclare.add(true);
      } else {
        isVarDeclared.add(false);
        needToDeclare.add(false);
      }
    }

    for (int i = 1; i <= costilAddVars; i++) {
      identifiers.add('V$i');
      isVarDeclared.add(false);
      needToDeclare.add(false);
    }

    final rezult = _extension();
    if (rezult != null) {
      return rezult;
    }

    if (labelMarks.length != gotoMarks.length ||
        !(labelMarks.fold(
          true,
          (previousValue, element) =>
              previousValue && (gotoMarks.contains(element)),
        ))) {
      return AnalyzerErrorsHolder.errorNotPairedMark;
    }

    return SyntaxisAnalyzerOutput(isOk: true, message: '');
  }
}
