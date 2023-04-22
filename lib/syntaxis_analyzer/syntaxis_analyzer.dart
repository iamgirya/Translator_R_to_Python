import '../lexical_anallyzer/models/lexical_analyzer_output.dart';
import 'syntaxis_analyzers_models.dart';

class SyntaxisAnalyzer {
  List<String> token = [];
  List<String> identifiers = [];
  List<String> gotoMarks = [];
  List<String> labelMarks = [];
  String nextSymbol = '';
  int i = 0;
  bool tabLevel = false;

  void get scan => nextSymbol = token[i++];

  bool _isIdentifier(String token) {
    return identifiers.contains(token);
  }

  bool _isIdentifierOrConst(String token) {
    return identifiers.contains(token) ||
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

  SyntaxisAnalyzerOutput get errorCommon => SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Индекс ошибки: $i',
        errorName: 'Неправильная запись выражения',
      );

  SyntaxisAnalyzerOutput? _term() {
    bool isNeedNext = true;
    while (isNeedNext) {
      isNeedNext = false;
      if (!_isIdentifierOrConst(nextSymbol)) {
        return errorCommon;
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
          return errorCommon;
        }
      } else {
        if (nextSymbol != ',') {
          return errorCommon;
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
          return errorCommon;
        }
      } else {
        if (nextSymbol != ',') {
          return errorCommon;
        }
      }
      scan;
      needIdentificator = !needIdentificator;
    }
    scan;
    return null;
  }

  SyntaxisAnalyzerOutput? _StartOfTerm() {
    if (!_isIdentifier(nextSymbol)) {
      return errorCommon;
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
      return errorCommon;
    }
    return null;
  }

  SyntaxisAnalyzerOutput execute(
    String input,
    LexicalAnalyzerOutput lexicalInput,
    int costilAddVars,
  ) {
    token = input.split(' ');

    parseTextToToken();

    identifiers =
        lexicalInput.identifiers.map((e) => e.value.toString()).toList();

    for (int i = 1; i <= costilAddVars; i++) {
      identifiers.add('V$i');
    }

    final errorOfStart = SyntaxisAnalyzerOutput(
        isOk: false, message: '', errorName: 'Не подключена библиотека goto');
    final errorLostMark = SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Индекс лексемы ожидающей маркер: ',
        errorName: 'Ожидался маркер');
    final errorNumberMark = SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Индекс повтора: ',
        errorName: 'Встречен повторяющийся маркер');
    final errorNotPairedMark = SyntaxisAnalyzerOutput(
        isOk: false,
        message: '',
        errorName: 'Не для каждого goto есть пара label');
    final errorNotEndIf = SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Индекс ошибки: ',
        errorName: 'Ожидалось встретить ":"');
    final errorTabLevel = SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Индекс ошибки: ',
        errorName: 'Ожидалась табуляция');
    final errorNotIdentificator = SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Индекс ошибки: ',
        errorName: 'Ожидался идентификатор');
    final errorWrongFor = SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Индекс ошибки: ',
        errorName: 'Ошибка в записи for');

    scan;
    if (nextSymbol != 'from') {
      return errorOfStart;
    }
    scan;
    if (nextSymbol != 'goto') {
      return errorOfStart;
    }
    scan;
    if (nextSymbol != 'import') {
      return errorOfStart;
    }
    scan;
    if (nextSymbol != 'with_goto') {
      return errorOfStart;
    }
    scan;

    while (i < token.length) {
      while (nextSymbol == '\n') {
        scan;
      }
      if (tabLevel) {
        if (nextSymbol.startsWith('\t')) {
          nextSymbol = nextSymbol.substring(1);
          tabLevel = false;
        } else {
          errorTabLevel.message += i.toString();
          return errorTabLevel;
        }
      }
      if (nextSymbol == 'goto') {
        scan;
        if (RegExp(r'\.(\d+)M').hasMatch(nextSymbol)) {
          String tmp = nextSymbol.substring(1, nextSymbol.length - 1);
          if (gotoMarks.contains(tmp)) {
            errorNumberMark.message = errorNumberMark.message + (i).toString();
            return errorNumberMark;
          }
          gotoMarks.add(tmp);
          scan;
        } else {
          errorLostMark.message = errorLostMark.message + (i - 1).toString();
          return errorLostMark;
        }
      } else if (nextSymbol == 'label') {
        scan;
        if (RegExp(r'\.(\d+)M').hasMatch(nextSymbol)) {
          String tmp = nextSymbol.substring(1, nextSymbol.length - 1);
          if (labelMarks.contains(tmp)) {
            errorNumberMark.message = errorNumberMark.message + (i).toString();
            return errorNumberMark;
          }
          labelMarks.add(tmp);
          scan;
        } else {
          errorLostMark.message = errorLostMark.message + (i - 1).toString();
          return errorLostMark;
        }
      } else if (nextSymbol == 'if') {
        scan;
        if (nextSymbol == 'not') {
          scan;
        }
        final extension = _StartOfTerm();
        if (extension != null) {
          return extension;
        }
        if (nextSymbol != ':') {
          errorNotEndIf.message = errorNotEndIf.message + (i).toString();
          return errorNotEndIf;
        }
        tabLevel = true;
        scan;
      } else if (nextSymbol == 'for') {
        scan;
        if (!_isIdentifier(nextSymbol)) {
          errorNotIdentificator.message += i.toString();
          return errorNotIdentificator;
        }
        scan;
        if (nextSymbol != 'in') {
          errorWrongFor.message += i.toString();
          return errorWrongFor;
        }
        scan;
        if (!RegExp(r'range').hasMatch(nextSymbol)) {
          errorWrongFor.message += i.toString();
          return errorWrongFor;
        }
        scan;
        if (nextSymbol != '(') {
          errorWrongFor.message += i.toString();
          return errorWrongFor;
        } else {
          scan;
          final rezult = _func();
          if (rezult != null) {
            return rezult;
          }
        }

        if (nextSymbol != ':') {
          errorWrongFor.message += i.toString();
          return errorWrongFor;
        }
        scan;

        tabLevel = true;
      } else if (_isIdentifier(nextSymbol)) {
        _StartOfTerm();
      } else {
        return errorCommon;
      }
    }

    if (labelMarks.length != gotoMarks.length ||
        !(labelMarks.fold(
          true,
          (previousValue, element) =>
              previousValue && (gotoMarks.contains(element)),
        ))) {
      return errorNotPairedMark;
    }

    return SyntaxisAnalyzerOutput(isOk: true, message: '');
  }
}
