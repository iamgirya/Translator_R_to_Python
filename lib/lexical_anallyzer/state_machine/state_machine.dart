import '../lexical_analyzer.dart';
import '../../core/logger.dart';
import '../tokens/divider_tokens.dart';
import '../tokens/key_words_tokens.dart';
import '../tokens/operation_tokens.dart';

part 'state.dart';
part 'states.dart';

final class StateMachine {
  State? _currentState = S();

  Stream<(State?, SemanticProcedure?)> executeStream(
    String str,
    bool isLastLine,
  ) async* {
    State._isLastSymbol = isLastLine;
    while (_currentState != null) {
      final out = _currentState!(str);
      yield out;
      _currentState = out.$1;
    }
  }

  (State?, SemanticProcedure?) execute(String symbol, bool isLastSymbol) {
    State._isLastSymbol = isLastSymbol;
    var out = _currentState!(symbol);
    _currentState = out.$1;
    return out;
  }
}
