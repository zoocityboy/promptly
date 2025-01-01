part of 'validator.dart';

class VersionValidator extends Validator<String> {
  VersionValidator() : super('Invalid semantic version', pattern: RegExp(r'^\d+\.\d+\.\d+$'));
  @override
  void call(String value) {
    if (!pattern!.hasMatch(value)) {
      throw ValidationError(message);
    }
  }
}
