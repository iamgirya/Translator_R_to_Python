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
  ifElse,
  whileCondition,
  whileThen;
}

extension Metods on StructType {
  String getName() {
    switch (this) {
      case StructType.bracket:
        return '(';
      case StructType.ifThen:
      case StructType.ifElse:
        return 'M:';
      case StructType.whileThen:
        return 'M:';
      default:
        return toString().split('.').last;
    }
  }

  void writeToRezult(List<String> rezult, int info, String stack) {
    if (this == StructType.whileThen) {
      rezult.add('${info - 1}M BP ${info}M:');
    } else if (info != -1) {
      rezult.add(info.toString() + stack);
    }
  }

  // String getMark() {
  //   switch (this) {
  //     case StructType.bracket:
  //       return '(';
  //     case StructType.F:
  //       return 'F';
  //     case StructType.AEM:
  //       return 'AEM';
  //     case StructType.ifCondition:
  //       return 'if';
  //     case StructType.whileCondition:
  //       return 'if';
  //     case StructType.ifElse:
  //       return 'else';
  //     case StructType.ifThen:
  //       return '{';
  //   }
  // }

  String getStartName() {
    switch (this) {
      case StructType.bracket:
      case StructType.F:
        return '(';
      case StructType.AEM:
        return '[';
      case StructType.ifCondition:
        return 'if';
      case StructType.whileCondition:
        return 'while';
      case StructType.whileThen:
        return '{';
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
      case StructType.whileCondition:
        return ')';
      case StructType.AEM:
        return ']';
      case StructType.ifElse:
      case StructType.ifThen:
      case StructType.whileThen:
        return '}';
    }
  }
}

class InfoString {
  StructType token;
  int info;

  InfoString(this.token, this.info);
}
