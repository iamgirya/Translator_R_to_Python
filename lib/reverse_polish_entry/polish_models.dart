final class ReversePolishEntryOutput {
  final List<String> rezult;

  // create consctructor
  ReversePolishEntryOutput({
    required this.rezult,
  });

  String convertToText() {
    return rezult.fold(
      '',
      (previousValue, element) => '$previousValue $element',
    );
  }
}

enum StructType {
  // ignore: constant_identifier_names
  AEM,
  F,
  bracket;
}

extension ParseToString on StructType {
  String getName() {
    return toString().split('.').last;
  }
}

class InfoString {
  StructType token;
  int info;

  InfoString(this.token, this.info);
}
