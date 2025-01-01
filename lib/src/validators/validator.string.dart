part of 'validator.dart';

class EmailValidator extends Validator<String> {
  EmailValidator() : super('Invalid email address format.', pattern: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'));
  @override
  bool call(String value) {
    if (pattern == null) {
      throw ValidationError('Pattern is not set.');
    }
    if (!pattern!.hasMatch(value)) {
      throw ValidationError(message);
    }
    return true;
  }
}

class IsNotEmptyValidator extends Validator<String> {
  IsNotEmptyValidator() : super('Value cannot be empty');
  @override
  void call(String value) {
    if (value.isEmpty) {
      throw ValidationError(message);
    }
  }
}

class CustomStringValidator extends Validator<String> {
  CustomStringValidator(super.message, this.validator);
  final bool Function(String value) validator;
  @override
  void call(String value) {
    if (!validator(value)) {
      throw ValidationError(message);
    }
  }
}
