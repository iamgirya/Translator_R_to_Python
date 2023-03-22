part of 'state_machine.dart';

class S extends State {
  @override
  call(str) {
    if (str == ';') {
      print(str);
    }
    if (_isSymbol(str)) return (Q1(), null);
    if (_isNumber(str)) return (Q3(), null);

    final div = DividerTokens.check(str);
    if (div == DividerTokens.quotes) return (Q9(), null);
    if (div == DividerTokens.slash) return (Q10(), null);

    if (_isOperation(str)) return (S(), SemanticProcedure.p5);

    if (_isDivider(str)) {
      return (S(), SemanticProcedure.p6);
    }

    if (State._isLastSymbol) return (Z(), null);

    return (ErrorState(), null);
  }
}

class Q1 extends State {
  @override
  call(str) {
    if (_isSymbol(str)) return (Q1(), null);
    if (_isNumber(str)) return (Q2(), null);
    if (_isDivider(str) || _isOperation(str)) {
      return (S(), SemanticProcedure.p1);
    }

    return (ErrorState(), null);
  }
}

class Q2 extends State {
  @override
  call(str) {
    if (_isNumber(str) || _isSymbol(str)) return (Q2(), null);
    if (_isDivider(str) || _isOperation(str)) {
      return (S(), SemanticProcedure.p2);
    }

    return (ErrorState(), null);
  }
}

// State q2 = (str) {
//   if (_isNumber(str) || _isSymbol(str)) return StateOut(q2);
//   if (_isDivider(str) || _isOperation(str)) {
//     return StateOut(s, SemanticProcedures.p2);
//   }

//   return StateOut.error();
// };

class Q3 extends State {
  @override
  call(str) {
    if (_isNumber(str)) return (Q3(), null);

    if (str.toLowerCase() == "e") return (Q6(), null);

    if (DividerTokens.check(str) == DividerTokens.dot) return (Q4(), null);

    if (_isDivider(str) || _isOperation(str)) {
      return (S(), SemanticProcedure.p3);
    }
    return (ErrorState(), null);
  }
}
// State q3 = (str) {
//   if (_isNumber(str)) {
//     return StateOut(q3);
//   }

//   if (str.toLowerCase() == "e") {
//     return StateOut(q6);
//   }

//   if (DividerTokens.check(str) == DividerTokens.dot) {
//     return StateOut(q4);
//   }

//   if (_isDivider(str) || _isOperation(str)) {
//     return StateOut(s, SemanticProcedures.p3);
//   }

//   return StateOut.error();
// };

class Q4 extends State {
  @override
  call(str) {
    if (_isNumber(str)) return (Q5(), null);

    return (ErrorState(), null);
  }
}

// State q4 = (str) {
//   if (_isNumber(str)) {
//     return StateOut(q5);
//   }

//   return StateOut.error();
// };

class Q5 extends State {
  @override
  call(str) {
    if (_isNumber(str)) return (Q5(), null);
    if (str.toLowerCase() == "e") return (Q6(), null);
    if (_isDivider(str) || _isOperation(str)) {
      return (S(), SemanticProcedure.p3);
    }
    return (ErrorState(), null);
  }
}

// State q5 = (str) {
//   if (_isNumber(str)) {
//     return StateOut(q5);
//   }

//   if (str.toLowerCase() == "e") {
//     return StateOut(q6);
//   }

//   if (_isDivider(str) || _isOperation(str)) {
//     return StateOut(s, SemanticProcedures.p3);
//   }

//   return StateOut.error();
// };

class Q6 extends State {
  @override
  call(str) {
    if (_isNumber(str)) return (Q8(), null);
    final op = OperationTokens.check(str);
    if ([OperationTokens.plus, OperationTokens.minus].contains(op)) {
      return (Q7(), null);
    }
    return (ErrorState(), null);
  }
}

// State q6 = (str) {
//   if (_isNumber(str)) {
//     return StateOut(q8);
//   }

//   final op = OperationTokens.check(str);

//   if ([OperationTokens.plus, OperationTokens.minus].contains(op)) {
//     return StateOut(q7);
//   }

//   return StateOut.error();
// };

class Q7 extends State {
  @override
  call(str) {
    if (_isNumber(str)) {
      return (Q8(), null);
    }
    final op = OperationTokens.check(str);
    if ([OperationTokens.plus, OperationTokens.minus].contains(op)) {
      return (Q7(), null);
    }
    return (ErrorState(), null);
  }
}

// State q7 = (str) {
//   if (_isNumber(str)) {
//     return StateOut(q8);
//   }

//   return StateOut.error();
// };

class Q8 extends State {
  @override
  call(str) {
    if (_isNumber(str)) {
      return (Q8(), null);
    }

    if (_isDivider(str) || _isOperation(str)) {
      return (S(), SemanticProcedure.p3);
    }

    return (ErrorState(), null);
  }
}

// State q8 = (str) {
//   if (_isNumber(str)) {
//     return StateOut(q8);
//   }

//   if (_isDivider(str) || _isOperation(str)) {
//     return StateOut(s, SemanticProcedures.p3);
//   }

//   return StateOut.error();
// };

class Q9 extends State {
  @override
  call(str) {
    final div = DividerTokens.check(str);
    if (div != DividerTokens.quotes) return (Q9(), null);
    if (div == DividerTokens.quotes) return (S(), SemanticProcedure.p4);
    return (ErrorState(), null);
  }
}

// State q9 = (str) {
//   final div = DividerTokens.check(str);
//   if (div != DividerTokens.quotes) return StateOut(q9);
//   if (div == DividerTokens.quotes) return StateOut(s, SemanticProcedures.p4);

//   return StateOut.error();
// };

class Q10 extends State {
  @override
  call(str) {
    final div = DividerTokens.check(str);
    if ([DividerTokens.slash, DividerTokens.star].contains(div)) {
      return (Q11(), null);
    }
    return (ErrorState(), null);
  }
}

// State q10 = (str) {
//   final div = DividerTokens.check(str);
//   if ([DividerTokens.slash, DividerTokens.star].contains(div)) {
//     return StateOut(q11);
//   }

//   return StateOut.error();
// };

class Q11 extends State {
  @override
  call(str) {
    final div = DividerTokens.check(str);
    if (div == DividerTokens.star) {
      return (Q12(), null);
    }
    if (State._isLastSymbol) {
      return (Z(), null);
    }
    if (!DividerTokens.isNewLine(div)) {
      return (Q11(), null);
    }
    return (ErrorState(), null);
  }
}

// State q11 = (str) {
//   final div = DividerTokens.check(str);
//   if (div == DividerTokens.star) {
//     return StateOut(q12);
//   }
//   if (_isLastSymbol) {
//     return StateOut(z);
//   }
//   if (!DividerTokens.isNewLine(div)) {
//     return StateOut(q11);
//   }

//   return StateOut(s);
// };

class Q12 extends State {
  @override
  call(str) {
    final div = DividerTokens.check(str);
    if (div == DividerTokens.slash) return (S(), null);
    return (Q11(), null);
  }
}

// State q12 = (str) {
//   final div = DividerTokens.check(str);
//   if (div == DividerTokens.slash) {
//     return StateOut(s);
//   }

//   return StateOut(q11);
// };

// State z = (str) {
//   return StateOut(null);
// };

class Z extends State {
  @override
  call(str) => (null, null);
}

class ErrorState extends State {
  @override
  call(str) {
    logger.log(Log.error, message: 'Error State');
    return (null, null);
  }
}
