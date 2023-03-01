// ignore_for_file: unused_element, unused_field

import 'lexical_analyzer.dart';
import 'tokens/divider_tokens.dart';
import 'tokens/key_words_tokens.dart';
import 'tokens/operation_tokens.dart';

typedef State = StateOut Function(String str);

class StateOut {
  State? nextState;
  SemanticProcedures? semanticProcedure;

  StateOut(this.nextState, [this.semanticProcedure]);

  factory StateOut.error() => StateOut((str) => throw UnimplementedError());
}

class StateMachine {
  static bool _isNumber(String str) => int.tryParse(str) != null;
  static bool _isKeyWord(String str) => KeyWordTokens.check(str) != null;
  static bool _isDivider(String str) => DividerTokens.check(str) != null;
  static bool _isOperation(String str) => OperationTokens.check(str) != null;
  static bool _isSymbol(String str) => !_isNumber(str) && !_isDivider(str);

  bool _isLastSymbol = false;
  late State? _currentState = s;

  Stream<StateOut> executeStream(String str, bool isLastLine) async* {
    _isLastSymbol = isLastLine;

    while (_currentState != null) {
      var out = _currentState!(str);
      yield out;
      _currentState = out.nextState;
    }
  }

  StateOut execute(String str, bool isLastSymbol) {
    _isLastSymbol = isLastSymbol;

    var out = _currentState!(str);
    _currentState = out.nextState;
    return out;
  }

  late State s = (str) {
    if (_isSymbol(str)) return StateOut(q1);
    if (_isNumber(str)) return StateOut(q3);

    final div = DividerTokens.check(str);
    if (div == DividerTokens.quotes) return StateOut(q9);
    if (div == DividerTokens.slash) return StateOut(q10);

    if (_isOperation(str)) {
      return StateOut(s, SemanticProcedures.p5);
    }

    if (_isDivider(str)) {
      return StateOut(s, SemanticProcedures.p6);
    }

    if (_isLastSymbol) {
      return StateOut(z);
    }

    return StateOut.error();
  };

  late State q1 = (str) {
    if (_isSymbol(str)) return StateOut(q1);
    if (_isNumber(str)) return StateOut(q2);
    if (_isDivider(str) || _isOperation(str)) {
      return StateOut(s, SemanticProcedures.p1);
    }

    return StateOut.error();
  };

  late State q2 = (str) {
    if (_isNumber(str) || _isSymbol(str)) return StateOut(q2);
    if (_isDivider(str) || _isOperation(str)) {
      return StateOut(s, SemanticProcedures.p2);
    }

    return StateOut.error();
  };

  late State q3 = (str) {
    if (_isNumber(str)) {
      return StateOut(q3);
    }

    if (str.toLowerCase() == "e") {
      return StateOut(q6);
    }

    if (DividerTokens.check(str) == DividerTokens.dot) {
      return StateOut(q4);
    }

    if (_isDivider(str) || _isOperation(str)) {
      return StateOut(s, SemanticProcedures.p3);
    }

    return StateOut.error();
  };

  late State q4 = (str) {
    if (_isNumber(str)) {
      return StateOut(q5);
    }

    return StateOut.error();
  };

  late State q5 = (str) {
    if (_isNumber(str)) {
      return StateOut(q5);
    }

    if (str.toLowerCase() == "e") {
      return StateOut(q6);
    }

    if (_isDivider(str) || _isOperation(str)) {
      return StateOut(s, SemanticProcedures.p3);
    }

    return StateOut.error();
  };

  late State q6 = (str) {
    if (_isNumber(str)) {
      return StateOut(q8);
    }

    final op = OperationTokens.check(str);

    if ([OperationTokens.plus, OperationTokens.minus].contains(op)) {
      return StateOut(q7);
    }

    return StateOut.error();
  };

  late State q7 = (str) {
    if (_isNumber(str)) {
      return StateOut(q8);
    }

    return StateOut.error();
  };

  late State q8 = (str) {
    if (_isNumber(str)) {
      return StateOut(q8);
    }

    if (_isDivider(str) || _isOperation(str)) {
      return StateOut(s, SemanticProcedures.p3);
    }

    return StateOut.error();
  };

  late State q9 = (str) {
    final div = DividerTokens.check(str);
    if (div != DividerTokens.quotes) return StateOut(q9);
    if (div == DividerTokens.quotes) return StateOut(s, SemanticProcedures.p4);

    return StateOut.error();
  };

  late State q10 = (str) {
    final div = DividerTokens.check(str);
    if ([DividerTokens.slash, DividerTokens.star].contains(div)) {
      return StateOut(q11);
    }

    return StateOut.error();
  };

  late State q11 = (str) {
    final div = DividerTokens.check(str);
    if (div == DividerTokens.star) {
      return StateOut(q12);
    }
    if (_isLastSymbol) {
      return StateOut(z);
    }
    if (!DividerTokens.isNewLine(div)) {
      return StateOut(q11);
    }

    return StateOut(s);
  };

  late State q12 = (str) {
    final div = DividerTokens.check(str);
    if (div == DividerTokens.slash) {
      return StateOut(s);
    }

    return StateOut(q11);
  };

  late State z = (str) {
    return StateOut(null);
  };
}
