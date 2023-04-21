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
    //
    return true;
  }

  SyntaxisAnalyzerOutput execute(String input) {
    token = input.split(' ');
    for (int i = 0; i < token.length; i++) {
      if (token[i].contains('\n')) {
        List<String> tmp = token[i].replaceFirst('\n', ' ').split(' ');
        token[i] = tmp.last;
        token.insert(i, '\n');
        token.insert(i, tmp.first);
        i += 2;
      }
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

    while (i < token.length) {
      while (nextSymbol == '\n') {
        scan;
      }
      if (tabLevel) {
        if (nextSymbol.startsWith('\t')) {
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
        //выражение
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
        if (!RegExp(r'range\((\d+):(\d+)\):').hasMatch(nextSymbol)) {
          errorWrongFor.message += i.toString();
          return errorWrongFor;
        }
        scan;
        tabLevel = true;
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
