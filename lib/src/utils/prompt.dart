import 'package:tint/tint.dart';
import 'package:zoo_console/src/theme/theme.dart';

/// Generates a formatted input message to prompt.
String promptInput({
  required Theme theme,
  required String message,
  String? hint,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.inputPrefix);
  buffer.write(theme.messageStyle(message));
  if (hint != null) {
    buffer.write(' ');
    buffer.write(theme.hintStyle(hint));
  }
  buffer.write(theme.inputSuffix);
  buffer.write(' ');

  return buffer.toString();
}

/// Generates a success prompt, a message to indicates
/// the interaction is successfully finished.
String promptSuccess({
  required Theme theme,
  required String message,
  required String value,
  int spacing = 3,
}) {
  final parts = value.split('☃︎ ');
  final buffer = StringBuffer();

  buffer.write(theme.successPrefix);
  buffer.writeln(message.gray());

  for (final part in parts) {
    // buffer.write(' '.padLeft(spacing) + theme.messageStyle(theme.successSuffix));
    buffer.write(' '.padLeft(spacing));
    buffer.write(theme.valueStyle(part));
    if (part != parts.last) buffer.writeln(' '.padLeft(spacing));
  }
  buffer.write('\n');

  return buffer.toString();
}

/// Generates a message to use as an error prompt.
String promptError({
  required Theme theme,
  required String message,
  int spacing = 3,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.errorPrefix);
  buffer.write(theme.errorStyle(message));

  return buffer.toString();
}
