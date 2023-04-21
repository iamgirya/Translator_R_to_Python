class SyntaxisAnalyzerOutput {
  bool isOk;
  String? errorName;
  String message;

  SyntaxisAnalyzerOutput({
    required this.isOk,
    required this.message,
    this.errorName,
  });
}
