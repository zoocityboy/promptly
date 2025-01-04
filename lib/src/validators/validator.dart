part 'validator.semver.dart';
part 'validator.string.dart';

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

/// A generic validator that takes a function to validate the input.
class GenericValidator<T> extends Validator<T> {
  GenericValidator(super.message, this.validator);
  final bool Function(T value) validator;
  @override
  void call(T value) {
    if (!validator(value)) {
      throw ValidationError(message);
    }
  }
}
