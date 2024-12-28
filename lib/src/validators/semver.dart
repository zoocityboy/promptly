import 'package:zoo_console/src/validators/validator.dart';

class SemverValidator implements Validator<String> {
  @override
  bool call(String value) {
    return isValid(value);
  }

  @override
  RegExp? get pattern => null;
}
