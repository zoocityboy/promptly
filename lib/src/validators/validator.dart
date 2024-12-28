abstract class Validator<T> {
  Validator(this.message, {this.pattern});
  final String message;
  RegExp? pattern;

  /// Validates the input [value].
  bool call(T value);
}

class EmailValidator extends Validator<String> {
  EmailValidator() : super('Invalid email address', pattern: RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'));
  @override
  bool call(String value) => pattern!.hasMatch(value);
}
