import 'package:promptly/src/theme/theme.dart';

class Message {
  Message({
    required this.message,
    String? prefix,
    MessageStyle? style,
  })  : prefix = prefix ?? '',
        style = style ?? MessageStyle.info,
        theme = Theme.defaultTheme;
  Message.withTheme({
    required this.message,
    String? prefix,
    MessageStyle? style,
    required this.theme,
  })  : prefix = prefix ?? '',
        style = style ?? MessageStyle.info;

  final String message;
  final String prefix;
  final MessageStyle style;
  final Theme theme;

  String interect() {
    final messageTheme = switch (style) {
      MessageStyle.verbose => VerboseMessageTheme.withTheme(theme),
      MessageStyle.info => InfoMessageTheme.withTheme(theme),
      MessageStyle.warning => WarningMessageTheme.withTheme(theme),
      MessageStyle.error => ErrorMessageTheme.withTheme(theme),
      MessageStyle.success => SuccessMessageTheme.withTheme(theme),
    };

    return '${messageTheme.messageStyle(messageTheme.prefix.padRight(theme.spacing))}${messageTheme.messageStyle(message)}';
  }
}

enum MessageStyle {
  verbose,
  info,
  warning,
  success,
  error,
}

sealed class MessageTheme {
  const MessageTheme(
    this.prefix,
    this.messageStyle,
  );
  final String prefix;
  final StyleFunction messageStyle;
}

class VerboseMessageTheme extends MessageTheme {
  factory VerboseMessageTheme.fromDefault() => VerboseMessageTheme.withTheme(Theme.defaultTheme);
  VerboseMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.hLine,
          theme.colors.hint,
        );
}

class InfoMessageTheme extends MessageTheme {
  factory InfoMessageTheme.fromDefault() => InfoMessageTheme.withTheme(Theme.defaultTheme);
  InfoMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.warningStep,
          theme.colors.info,
        );
}

class WarningMessageTheme extends MessageTheme {
  factory WarningMessageTheme.fromDefault() => WarningMessageTheme.withTheme(Theme.defaultTheme);
  WarningMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.warningStep,
          theme.colors.warning,
        );
}

class ErrorMessageTheme extends MessageTheme {
  factory ErrorMessageTheme.fromDefault() => ErrorMessageTheme.withTheme(Theme.defaultTheme);
  ErrorMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.errorStep,
          theme.colors.error,
        );
}

class SuccessMessageTheme extends MessageTheme {
  factory SuccessMessageTheme.fromDefault() => SuccessMessageTheme.withTheme(Theme.defaultTheme);
  SuccessMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.successStep,
          theme.colors.success,
        );
}
