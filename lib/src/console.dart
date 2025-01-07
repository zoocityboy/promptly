import 'dart:io';

import 'package:io/io.dart';
import 'package:promptly/promptly.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/prompt.dart';
import 'package:promptly/src/utils/string_buffer.dart';

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

  /// Gets the current theme.
  ///
  /// Returns the current [Theme] object.
  // ignore: unnecessary_getters_setters
  Theme get theme => _theme;
  set theme(Theme value) => _theme = value;
  final Context _ctx;

  /// Gets the spacing value from the current theme.
  ///
  /// This value is used to determine the spacing between elements
  /// in the console output.
  int get spacing => _theme.spacing;

  /// Gets the width of the console window.
  ///
  /// Returns the width of the console window in characters.
  int get windowWidth => _ctx.windowWidth;

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
  void writeln(String message) => _ctx
    ..write(message)
    ..write('\n');

  // /// Writes a message to the console with the specified style.
  // void writeStyled(String message) {
  //   if (theme.spacing > 0) {
  //     _ctx.write(theme.prefixLine(theme.promptTheme.messageStyle(message)));
  //   } else {
  //     _ctx.write(theme.promptTheme.messageStyle(message));
  //   }
  // }

  // void writelnStyled(String message) {
  //   final lines = message.split('\n');
  //   for (final line in lines) {
  //     if (theme.spacing > 0) {
  //       _ctx.write(theme.prefixLine(theme.promptTheme.messageStyle(line)));
  //     } else {
  //       _ctx.write(theme.promptTheme.messageStyle(line));
  //     }
  //     _ctx.write('\n');
  //   }
  // }

  // void style(String message, {String Function(Console)? prefix, bool newLine = true}) => _ctx
  //   ..write(prefix != null ? prefix.call(this) : theme.prefixLine(''))
  //   ..write(theme.promptTheme.messageStyle(message))
  //   ..write(newLine ? '\n${theme.prefixLine('')}\n' : '');

  // /// Logs a fatal error message.
  // ///
  // /// This method is used to log a message indicating a fatal error that
  // /// cannot be recovered from. It can also include an optional error object
  // /// and stack trace for more detailed debugging information.
  // ///
  // /// [message] The fatal error message to log. This can be `null`.
  // /// [error] An optional error object associated with the fatal error.
  // /// [stackTrace] An optional stack trace associated with the fatal error.
  // void fatal(String? text, {Object? error, StackTrace? stackTrace}) {
  //   final buffer = StringBuffer();
  //   buffer.write(promptMessage(text ?? 'Fatal error', style: MessageStyle.error, theme: _theme));
  //   if (error != null) {
  //     buffer.write('\n');
  //     buffer.write(theme.promptTheme.(error.toString(), style: MessageStyle.error));
  //   }
  //   if (stackTrace != null) {
  //     buffer.write('\n');
  //     buffer.write(message(stackTrace.toString(), style: MessageStyle.error));
  //   }
  //   _ctx.writeln(buffer.toString());
  // }

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
  int success(String title, {String? message}) {
    final sb = StringBuffer();
    if (theme.spacing > 0) {
      sb.write(_theme.colors.prefix('└'));
    }
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
    return ExitCode.success.code;
  }

  int failure(String title, {String? message, int? exitCode}) {
    final sb = StringBuffer();
    if (theme.spacing > 0) {
      sb.write(_theme.colors.prefix('└'));
    }
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
    return exitCode ?? ExitCode.software.code;
  }

  void spacer() => _ctx.writeln('');

  void line({String? message}) {
    if (message == null) {
      final line = theme.spacing > 0 ? theme.prefixLine('') : '';
      _ctx.write(line);
      _ctx.write('\n');
    } else {
      final line = theme.spacing > 0 ? theme.prefixLine(_theme.symbols.vLine) : '';
      _ctx.write(line);
      _ctx.write(_theme.promptTheme.messageStyle(message));
      _ctx.write('\n');
    }
  }

  String link(LinkData data) => data.link();

  /// Writes a message to the console with the specified style.
  void message(String message, {String? prefix, MessageStyle? style}) => Message(
        text: message,
        theme: _theme,
        style: style ?? MessageStyle.verbose,
      ).render(context: _ctx);

  /// Starts the console with the given title and an optional message.
  ///
  /// The [title] parameter specifies the title to be displayed.
  /// The [message] parameter is an optional message that can be displayed.
  ///
  /// Example:
  /// ```dart
  /// start('Welcome', message: 'Hello, user!');
  /// ```
  void header(String title, {String? message, String? prefix}) {
    _ctx.write(promptHeader(title, theme: _theme, windowWidth: _ctx.windowWidth, message: message, prefix: prefix));
  }

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
  T selectOne<T>(
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
  List<T> selectAny<T>(
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
  Future<T> task<T>(
    String prompt, {
    required Future<T> Function(LoaderState spinner) task,
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
      reset();
      exit(ExitCode.ioError.code);
    }
  }

  void cleanScreen() {
    _ctx.cleanScreen();
  }
}
