import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';

class Message extends Component<String> {
  Message({
    required String message,
    String? prefix,
    MessageStyle? style,
  })  : _message = message,
        _prefix = prefix,
        _style = style ?? MessageStyle.info,
        theme = Theme.defaultTheme;
  Message.withTheme({
    required String message,
    String? prefix,
    MessageStyle? style,
    required this.theme,
  })  : _message = message,
        _prefix = prefix,
        _style = style ?? MessageStyle.info;

  final String _message;
  final String? _prefix;
  final MessageStyle _style;
  final Theme theme;

  @override
  _MessageState createState() => _MessageState();
}

class _MessageState extends State<Message> {
  String value = '';
  String process(String message, String? prefix) {
    final messageTheme = switch (component._style) {
      MessageStyle.verbose => VerboseMessageTheme.withTheme(component.theme),
      MessageStyle.info => InfoMessageTheme.withTheme(component.theme),
      MessageStyle.warning => WarningMessageTheme.withTheme(component.theme),
      MessageStyle.error => ErrorMessageTheme.withTheme(component.theme),
      MessageStyle.success => SuccessMessageTheme.withTheme(component.theme),
    };
    final StringBuffer buffer = StringBuffer();
    final prefixValue = prefix ?? messageTheme.prefix;
    final lines = message.split('\n');
    for (final line in lines) {
      buffer.write(
        '${messageTheme.messageStyle(prefixValue.padRight(component.theme.spacing))}${messageTheme.messageStyle(line)}',
      );
      if (line != lines.last) {
        buffer.write('\n');
      }
    }
    return buffer.toString();
  }

  @override
  String interact() {
    final val = process(
      component._message,
      component._prefix,
    );
    setState(() {
      value = val;
    });
    return value;
  }

  @override
  void dispose() {
    value = process(
      component._message,
      component._prefix,
    );
    context.writeln(value);
    super.dispose();
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

class InfoMessageTheme extends MessageTheme {
  factory InfoMessageTheme.fromDefault() => InfoMessageTheme.withTheme(Theme.defaultTheme);
  InfoMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.infoStep,
          theme.colors.info,
          theme.colors.info,
        );
}

class WarningMessageTheme extends MessageTheme {
  factory WarningMessageTheme.fromDefault() => WarningMessageTheme.withTheme(Theme.defaultTheme);
  WarningMessageTheme.withTheme(Theme theme)
      : super(
          theme.symbols.warningStep,
          theme.colors.warning,
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
          theme.symbols.successStep,
          theme.colors.success,
          theme.colors.success,
        );
}
