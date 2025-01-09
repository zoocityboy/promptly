import 'package:promptly/promptly.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/string_buffer.dart';

/// Generates a formatted input message to prompt.
String promptInput({
  required Theme theme,
  required String message,
  String? hint,
}) {
  final buffer = StringBuffer();
  buffer.withPrefix(
    theme.promptTheme.promptPrefix,
    theme.promptTheme.messageStyle(message),
  );

  if (hint != null) {
    buffer.write(' ');
    buffer.write(theme.promptTheme.hintStyle(hint));
  }
  buffer.write(theme.promptTheme.promptSuffix);
  buffer.write(' ');

  return buffer.toString();
}

/// Generates a success prompt, a message to indicates
/// the interaction is successfully finished.
String promptSuccess(
  String message, {
  required Theme theme,
  required String value,
}) {
  final parts = value.removeAnsi().split('☃︎ ');
  final buffer = StringBuffer();
  buffer.withPrefix(
    theme.promptTheme.successPrefix,
    theme.promptTheme.hintStyle(message.removeAnsi()),
  );
  buffer.write('\n');
  for (final part in parts) {
    buffer.write(' '.padLeft(theme.spacing));

    buffer.write(theme.colors.success(part));
    if (part != parts.last) buffer.writeln(' '.padLeft(theme.spacing));
  }
  buffer.write('\n');

  return buffer.toString();
}

/// Generates a message to use as an error prompt.
String promptError(
  String message, {
  required Theme theme,
}) =>
    Message.withTheme(text: message, style: MessageStyle.error, theme: theme)
        .interact();

String promptMessage(
  String message, {
  required Theme theme,
  MessageStyle style = MessageStyle.info,
}) =>
    Message.withTheme(text: message, style: style, theme: theme).interact();
