// ignore: implementation_imports
import 'package:args/src/utils.dart' show wrapText;
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/string_buffer.dart';

class Message extends TypeComponent<String> {
  Message({required this.text, this.prefix, this.style = MessageStyle.text, Context? context})
      : theme = Theme.defaultTheme,
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
    final lines = wrapText(text, length: 80 - theme.spacing).split('\n');
    for (final line in lines) {
      final hidePrefix = (lines.indexOf(line) > 0 && lines.length > 1);
      final p = hidePrefix ? ' ' : (prefix ?? messageTheme.prefix);

      buffer.write(messageTheme.prefixStyle(p.removeAnsi().padRight(theme.spacing)));
      buffer.write(messageTheme.messageStyle(line));
      buffer.write('\n');
    }
    return buffer.toString();
  }

  @override
  void render({Context? context}) {
    if (style == MessageStyle.error) {
      (context ?? _context).writeError(_formatted);
    } else {
      (context ?? _context).write(_formatted);
    }
  }

  @override
  String interact() => _formatted;
}

/// An enumeration representing different styles of messages that can be displayed.
///
/// The available styles are:
/// - `text`: A plain text message.
/// - `verbose`: A detailed message with additional information.
/// - `info`: An informational message.
/// - `warning`: A warning message indicating a potential issue.
/// - `success`: A message indicating a successful operation.
/// - `error`: A message indicating an error or failure.
enum MessageStyle { text, verbose, info, warning, success, error }

/// A sealed class representing the theme for a message.
///
/// This class contains the common properties for all message themes, such as
/// the prefix, prefix style, and message style.
sealed class MessageTheme {
  /// Creates a [MessageTheme] with the given prefix, prefix style, and message style.
  const MessageTheme({required this.prefix, required this.prefixStyle, required this.messageStyle});

  /// The prefix string to be displayed before the message.
  final String prefix;

  /// The style function for the message text.
  final StyleFunction messageStyle;

  /// The style function for the prefix text.
  final StyleFunction prefixStyle;
}

/// A class representing the verbose message theme.
///
/// This theme uses the default theme's vertical line symbol as the prefix,
/// and applies the prefix and hint styles from the default theme.
class VerboseMessageTheme extends MessageTheme {
  /// Creates a [VerboseMessageTheme] using the default theme.
  factory VerboseMessageTheme.fromDefault() => VerboseMessageTheme.withTheme(Theme.defaultTheme);

  /// Creates a [VerboseMessageTheme] with the given theme.
  VerboseMessageTheme.withTheme(Theme theme)
      : super(prefix: theme.symbols.vLine, prefixStyle: theme.colors.prefix, messageStyle: theme.colors.hint);
}

/// A class representing the text message theme.
///
/// This theme uses the default theme's vertical line symbol as the prefix,
/// and applies the prefix and text styles from the default theme.
class TextMessageTheme extends MessageTheme {
  /// Creates a [TextMessageTheme] using the default theme.
  factory TextMessageTheme.fromDefault() => TextMessageTheme.withTheme(Theme.defaultTheme);

  /// Creates a [TextMessageTheme] with the given theme.
  TextMessageTheme.withTheme(Theme theme)
      : super(prefix: theme.symbols.vLine, prefixStyle: theme.colors.prefix, messageStyle: theme.colors.text);
}

/// A class representing the info message theme.
///
/// This theme uses the default theme's warning step symbol as the prefix,
/// and applies the prefix and info styles from the default theme.
class InfoMessageTheme extends MessageTheme {
  /// Creates an [InfoMessageTheme] using the default theme.
  factory InfoMessageTheme.fromDefault() => InfoMessageTheme.withTheme(Theme.defaultTheme);

  /// Creates an [InfoMessageTheme] with the given theme.
  InfoMessageTheme.withTheme(Theme theme)
      : super(prefix: theme.symbols.dotStep, prefixStyle: theme.colors.prefix, messageStyle: theme.colors.info);
}

/// A class representing the warning message theme.
///
/// This theme uses the default theme's warning step symbol as the prefix,
/// and applies the prefix and warning styles from the default theme.
class WarningMessageTheme extends MessageTheme {
  /// Creates a [WarningMessageTheme] using the default theme.
  factory WarningMessageTheme.fromDefault() => WarningMessageTheme.withTheme(Theme.defaultTheme);

  /// Creates a [WarningMessageTheme] with the given theme.
  WarningMessageTheme.withTheme(Theme theme)
      : super(prefix: theme.symbols.dotStep, prefixStyle: theme.colors.prefix, messageStyle: theme.colors.warning);
}

/// A class representing the error message theme.
///
/// This theme uses the default theme's error step symbol as the prefix,
/// and applies the prefix and error styles from the default theme.
class ErrorMessageTheme extends MessageTheme {
  /// Creates an [ErrorMessageTheme] using the default theme.
  factory ErrorMessageTheme.fromDefault() => ErrorMessageTheme.withTheme(Theme.defaultTheme);

  /// Creates an [ErrorMessageTheme] with the given theme.
  ErrorMessageTheme.withTheme(Theme theme)
      : super(prefix: theme.symbols.error, prefixStyle: theme.colors.error, messageStyle: theme.colors.error);
}

/// A class representing the success message theme.
///
/// This theme uses a check mark symbol as the prefix,
/// and applies the success styles from the given theme.
class SuccessMessageTheme extends MessageTheme {
  /// Creates a [SuccessMessageTheme] using the default theme.
  factory SuccessMessageTheme.fromDefault() => SuccessMessageTheme.withTheme(Theme.defaultTheme);

  /// Creates a [SuccessMessageTheme] with the given theme.
  SuccessMessageTheme.withTheme(Theme theme)
      : super(prefix: '✔', prefixStyle: theme.colors.success, messageStyle: theme.colors.success);
}
