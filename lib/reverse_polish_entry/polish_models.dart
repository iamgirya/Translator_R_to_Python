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
    if (this == StructType.bracket) {
      return '(';
    }
    return toString().split('.').last;
  }

  String getStartName() {
    switch (this) {
      case StructType.bracket:
      case StructType.F:
        return '(';
      case StructType.AEM:
        return '[';
    }
  }

  String getEndName() {
    switch (this) {
      case StructType.bracket:
      case StructType.F:
        return ')';
      case StructType.AEM:
        return ']';
    }
  }
}

class InfoString {
  StructType token;
  int info;

  InfoString(this.token, this.info);
}
