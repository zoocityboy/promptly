import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/string_buffer.dart';

class Message extends TypeComponent<String> {
  Message({
    required this.text,
    this.prefix,
    this.style = MessageStyle.text,
    Context? context,
  })  : theme = Theme.defaultTheme,
        _context = context ?? Context();

  Message.withTheme({
    required this.theme,
    required this.text,
    this.prefix,
    this.style = MessageStyle.text,
    Context? context,
  }) : _context = context ?? Context();

  final String text;
  final String? prefix;
  final MessageStyle style;
  final Theme theme;
  final Context _context;

  String get _formatted {
    final messageTheme = switch (style) {
      MessageStyle.verbose => VerboseMessageTheme.withTheme(theme),
      MessageStyle.text => TextMessageTheme.withTheme(theme),
      MessageStyle.info => InfoMessageTheme.withTheme(theme),
      MessageStyle.warning => WarningMessageTheme.withTheme(theme),
      MessageStyle.error => ErrorMessageTheme.withTheme(theme),
      MessageStyle.success => SuccessMessageTheme.withTheme(theme),
    };
    final buffer = StringBuffer();
    buffer.write(messageTheme.prefixStyle((prefix ?? messageTheme.prefix).removeAnsi().padRight(theme.spacing)));
    buffer.write(messageTheme.messageStyle(text));
    buffer.write('\n');
    return buffer.toString();
  }

  @override
  void render({Context? context}) {
    (context ?? _context).write(_formatted);
  }

  @override
  String interact() => _formatted;
}

enum MessageStyle {
  text,
  verbose,
  info,
  warning,
  success,
  error,
}

sealed class MessageTheme {
  const MessageTheme({
    required this.prefix,
    required this.prefixStyle,
    required this.messageStyle,
  });
  final String prefix;
  final StyleFunction messageStyle;
  final StyleFunction prefixStyle;
}

class VerboseMessageTheme extends MessageTheme {
  factory VerboseMessageTheme.fromDefault() => VerboseMessageTheme.withTheme(Theme.defaultTheme);
  VerboseMessageTheme.withTheme(Theme theme)
      : super(
          prefix: theme.symbols.vLine,
          prefixStyle: theme.colors.prefix,
          messageStyle: theme.colors.hint,
        );
}

class TextMessageTheme extends MessageTheme {
  factory TextMessageTheme.fromDefault() => TextMessageTheme.withTheme(Theme.defaultTheme);
  TextMessageTheme.withTheme(Theme theme)
      : super(
          prefix: theme.symbols.vLine,
          prefixStyle: theme.colors.prefix,
          messageStyle: theme.colors.text,
        );
}

class InfoMessageTheme extends MessageTheme {
  factory InfoMessageTheme.fromDefault() => InfoMessageTheme.withTheme(Theme.defaultTheme);
  InfoMessageTheme.withTheme(Theme theme)
      : super(
          prefix: theme.symbols.warningStep,
          prefixStyle: theme.colors.prefix,
          messageStyle: theme.colors.info,
        );
}

class WarningMessageTheme extends MessageTheme {
  factory WarningMessageTheme.fromDefault() => WarningMessageTheme.withTheme(Theme.defaultTheme);
  WarningMessageTheme.withTheme(Theme theme)
      : super(
          prefix: theme.symbols.warningStep,
          prefixStyle: theme.colors.prefix,
          messageStyle: theme.colors.warning,
        );
}

class ErrorMessageTheme extends MessageTheme {
  factory ErrorMessageTheme.fromDefault() => ErrorMessageTheme.withTheme(Theme.defaultTheme);
  ErrorMessageTheme.withTheme(Theme theme)
      : super(
          prefix: theme.symbols.errorStep,
          prefixStyle: theme.colors.prefix,
          messageStyle: theme.colors.error,
        );
}

class SuccessMessageTheme extends MessageTheme {
  factory SuccessMessageTheme.fromDefault() => SuccessMessageTheme.withTheme(Theme.defaultTheme);
  SuccessMessageTheme.withTheme(Theme theme)
      : super(
          prefix: '✔',
          prefixStyle: theme.colors.success,
          messageStyle: theme.colors.success,
        );
}
