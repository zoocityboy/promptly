import 'package:zoo_console/src/validators/validator.dart';

class SemverValidator extends Validator<String> {
  SemverValidator() : super('Invalid semantic version', pattern: RegExp(r'^\d+\.\d+\.\d+$'));
  @override
  bool call(String value) {
    return pattern!.hasMatch(value);
  }
}
