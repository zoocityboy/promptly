import 'package:version/version.dart';
import 'package:zoo_console/src/validators/validator.dart';

class SemverValidator extends Validator<String> {
  SemverValidator() : super('Invalid semantic version', pattern: RegExp(r'^\d+\.\d+\.\d+$'));
  @override
  bool call(String value) {
    return pattern!.hasMatch(value);
  }
}

class VersionValidator extends Validator<Version> {
  VersionValidator() : super('Invalid version');
  @override
  bool call(Version value) {
    // return pattern!.hasMatch(value);
    return true;
  }
}
