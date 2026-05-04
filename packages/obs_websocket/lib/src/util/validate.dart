import 'package:validators/validators.dart' as val;

class Validate {
  static bool isNull(String? value) => val.isNull(value);

  static bool isNotNull(String? value) => !val.isNull(value);

  static bool isInt(String? value) => isNotNull(value) && val.isInt(value!);

  static bool isGreaterOrEqual(String? value, [int lowerBound = 0]) =>
      isInt(value) && int.parse(value!) >= lowerBound;

  static bool isLessOrEqual(String? value, [int upperBound = 0]) =>
      isInt(value) && int.parse(value!) <= upperBound;

  static bool isInRange(String? value, {int start = 0, required int end}) =>
      isGreaterOrEqual(value, start) && isLessOrEqual(value, end);
}
