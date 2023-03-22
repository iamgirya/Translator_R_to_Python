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

class Q4 extends State {
  @override
  call(str) {
    if (_isNumber(str)) return (Q5(), null);

    return (ErrorState(), null);
  }
}

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

class Q9 extends State {
  @override
  call(str) {
    final div = DividerTokens.check(str);
    if (div != DividerTokens.quotes) return (Q9(), null);
    if (div == DividerTokens.quotes) return (S(), SemanticProcedure.p4);
    return (ErrorState(), null);
  }
}

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

class Q12 extends State {
  @override
  call(str) {
    final div = DividerTokens.check(str);
    if (div == DividerTokens.slash) return (S(), null);
    return (Q11(), null);
  }
}

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
