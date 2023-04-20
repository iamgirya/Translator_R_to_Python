final class AnotherLanguageGeneratorOutput {
  final List<String> rezult;

  // create consctructor
  AnotherLanguageGeneratorOutput({
    required this.rezult,
  });

  AnotherLanguageGeneratorOutput.empty() : rezult = [];

  String convertToText() {
    return rezult.fold(
      '',
      (previousValue, element) => '$previousValue $element',
    );
  }
}
