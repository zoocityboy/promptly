import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';

/// A component that displays an error message with a specific theme.
///
/// The [ErrorMessage] class extends [TypeComponent] with a type of [String].
/// It provides two constructors: one for using the default theme and another
/// for specifying a custom theme.
///
/// The [message] parameter is required and represents the error message to be displayed.
/// The [context] parameter is optional and represents the context in which the error message
/// will be rendered. If not provided, a default [Context] will be used.
///
/// The [ErrorMessage.withTheme] constructor allows specifying a custom [theme] along with
/// the required [message] and optional [context].
///
/// The [_formatted] getter returns the formatted error message as a [String].
///
/// The [render] method writes the formatted error message to the provided [context] or
/// the default context if none is provided.
///
/// The [interact] method returns the formatted error message as a [String].
///
/// Example usage:
/// ```dart
/// final errorMessage = ErrorMessage(message: 'An error occurred');
/// errorMessage.render();
///
/// final themedErrorMessage = ErrorMessage.withTheme(
///   theme: customTheme,
///   message: 'A themed error occurred',
/// );
/// themedErrorMessage.render();
/// ```
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
      ..write(
        _theme.promptTheme.errorStyle(
          _theme.promptTheme.errorPrefix.padRight(_theme.spacing),
        ),
      )
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
