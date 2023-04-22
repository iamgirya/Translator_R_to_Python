import 'syntaxis_analyzers_models.dart';

class AnalyzerErrorsHolder {
  static int lineCount = 1;
  static int tokenCount = 0;

  static SyntaxisAnalyzerOutput get errorCommon => SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Строка ошибки: $lineCount, номер токена: $tokenCount',
        errorName: 'Неправильная запись выражения',
      );
  static SyntaxisAnalyzerOutput get errorNotDeclare => SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Строка ошибки: $lineCount, номер токена: $tokenCount',
        errorName: 'Идентификатор не найден',
      );

  static SyntaxisAnalyzerOutput get errorOfStart => SyntaxisAnalyzerOutput(
        isOk: false,
        message: '',
        errorName: 'Не подключена библиотека goto',
      );
  static SyntaxisAnalyzerOutput get errorLostMark => SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Строка ошибки: $lineCount, номер токена: $tokenCount',
        errorName: 'Ожидался маркер',
      );
  static SyntaxisAnalyzerOutput get errorNumberMark => SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Строка ошибки: $lineCount, номер токена: $tokenCount',
        errorName: 'Встречен повторяющийся маркер',
      );
  static SyntaxisAnalyzerOutput get errorNotPairedMark =>
      SyntaxisAnalyzerOutput(
        isOk: false,
        message: '',
        errorName: 'Не для каждого goto есть пара label',
      );
  static SyntaxisAnalyzerOutput get errorNotEndIf => SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Строка ошибки: $lineCount, номер токена: $tokenCount',
        errorName: 'Ожидалось встретить ":"',
      );
  static SyntaxisAnalyzerOutput get errorTabLevel => SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Строка ошибки: $lineCount, номер токена: $tokenCount',
        errorName: 'Ожидалась табуляция',
      );
  static SyntaxisAnalyzerOutput get errorNotIdentificator =>
      SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Строка ошибки: $lineCount, номер токена: $tokenCount',
        errorName: 'Ожидался идентификатор',
      );
  static SyntaxisAnalyzerOutput get errorWrongFor => SyntaxisAnalyzerOutput(
        isOk: false,
        message: 'Строка ошибки: $lineCount, номер токена: $tokenCount',
        errorName: 'Ошибка в записи for',
      );
}
