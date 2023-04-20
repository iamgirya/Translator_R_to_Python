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
  bracket,
  ifCondition,
  ifThen,
  ifElse;
}

extension Metods on StructType {
  String getName() {
    switch (this) {
      case StructType.bracket:
        return '(';
      case StructType.ifThen:
      case StructType.ifElse:
        return 'M:';
      default:
        return toString().split('.').last;
    }
  }

  String getMark() {
    switch (this) {
      case StructType.bracket:
        return '(';
      case StructType.F:
        return 'F';
      case StructType.AEM:
        return 'AEM';
      case StructType.ifCondition:
        return 'if';
      case StructType.ifElse:
        return 'else';
      case StructType.ifThen:
        return '{';
    }
  }

  String getStartName() {
    switch (this) {
      case StructType.bracket:
      case StructType.F:
        return '(';
      case StructType.AEM:
        return '[';
      case StructType.ifCondition:
        return 'if';
      case StructType.ifElse:
        return 'else';
      case StructType.ifThen:
        return '{';
    }
  }

  String getEndName() {
    switch (this) {
      case StructType.bracket:
      case StructType.F:
      case StructType.ifCondition:
        return ')';
      case StructType.AEM:
        return ']';
      case StructType.ifElse:
      case StructType.ifThen:
        return '}';
    }
  }
}

class InfoString {
  StructType token;
  int info;

  InfoString(this.token, this.info);
}
