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
  buffer.withPrefix(theme.promptTheme.promptPrefix, theme.promptTheme.messageStyle(message), theme.spacing);

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
    theme.spacing,
  );
  buffer.write('\n');
  for (final part in parts) {
    buffer.write(' '.padLeft(theme.spacing));
    // buffer.write(theme.promptTheme.successSuffix);
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
}) {
  final buffer = StringBuffer();
  buffer.withPrefix(theme.promptTheme.errorPrefix, theme.promptTheme.errorStyle(message), theme.spacing);
  return buffer.toString();
}

String promptMessage(
  String message, {
  required Theme theme,
  MessageStyle style = MessageStyle.info,
}) =>
    Message(text: message, style: style, theme: theme).toString();

String promptHeader(
  String title, {
  String? message,
  String? prefix,
  required Theme theme,
  required int windowWidth,
}) {
  final titleBuffer = StringBuffer(theme.prefixHeaderLine(''))
    ..write(theme.colors.successBlock(' $title '))
    ..write(' ');
  final strippedMessage = titleBuffer.toString().replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), '');
  final currentLng = strippedMessage.length;

  ///
  final buffer = StringBuffer()..write(titleBuffer.toString());
  final maxLength = windowWidth - buffer.length;
  final msg = (message ?? '').replaceAll('\n', '');
  if (msg.length >= maxLength - currentLng) {
    buffer.write('\n');
    final lines = wrapText(msg, length: maxLength - currentLng, hangingIndent: 0).split('\n');
    buffer.writeLine(console.theme.prefixLine(''));
    for (final line in lines) {
      buffer.writeln(console.theme.prefixLine(console.theme.colors.hint(line)));
    }
  } else {
    buffer.write(console.theme.colors.hint(msg));
  }

  buffer
    ..newLine()
    ..write(console.theme.prefixLine(''))
    ..newLine();
  return buffer.toString();
}
