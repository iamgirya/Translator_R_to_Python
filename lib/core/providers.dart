import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../lexical_anallyzer/lexical_analyzer.dart';
import '../lexical_anallyzer/models/lexical_analyzer_output.dart';

final inputProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController(text: kSample1JaveCode);
});

final outputProvider = StateProvider<TextEditingController>((ref) {
  return TextEditingController();
});

final tokenOutputProveder = StateProvider<LexicalAnalyzerOutput?>((ref) {
  return null;
});
