import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';

class Message extends TypeComponent<String> {
  final Context _context = Context();
  Message({
    required this.text,
    this.style = MessageStyle.text,
    required this.theme,
  });

  final String text;
  final MessageStyle style;
  final Theme theme;

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
    buffer.write(messageTheme.prefix.padRight(theme.spacing));
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
  const MessageTheme(
    this.prefix,
    this.prefixStyle,
    this.messageStyle,
  );
  final String prefix;
  final StyleFunction messageStyle;
  final StyleFunction prefixStyle;
}

class VerboseMessageTheme extends MessageTheme {
  factory VerboseMessageTheme.fromDefault() => VerboseMessageTheme.withTheme(Theme.defaultTheme);
  VerboseMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.vLine,
          theme.colors.hint,
          theme.colors.prefix,
        );
}

class TextMessageTheme extends MessageTheme {
  factory TextMessageTheme.fromDefault() => TextMessageTheme.withTheme(Theme.defaultTheme);
  TextMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.vLine,
          theme.colors.text,
          theme.colors.prefix,
        );
}

class InfoMessageTheme extends MessageTheme {
  factory InfoMessageTheme.fromDefault() => InfoMessageTheme.withTheme(Theme.defaultTheme);
  InfoMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.warningStep,
          theme.colors.prefix,
          theme.colors.info,
        );
}

class WarningMessageTheme extends MessageTheme {
  factory WarningMessageTheme.fromDefault() => WarningMessageTheme.withTheme(Theme.defaultTheme);
  WarningMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.warningStep,
          theme.colors.prefix,
          theme.colors.warning,
        );
}

class ErrorMessageTheme extends MessageTheme {
  factory ErrorMessageTheme.fromDefault() => ErrorMessageTheme.withTheme(Theme.defaultTheme);
  ErrorMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.errorStep,
          theme.colors.error,
          theme.colors.error,
        );
}

class SuccessMessageTheme extends MessageTheme {
  factory SuccessMessageTheme.fromDefault() => SuccessMessageTheme.withTheme(Theme.defaultTheme);
  SuccessMessageTheme.withTheme(Theme theme)
      : super(
          '✔',
          theme.colors.success,
          theme.colors.success,
        );
}
