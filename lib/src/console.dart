import 'package:zoo_console/src/components/confirm.dart';
import 'package:zoo_console/src/components/input.dart';
import 'package:zoo_console/src/components/multi_select.dart';
import 'package:zoo_console/src/components/password.dart';
import 'package:zoo_console/src/components/select.dart';
import 'package:zoo_console/src/components/spinner.dart';
import 'package:zoo_console/src/framework/framework.dart';
import 'package:zoo_console/src/theme/theme.dart';
import 'package:zoo_console/zoo_console.dart';

class ZooConsole {
  static final ZooConsole _instance = ZooConsole._internal();

  /// Access to singleton instance
  static ZooConsole get instance => _instance;

  factory ZooConsole({Theme? theme}) {
    if (theme != null) {
      _instance._theme = theme;
    }
    return _instance;
  }

  ZooConsole._internal()
      : _ctx = Context(),
        _theme = Theme.zooTheme;

  late Theme _theme;
  final Context _ctx;

  /// Gets the spacing value from the current theme.
  ///
  /// This value is used to determine the spacing between elements
  /// in the console output.
  int get spacing => _theme.spacing;

  /// Gets the current theme.
  ///
  /// Returns the current [Theme] object.
  Theme get theme => _theme;

  /// Returns a styled vertical line prefix with padding and gray color.
  String get prefixVerticalStyled => theme.linePrefixStyle('│');

  /// Returns a styled start line prefix with padding and gray color.
  String get prefixStartStyled => theme.linePrefixStyle('┌');

  /// Returns a styled end line prefix with padding and gray color.
  String get prefixEndStyled => theme.linePrefixStyle('└');

  /// Returns a styled diamond prefix with padding and green color.
  String get prefixDiamondStyled => '◇'.padRight(spacing).green();

  /// Returns a styled usage prefix with padding and green color.
  String get prefixUsageStyled => '◇'.padRight(spacing).green();

  /// Returns a styled error prefix with padding and red color.
  String get prefixErrorStyled => theme.errorStyle('■').padRight(spacing);

  /// Returns a styled trace start prefix with padding and cyan color.
  String get prefixTraceStartStyled => '•'.padRight(spacing).white();

  /// Returns a styled trace item prefix with padding, cyan color, and dim effect.
  String get prefixTraceItemStyled => '▹'.padRight(spacing).cyan().dim();

  /// Returns a styled T-shaped prefix with padding and gray color.
  String get prefixTStyled => '├'.padRight(spacing).darkGray();

  /// Writes a message to the console.
  ///
  /// This method takes a [message] as a string and writes it to the console
  /// using the underlying context's write method.
  ///
  /// Example:
  /// ```dart
  /// write('Hello, World!');
  /// ```
  ///
  /// - Parameter message: The message to be written to the console.
  void write(String message) => _ctx.write(message);

  /// Writes a message to the console followed by a newline.
  ///
  /// This method delegates the writing operation to the underlying context.
  ///
  /// @param message The message to be written to the console.
  void writeln(String message) => _ctx.writeln(message);

  /// Logs an informational message to the console.
  ///
  /// The [message] parameter is the message to be logged. If [message] is null,
  /// no message will be logged.
  ///
  /// Example:
  /// ```dart
  /// info('This is an informational message.');
  /// ```
  void info(String? message) {
    if (message == null) return;
    final sb = StringBuffer();
    final lines = message.split('\n');
    for (final line in lines) {
      if (lines.indexOf(line) == 0) {
        sb.write(prefixDiamondStyled);
        sb.write(line.gray());
      } else {
        sb.write(prefixVerticalStyled);
        sb.write(line.grey());
      }
      sb.write('\n');
    }
    _ctx.write(sb.toString());
  }

  /// Logs an error message to the console.
  void error(String message) {
    final sb = StringBuffer();
    final lines = message.split('\n');
    for (final line in lines) {
      if (lines.indexOf(line) == 0) {
        sb.write(prefixErrorStyled);
        sb.write(line.red());
      } else {
        sb.write(prefixVerticalStyled);
        sb.write(line.grey());
      }
      sb.write('\n');
    }
    _ctx.write(sb.toString());
  }

  /// Logs a fatal error message.
  ///
  /// This method is used to log a message indicating a fatal error that
  /// cannot be recovered from. It can also include an optional error object
  /// and stack trace for more detailed debugging information.
  ///
  /// [message] The fatal error message to log. This can be `null`.
  /// [error] An optional error object associated with the fatal error.
  /// [stackTrace] An optional stack trace associated with the fatal error.
  void fatal(String? message, {Object? error, StackTrace? stackTrace}) {
    final sb = StringBuffer();
    sb.write('$message');
    if (error != null) {
      sb.write(' $error');
    }
    _ctx.write(prefixErrorStyled);
    _ctx.write(sb.toString().red());
  }

  /// Clears the console screen.
  void clear() {
    Context.reset();
  }

  /// Starts the console with the given title and an optional message.
  ///
  /// The [title] parameter specifies the title to be displayed.
  /// The [message] parameter is an optional message that can be displayed.
  ///
  /// Example:
  /// ```dart
  /// start('Welcome', message: 'Hello, user!');
  /// ```
  void start(String title, {String? message}) {
    final sb = StringBuffer();
    sb.write(_theme.linePrefixStyle('┌'));
    sb.write(' $title '.onGreen().white());
    if (message != null) {
      sb.write(' ');
      sb.write(_theme.hintStyle(message));
    }
    _ctx.writeln(sb.toString());
    verticalLine();
  }

  /// Ends the current console session with an optional message.
  ///
  /// The [title] parameter specifies the title of the session to end.
  /// The [message] parameter is an optional message to display upon ending the session.
  ///
  /// Example:
  /// ```dart
  /// end('Session Title', message: 'Session ended successfully.');
  /// ```
  void end(String title, {String? message}) {
    final sb = StringBuffer();
    sb.write(_theme.linePrefixStyle('└'));
    sb.write(' $title '.onGray().white());
    if (message != null) {
      sb.write(' ');
      sb.write(_theme.hintStyle(message));
    }
    verticalLine();
    _ctx.writeln(sb.toString());
  }

  void newLine() {
    _ctx.writeln(' ');
  }

  void verticalLine() {
    _ctx.writeln(prefixVerticalStyled);
  }

  /// Constructs an [Input] component with the supplied_theme.
  String prompt(
    String prompt, {
    bool Function(String)? validator,
    String initialText = '',
    String? defaultValue,
  }) =>
      Input.withTheme(
        theme: _theme,
        prompt: prompt,
        validator: validator,
        initialText: initialText,
        defaultValue: defaultValue,
      ).interact();

  /// Constructs a [Password] component with the supplied_theme.
  String password(
    String prompt, {
    bool confirmation = false,
    String? confirmPrompt,
    String? confirmError,
  }) =>
      Password.withTheme(
        theme: _theme,
        prompt: prompt,
        confirmation: confirmation,
        confirmPrompt: confirmPrompt,
        confirmError: confirmError,
      ).interact();

  /// Constructs a [Confirm] component with the supplied_theme.
  bool confirm(
    String prompt, {
    bool? defaultValue,
    bool waitForNewLine = false,
  }) =>
      Confirm.withTheme(theme: _theme, prompt: prompt, defaultValue: defaultValue, waitForNewLine: waitForNewLine)
          .interact();

  /// Constructs a [Select] component with the supplied_theme.
  T select<T>(
    String prompt, {
    required List<T> options,
    T? defaultValue,
    required String Function(T) display,
  }) {
    final result = Select.withTheme(
      theme: _theme,
      prompt: prompt,
      options: options.map(display).toList(),
      initialIndex: defaultValue != null ? options.indexOf(defaultValue) : 0,
    ).interact();
    return options[result];
  }

  /// Constructs a [MultiSelect] component with the supplied_theme.
  List<T> multiSelect<T>(
    String prompt, {
    required List<T> options,
    List<T>? defaultValues,
    required String Function(T) display,
  }) {
    final result = MultiSelect.withTheme(
      theme: _theme,
      prompt: prompt,
      options: options.map(display).toList(),
      defaults: defaultValues != null ? options.map((e) => defaultValues.contains(e)).toList() : null,
    ).interact();
    return result.map((index) => options[index]).toList();
  }

  /// Constructs a [Spinner] component with the supplied_theme.
  SpinnerState progress(
    String prompt, {
    String? successMessage,
    String? failedMessage,
    bool clear = false,
  }) =>
      Spinner.withTheme(
        prompt: prompt,
        theme: _theme,
        icon: _theme.successPrefix,
        failedIcon: _theme.errorPrefix,
        clear: clear,
      ).interact();

  /// Executes a task asynchronously.
  ///
  /// This method performs a specific task and returns a [Future] that completes
  /// when the task is finished. The exact nature of the task is not specified
  /// in this snippet.
  ///
  /// Throws:
  /// - Any exceptions that might occur during the execution of the task.
  Future<void> task(
    String prompt, {
    required Future<void> Function(SpinnerState spinner) task,
    String? successMessage,
    String? failedMessage,
    bool clear = false,
  }) async {
    final spinner = Spinner.withTheme(
      prompt: prompt,
      theme: _theme,
      icon: _theme.successPrefix,
      failedIcon: _theme.errorPrefix,
      clear: clear,
    ).interact();
    try {
      final result = await task(spinner);

      spinner.success(successMessage);
      return result;
    } catch (e) {
      spinner.failed(failedMessage);
    }
  }
}

/// Prompts the user with a message and returns their input as a string.
///
/// The function displays a message to the user and waits for their input.
/// Once the user provides their input, it is returned as a string.
///
/// Returns:
///   A string containing the user's input.
String prompt(
  String prompt, {
  bool Function(String)? validator,
  String initialText = '',
  String? defaultValue,
}) =>
    ZooConsole.instance.prompt(prompt, validator: validator, initialText: initialText, defaultValue: defaultValue);

/// Constructs a [Password] component with the suppliedzooConsoleTheme.
String password(
  String prompt, {
  bool confirmation = false,
  String? confirmPrompt,
  String? confirmError,
}) =>
    ZooConsole.instance
        .password(prompt, confirmation: confirmation, confirmPrompt: confirmPrompt, confirmError: confirmError);

/// Constructs a [Confirm] component with the suppliedzooConsoleTheme.
bool confirm(
  String prompt, {
  bool? defaultValue,
  bool waitForNewLine = false,
}) =>
    ZooConsole.instance.confirm(prompt, defaultValue: defaultValue, waitForNewLine: waitForNewLine);

/// Constructs a [Select] component with the suppliedzooConsoleTheme.
T select<T>(
  String prompt, {
  required List<T> options,
  T? defaultValue,
  required String Function(T) display,
}) =>
    ZooConsole.instance.select(prompt, options: options, defaultValue: defaultValue, display: display);

/// Constructs a [MultiSelect] component with the suppliedzooConsoleTheme.
List<T> multiSelect<T>(
  String prompt, {
  required List<T> options,
  List<T>? defaultValues,
  required String Function(T) display,
}) =>
    ZooConsole.instance.multiSelect(prompt, options: options, defaultValues: defaultValues, display: display);

/// Constructs a [Spinner] component with the suppliedzooConsoleTheme.
SpinnerState progress(
  String prompt, {
  String? successMessage,
  String? failedMessage,
  bool clear = false,
}) =>
    ZooConsole.instance.progress(prompt, successMessage: successMessage, failedMessage: failedMessage, clear: clear);

Future<void> task(
  String prompt, {
  required Future<void> Function(SpinnerState spinner) task,
  String? successMessage,
  String? failedMessage,
  bool clear = false,
}) =>
    ZooConsole.instance
        .task(prompt, task: task, successMessage: successMessage, failedMessage: failedMessage, clear: clear);

void newLine() => ZooConsole.instance.newLine();
void verticalLine() => ZooConsole.instance.verticalLine();
void clear() => ZooConsole.instance.clear();
void start(String title, {String? message}) => ZooConsole.instance.start(title, message: message);
void end(String title, {String? message}) => ZooConsole.instance.end(title, message: message);
