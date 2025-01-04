import 'package:promptly/promptly.dart';
import 'package:promptly_ansi/theme/theme.dart';

/// Generates a formatted input message to prompt.
String promptInput({
  required Theme theme,
  required String message,
  String? hint,
}) {
  final buffer = StringBuffer();
  buffer.write(theme.promptTheme.promptPrefix.padRight(theme.spacing));
  buffer.write(theme.promptTheme.messageStyle(message));
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
String promptSuccess({
  required Theme theme,
  required String message,
  required String value,
}) {
  final parts = value.split('☃︎ ');
  final buffer = StringBuffer();

  buffer.write(theme.promptTheme.successPrefix.padRight(theme.spacing));
  buffer.writeln(theme.promptTheme.hintStyle(message));

  for (final part in parts) {
    buffer.write(' '.padLeft(theme.spacing));
    buffer.write(theme.colors.success(part));
    if (part != parts.last) buffer.writeln(' '.padLeft(theme.spacing));
  }
  buffer.write('\n');

  return buffer.toString();
}

/// Generates a message to use as an error prompt.
String promptError({
  required Theme theme,
  required String message,
}) {
  final buffer = StringBuffer();

  buffer.write(theme.promptTheme.errorPrefix.padRight(theme.spacing));
  buffer.write(theme.promptTheme.errorStyle(message));

  return buffer.toString();
}

String promptMessage({
  required Theme theme,
  MessageStyle style = MessageStyle.info,
  required String message,
}) {
  final messageTheme = switch (style) {
    MessageStyle.verbose => VerboseMessageTheme.withTheme(theme),
    MessageStyle.info => InfoMessageTheme.withTheme(theme),
    MessageStyle.warning => WarningMessageTheme.withTheme(theme),
    MessageStyle.error => ErrorMessageTheme.withTheme(theme),
    MessageStyle.success => SuccessMessageTheme.withTheme(theme),
  };

  final buffer = StringBuffer();
  buffer.write(messageTheme.prefix.padRight(theme.spacing));
  buffer.write(messageTheme.messageStyle(message));

  return buffer.toString();
}
