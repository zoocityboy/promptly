part of 'validator.dart';
/// A validator for semantic version strings (e.g., "1.0.0").
///
/// This validator checks if a given string matches the semantic versioning
/// pattern (major.minor.patch).
///
/// Example:
/// ```dart
/// final validator = VersionValidator();
/// validator.call('1.0.0'); // Valid
/// validator.call('1.0'); // Throws ValidationError
/// ```
///
/// Throws:
/// - [ValidationError] if the string does not match the semantic versioning pattern.

class VersionValidator extends Validator<String> {
  VersionValidator()
      : super('Invalid semantic version', pattern: RegExp(r'^\d+\.\d+\.\d+$'));
  @override
  void call(String value) {
    if (!pattern!.hasMatch(value)) {
      throw ValidationError(message);
    }
  }
}
