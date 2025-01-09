import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';

class ErrorMessage extends TypeComponent<String> {
  ErrorMessage({
    required this.message,
    Context? context,
  })  : _context = context ?? Context(),
        _theme = Theme.defaultTheme;

  ErrorMessage.withTheme({
    required Theme theme,
    required this.message,
    Context? context,
  })  : _theme = theme,
        _context = context ?? Context();

  final String message;
  final Context _context;
  final Theme _theme;

  String get _formatted {
    final buffer = StringBuffer();
    buffer
      ..write(_theme.promptTheme.errorStyle(_theme.promptTheme.errorPrefix.padRight(_theme.spacing)))
      ..write(_theme.promptTheme.errorStyle(message))
      ..write('\n');

    return buffer.toString();
  }

  @override
  void render({Context? context}) {
    (context ?? _context).write(_formatted);
  }

  @override
  String interact() => _formatted;
}
