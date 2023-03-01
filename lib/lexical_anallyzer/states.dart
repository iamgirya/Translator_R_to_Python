// ignore_for_file: unused_element

import 'tokens/divider_tokens.dart';
import 'tokens/key_words_tokens.dart';
import 'tokens/operation_tokens.dart';

typedef State = StateOut Function(String str);

class StateOut {
  State nextState;
  dynamic semanticProcedure;

  StateOut(this.nextState, [this.semanticProcedure]);

  factory StateOut.empty() => StateOut((str) => throw UnimplementedError());
}

bool _isNumber(String str) => int.tryParse(str) != null;
bool _isKeyWord(String str) => KeyWordTokens.check(str) != null;
bool _isDivider(String str) => DividerTokens.check(str) != null;
bool _isOperation(String str) => OperationTokens.check(str) != null;
bool _isSymbol(String str) => !_isNumber(str) && !_isDivider(str);

State s = (str) {
  if (_isSymbol(str)) return StateOut(q1);

  return StateOut.empty();
};

State q1 = (str) {
  if (_isSymbol(str)) return StateOut(q1);
  if (_isNumber(str)) return StateOut(q2);
  if (_isDivider(str) || _isOperation(str)) return StateOut(s);

  return StateOut.empty();
};

State q2 = (str) {
  if (_isNumber(str) || _isSymbol(str)) return StateOut(q2);
  if (_isDivider(str) || _isOperation(str)) return StateOut(s);

  return StateOut.empty();
};

State q3 = (str) {
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
    return StateOut(s);
  }

  return StateOut.empty();
};

State q4 = (str) {
  if (_isNumber(str)) {
    return StateOut(q5);
  }

  return StateOut.empty();
};

State q5 = (str) {
  if (_isNumber(str)) {
    return StateOut(q5);
  }

  if (str.toLowerCase() == "e") {
    return StateOut(q6);
  }

  if (_isDivider(str) || _isOperation(str)) {
    return StateOut(s);
  }

  return StateOut.empty();
};

State q6 = (str) {
  if (_isNumber(str)) {
    return StateOut(q8);
  }

  final op = OperationTokens.check(str);

  if ([OperationTokens.plus, OperationTokens.minus].contains(op)) {
    return StateOut(q7);
  }

  return StateOut.empty();
};

State q7 = (str) {
  if (_isNumber(str)) {
    return StateOut(q8);
  }

  return StateOut.empty();
};

State q8 = (str) {
  if (_isNumber(str)) {
    return StateOut(q8);
  }

  if (_isDivider(str) || _isOperation(str)) {
    return StateOut(s);
  }

  return StateOut.empty();
};

State q9 = (str) {
  if (str != "'") return StateOut(q9);
  if (str == "'") return StateOut(s);

  return StateOut.empty();
};

State q10 = (str) {
  final div = DividerTokens.check(str);
  if ([DividerTokens.slash, DividerTokens.star].contains(div)) {
    return StateOut(q11);
  }

  return StateOut.empty();
};

State q11 = (str) {
  final div = DividerTokens.check(str);
  if (div == DividerTokens.star) {
    return StateOut(q12);
  }
  if (!DividerTokens.isNewLine(div)) {
    return StateOut(q11);
  }

  return StateOut(s);
};

State q12 = (str) {
  final div = DividerTokens.check(str);
  if (div == DividerTokens.slash) {
    return StateOut(s);
  }

  return StateOut(q11);
};
