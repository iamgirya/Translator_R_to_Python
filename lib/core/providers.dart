import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../another_language_generator/another_language_model.dart';
import '../lexical_anallyzer/lexical_analyzer.dart';
import '../lexical_anallyzer/models/lexical_analyzer_output.dart';
import '../reverse_polish_entry/polish_models.dart';

final inputProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController(text: kSample1JaveCode);
});

final outputProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

final tokenOutputProvider = StateProvider<LexicalAnalyzerOutput>((ref) {
  return LexicalAnalyzerOutput.empty();
});

final polishProvider = StateProvider<ReversePolishEntryOutput>((ref) {
  return ReversePolishEntryOutput.empty();
});

final anotherLanguageProvider =
    StateProvider<AnotherLanguageGeneratorOutput>((ref) {
  return AnotherLanguageGeneratorOutput.empty();
});
