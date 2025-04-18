part of 'validator.dart';

/// A validator class for validating email addresses.
///
/// This class extends the `Validator<String>` class and provides
/// functionality to validate email addresses using a regular expression pattern.
///
/// The default error message is 'Invalid email address format.' and the
/// regular expression pattern used for validation is:
/// `^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$`.
///
/// Throws a `ValidationError` if the pattern is not set or if the value
/// does not match the pattern.

class EmailValidator extends Validator<String> {
  EmailValidator()
      : super(
          'Invalid email address format.',
          pattern: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'),
        );
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

/// A validator that checks if a given string is not empty.
///
/// This validator extends the [Validator] class and overrides the
/// `call` method to throw a [ValidationError] if the provided string
/// is empty.
///
/// Example usage:
///
/// ```dart
/// final validator = IsNotEmptyValidator();
/// try {
///   validator('');
/// } catch (e) {
///   print(e); // Output: ValidationError: Value cannot be empty
/// }
/// ```
///
/// Throws a [ValidationError] with the message 'Value cannot be empty'
/// if the provided string is empty.
class IsNotEmptyValidator extends Validator<String> {
  IsNotEmptyValidator() : super('Value cannot be empty');
  @override
  void call(String value) {
    if (value.isEmpty) {
      throw ValidationError(message);
    }
  }
}

/// A validator that checks if a given string value is within a list of allowed values.
///
/// This validator can be configured to be case-sensitive or case-insensitive.
///
/// Example usage:
/// ```dart
/// final validator = AllowedValidator(['apple', 'banana', 'cherry']);
/// validator.call('apple'); // Passes validation
/// validator.call('orange'); // Throws ValidationError
/// ```
///
/// The error message for a failed validation will include the list of allowed values.
///
/// - `allowed`: A list of allowed string values.
/// - `caseSensitive`: A boolean indicating whether the validation should be case-sensitive (default is true).
///
/// Throws a [ValidationError] if the value is not in the list of allowed values.
class AllowedValidator extends Validator<String> {
  AllowedValidator(this.allowed, {this.caseSensitive = true}) : super('Value is not allowed');
  final List<String> allowed;
  bool caseSensitive;
  @override
  void call(String value) {
    if (!allowed.contains(value)) {
      throw ValidationError('Allowed values are: ${allowed.join(', ')}');
    }
  }
}

/// A custom string validator that extends the [Validator] class.
///
/// This validator takes a validation function and a message. The validation
/// function is used to determine if the given string value is valid. If the
/// value is not valid, a [ValidationError] is thrown with the provided message.
///
/// Example usage:
///
/// ```dart
/// final validator = CustomStringValidator('Invalid input', (value) => value.isNotEmpty);
/// validator.call(''); // Throws ValidationError with message 'Invalid input'
/// ```
///
/// - `message`: The error message to be used when validation fails.
/// - `validator`: A function that takes a string value and returns a boolean indicating whether the value is valid.
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
