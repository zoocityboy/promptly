/// The error message to be thrown from the [Prompt] component's
/// validator when there is an error.
class ValidationError {
  /// Constructs a [ValidationError] with given message.
  ValidationError(this.message);

  /// The error message.
  final String message;
}

abstract class Validator<T> {
  Validator(this.message, {this.pattern});
  final String message;
  RegExp? pattern;

  /// Validates the input [value].
  void call(T value);
}

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
  CustomStringValidator(String message, this.validator) : super('');
  final bool Function(String value) validator;
  @override
  void call(String value) {
    if (!validator(value)) {
      throw ValidationError(message);
    }
  }
}

/// A generic validator that takes a function to validate the input.
class GenericValidator<T> extends Validator<T> {
  GenericValidator(String message, this.validator) : super(message);
  final bool Function(T value) validator;
  @override
  void call(T value) {
    if (!validator(value)) {
      throw ValidationError(message);
    }
  }
}
