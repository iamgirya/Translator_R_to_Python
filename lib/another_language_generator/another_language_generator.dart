import '../lexical_anallyzer/models/lexical_analyzer_output.dart';
import '../lexical_anallyzer/tokens/token.dart';
import 'another_language_model.dart';

class AnotherLanguageGenerator {
  List<String> stack = [];
  List<String> rezult = [];

  AnotherLanguageGeneratorOutput execute(LexicalAnalyzerOutput input) {
    return AnotherLanguageGeneratorOutput(rezult: rezult);
  }
}
