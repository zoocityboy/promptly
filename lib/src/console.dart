import 'package:zoo_console/src/components/loader.dart';
import 'package:zoo_console/src/theme/theme.dart';
import 'package:zoo_console/zoo_console.dart';

part 'console.direct.dart';

/// A class that represents a console for the Zoo application.
///
/// This class provides various methods and properties to interact with
/// the console, allowing for input and output operations within the Zoo
/// application.
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
  String get prefixTraceStartStyled => '•'.padRight(spacing).cyan();

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
  void writeStyled(String message) => _ctx
    ..write(prefixVerticalStyled)
    ..write(theme.defaultStyle(message));

  /// Writes a message to the console followed by a newline.
  ///
  /// This method delegates the writing operation to the underlying context.
  ///
  /// @param message The message to be written to the console.
  void writeln(String message) => _ctx.writeln(message);
  void writelnStyled(String message) => _ctx
    ..write(prefixVerticalStyled)
    ..writeln(theme.defaultStyle(message));

  void style(String message, {String Function(ZooConsole)? prefix, bool newLine = true}) => _ctx
    ..write(prefix != null ? prefix.call(this) : prefixVerticalStyled)
    ..write(theme.defaultStyle(message))
    ..write(newLine ? '\n$prefixVerticalStyled\n' : '');

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
    _ctx.wipe();
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
    line();
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
    line();
    _ctx.writeln(sb.toString());
  }

  void spacer() => _ctx.writeln('');

  void line({String? message}) {
    if (message == null) {
      _ctx.writeln(prefixVerticalStyled);
    } else {
      _ctx.write(prefixVerticalStyled);
      _ctx.write(theme.defaultStyle(message));
      _ctx.writeln();
    }
  }

  String link(LinkData data) => data.link();

  /// Constructs an [Prompt] component with the supplied_theme.
  String prompt(
    String prompt, {
    Validator<String>? validator,
    String initialText = '',
    String? defaultValue,
  }) =>
      Prompt.withTheme(
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
    bool enterForConfirm = false,
  }) =>
      Confirm.withTheme(theme: _theme, prompt: prompt, defaultValue: defaultValue, enterForConfirm: enterForConfirm)
          .interact();

  /// Constructs a [Select] component with the supplied_theme.
  T select<T>(
    String prompt, {
    required List<T> choices,
    T? defaultValue,
    required String Function(T)? display,
  }) {
    final result = Select.withTheme(
      theme: _theme,
      prompt: prompt,
      choices: choices.map((e) => display?.call(e) ?? e.toString()).toList(),
      initialIndex: defaultValue != null ? choices.indexOf(defaultValue) : 0,
    ).interact();
    return choices[result];
  }

  /// Constructs a [MultiSelect] component with the supplied_theme.
  List<T> multiSelect<T>(
    String prompt, {
    required List<T> choices,
    List<T>? defaultValues,
    String Function(T)? display,
  }) {
    final result = MultiSelect.withTheme(
      theme: _theme,
      prompt: prompt,
      choices: choices.map((e) => display?.call(e) ?? e.toString()).toList(),
      defaults: defaultValues != null ? choices.map((e) => defaultValues.contains(e)).toList() : null,
    ).interact();
    return result.map((index) => choices[index]).toList();
  }

  TableRow table(
    String prompt, {
    required List<String> headers,
    required List<TableRow> rows,
  }) {
    final result = Table.withTheme(
      prompt,
      theme: _theme,
      headers: headers,
      rows: rows,
    ).interact();
    return rows[result];
  }

  /// Constructs a [Loader] component with the supplied_theme.
  LoaderState processing(
    String prompt, {
    String? successMessage,
    String? failedMessage,
    bool clear = false,
  }) =>
      Loader.withTheme(
        prompt: prompt,
        theme: _theme,
        icon: _theme.successPrefix,
        failedIcon: _theme.errorPrefix,
        clear: clear,
      ).interact();

  /// Executes a task asynchronously.
  ///
  /// This function performs an asynchronous operation. The specific details
  /// of the task are not provided in this snippet.
  ///
  /// Returns a [Future] that completes with no value when the task is done.
  /// This method performs a specific task and returns a [Future] that completes
  /// when the task is finished. The exact nature of the task is not specified
  /// in this snippet.
  ///
  /// Throws:
  /// - Any exceptions that might occur during the execution of the task.
  Future<void> task(
    String prompt, {
    required Future<void> Function(LoaderState spinner) task,
    String? successMessage,
    String? failedMessage,
    bool clear = false,
  }) async {
    final spinner = Loader.withTheme(
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
      spinner.failed(failedMessage ?? e.toString());
    }
  }
}
