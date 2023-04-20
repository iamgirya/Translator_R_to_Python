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

class Gs {
  static const String AEM = 'fad';
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
  whileThen,
  forCondition,
  forThen;

  const StructType();
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

  void writeToRezult(List<String> rezult, int info) {
    switch (this) {
      case StructType.whileThen:
      case StructType.forThen:
        rezult.add('${info - 1}M BP ${info}M:');
        return;
      default:
        if (info != -1) {
          rezult.add(info.toString() + getName());
        }
        return;
    }
  }

  String getEndName() {
    switch (this) {
      case StructType.bracket:
      case StructType.F:
      case StructType.ifCondition:
      case StructType.whileCondition:
      case StructType.forCondition:
        return ')';
      case StructType.AEM:
        return ']';
      case StructType.ifElse:
      case StructType.ifThen:
      case StructType.whileThen:
      case StructType.forThen:
        return '}';
    }
  }
}

class InfoString {
  StructType token;
  int info;

  static String get mark => 'M';

  void writeToRezult(List<String> rezult) {
    token.writeToRezult(rezult, info);
  }

  InfoString(this.token, this.info);
}
