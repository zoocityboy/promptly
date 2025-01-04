import 'package:promptly/promptly.dart';
import 'package:promptly/src/utils/string_buffer.dart';
import 'package:promptly_ansi/promptly_ansi.dart';

part 'console.direct.dart';

/// A class that represents a console for the Zoo application.
///
/// This class provides various methods and properties to interact with
/// the console, allowing for input and output operations within the Zoo
/// application.
class Console {
  static final Console _instance = Console._internal();

  /// Access to singleton instance
  static Console get instance => _instance;

  factory Console({Theme? theme}) {
    if (theme != null) {
      _instance._theme = theme;
    }
    return _instance;
  }

  Console._internal()
      : _ctx = Context(),
        _theme = Theme.defaultTheme;

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
  void writeStyled(String message) => _ctx.write(theme.prefixLine(theme.promptTheme.messageStyle(message)));

  /// Writes a message to the console followed by a newline.
  ///
  /// This method delegates the writing operation to the underlying context.
  ///
  /// @param message The message to be written to the console.
  void writeln(String message) => _ctx.writeln(message);
  void writelnStyled(String message) {
    final lines = message.split('\n');
    for (final line in lines) {
      _ctx
        ..write(theme.prefixLine(theme.promptTheme.messageStyle(line)))
        ..write('\n');
    }
  }

  void style(String message, {String Function(Console)? prefix, bool newLine = true}) => _ctx
    ..write(prefix != null ? prefix.call(this) : theme.prefixLine(''))
    ..write(theme.promptTheme.messageStyle(message))
    ..write(newLine ? '\n${theme.prefixLine('')}\n' : '');

  /// Logs an informational message to the console.
  ///
  /// The [message] parameter is the message to be logged. If [message] is null,
  /// no message will be logged.
  ///
  /// Example:
  /// ```dart
  /// info('This is an informational message.');
  /// ```
  void info(String? text) {
    if (text == null) return;
    final x = message(text, style: MessageStyle.info);
    _ctx.writeln(x);
  }

  /// Logs an error message to the console.
  void error(String text) {
    _ctx.writeln(message(text, style: MessageStyle.error));
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
  void fatal(String? text, {Object? error, StackTrace? stackTrace}) {
    final buffer = StringBuffer();
    buffer.write(message(text ?? 'Fatal error', style: MessageStyle.error));
    if (error != null) {
      buffer.write('\n');
      buffer.write(message(error.toString(), style: MessageStyle.error));
    }
    if (stackTrace != null) {
      buffer.write('\n');
      buffer.write(message(stackTrace.toString(), style: MessageStyle.error));
    }
    _ctx.writeln(buffer.toString());
  }

  /// Clears the console screen.
  void clear() {
    Context.reset();
    _ctx.wipe();
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
  void success(String title, {String? message}) {
    final sb = StringBuffer();
    sb.write(_theme.colors.prefix('└'));
    sb.write(_theme.colors.prefix('❯'));
    sb.write(_theme.colors.success('❯').dim());
    sb.write(_theme.colors.success('❯'));
    sb.write(' ');
    // sb.write(_theme.colors.prefix('❯' * (_theme.spacing - 1)));
    // sb.write(' ');
    sb.write(_theme.colors.successBlock(' $title '));
    if (message != null) {
      sb.write(' ');
      sb.write(_theme.colors.success(message));
    }
    line();
    _ctx.writeln(sb.toString());
  }

  void failure(String title, {String? message}) {
    final sb = StringBuffer();
    sb.write(_theme.colors.prefix('└'));
    sb.write(_theme.colors.prefix('❯'));
    sb.write(_theme.colors.error('❯').dim());
    sb.write(_theme.colors.error('❯'));
    sb.write(' ');
    sb.write(
      ' $title '.onRed().white(),
    );
    if (message != null) {
      sb.write(' ');
      sb.write(_theme.colors.error(message));
    }
    line();
    _ctx.writeln(sb.toString());
  }

  void spacer() => _ctx.writeln('');

  void line({String? message}) {
    if (message == null) {
      _ctx.writeln(_theme.colors.prefix(_theme.symbols.vLine).padRight(_theme.spacing));
    } else {
      _ctx.writeln(_theme.colors.prefix(_theme.symbols.vLine).padRight(_theme.spacing));
      _ctx.write(_theme.promptTheme.messageStyle(message));
      _ctx.writeln();
    }
    // if (message == null) {
    //   _ctx.writeln(prefixVerticalStyled);
    // } else {
    //   _ctx.write(prefixVerticalStyled);
    //   _ctx.write(theme.promptTheme.messageStyle(message));
    //   _ctx.writeln();
    // }
  }

  String link(LinkData data) => data.link();

  /// Writes a message to the console with the specified style.
  String message(String message, {String? prefix, MessageStyle? style}) =>
      Message.withTheme(theme: _theme, message: message, style: style, prefix: prefix).interact();

  /// Starts the console with the given title and an optional message.
  ///
  /// The [title] parameter specifies the title to be displayed.
  /// The [message] parameter is an optional message that can be displayed.
  ///
  /// Example:
  /// ```dart
  /// start('Welcome', message: 'Hello, user!');
  /// ```
  // void header(String title, {String? message}) {
  //   final sb = StringBuffer();
  //   sb.write(_theme.colors.prefix('┌'));
  //   sb.write(_theme.colors.successBlock(' $title '.bold()));
  //   if (message != null) {
  //     sb.write(' ');
  //     sb.write(_theme.promptTheme.hintStyle(message));
  //   }
  //   _ctx.writeln(sb.toString());
  //   line();
  // }
  String header(String title, {String? message, String? prefix}) =>
      Header.withTheme(theme: _theme, prefix: prefix, title: title, message: message).interact();

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

  ProgressState progress(
    String prompt, {
    required int length,
    double size = 1.0,
    ProgressFn? startLabel,
    ProgressFn? endLabel,
  }) =>
      Progress.withTheme(
        prompt,
        length: length,
        theme: _theme,
        size: size,
        startLabel: startLabel,
        endLabel: endLabel,
      ).interact();

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
        icon: _theme.loaderTheme.successStyle(_theme.loaderTheme.successPrefix),
        failedIcon: _theme.loaderTheme.errorStyle(_theme.loaderTheme.errorPrefix),
        clear: clear,
      ).interact();

  MultiLoaderState multiProcessing(String? prompt, List<Loader> tasks) {
    // final spinners = tasks.map((task) {
    //   final spinner = Loader.withTheme(
    //     prompt: prompt ?? 'Processing...',
    //     theme: _theme,
    //     icon: _theme.loaderTheme.successStyle(_theme.loaderTheme.successPrefix),
    //     failedIcon: _theme.loaderTheme.errorStyle(_theme.loaderTheme.errorPrefix),
    //   ).interact();
    //   return task(spinner);
    // }).toList();
    final MultiLoader multiLoader = MultiLoader();
    final result = multiLoader.addAll(tasks);
    return result;
  }

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
      icon: _theme.loaderTheme.successPrefix,
      failedIcon: _theme.loaderTheme.errorPrefix,
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
