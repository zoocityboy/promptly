import 'package:promptly/promptly.dart';
import 'package:promptly/src/theme/theme.dart';
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
  int success(String title, {String? message, String? suggestion}) {
    final sb = StringBuffer();
    if (theme.spacing > 0) {
      sb.write(_theme.colors.prefix('└'));
    }
    sb.write(_theme.colors.prefix('❯'));
    sb.write(_theme.colors.success('❯').dim());
    sb.write(_theme.colors.success('❯'));
    sb.write(' ');
    sb.write(_theme.colors.success(' ✓ $title ').inverse());
    if (message != null) {
      sb.write(' ');
      sb.write(_theme.colors.success(message));
    }
    line();
    _ctx.writeln(sb.toString());
    if (suggestion != null) {
      line();
      final sb = StringBuffer();
      sb.withPrefix(
        _theme.symbols.dotStep,
        _theme.colors.hint('Next steps'),
        spacing: theme.spacing,
        style: _theme.colors.warning,
      );
      sb.writeln('');
      sb.withPrefix(
        '',
        _theme.colors.warning(suggestion),
        spacing: theme.spacing,
        style: _theme.colors.warning,
      );
      // sb.writeln(_theme.colors.hint(suggestion));
      _ctx.writeln(sb.toString());
    }
    return ExitCode.success.code;
  }

  int failure(String title, {String? message, int? exitCode, StackTrace? stackTrace}) {
    final sb = StringBuffer();
    if (theme.spacing > 0) {
      sb.write(_theme.colors.prefix('└'));
    }
    sb.write(_theme.colors.prefix('❯'));
    sb.write(_theme.colors.error('❯').dim());
    sb.write(_theme.colors.error('❯'));
    sb.write(' ');
    sb.write(
      ' ■ $title '.onRed().white(),
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

  Link _link(LinkData data) => Link.withTheme(
        theme: theme,
        uri: data.uri,
        message: data.message,
        context: _ctx,
      );
  String linkLine(String url, {String? label}) => _link(LinkData(uri: Uri.parse(url), message: label)).interact();
  void writeLink(String url, {String? label}) => _link(LinkData(uri: Uri.parse(url), message: label)).render();

  /// Writes a message to the console with the specified style.
  Message _message(String message, {String? prefix, MessageStyle? style}) => Message.withTheme(
        text: message,
        prefix: prefix,
        theme: _theme,
        style: style ?? MessageStyle.verbose,
        context: _ctx,
      );
  String messageLine(String message, {String? prefix, MessageStyle? style}) =>
      _message(message, prefix: prefix, style: style).interact();
  void writeMessage(String message, {String? prefix, MessageStyle? style}) =>
      _message(message, prefix: prefix, style: style).render();

  /// Starts the console with the given title and an optional message.
  ///
  /// The [title] parameter specifies the title to be displayed.
  /// The [message] parameter is an optional message that can be displayed.
  ///
  /// Example:
  /// ```dart
  /// start('Welcome', message: 'Hello, user!');
  /// ```
  Header _header(String title, {String? message, String? prefix}) => Header.withTheme(
        theme: _theme,
        title: title,
        message: message,
        prefix: prefix,
        context: _ctx,
      );
  String headerLine(String title, {String? message, String? prefix}) => _header(
        title,
        message: message,
        prefix: prefix,
      ).interact();
  void writeHeader(String title, {String? message, String? prefix}) => _header(
        title,
        message: message,
        prefix: prefix,
      ).render();

  Section _section(String title, {String? message, String? prefix}) => Section.withTheme(
        theme: _theme,
        title: title,
        message: message,
        prefix: prefix,
        context: _ctx,
      );
  String sectionLine(String title, {String? message, String? prefix}) => _section(
        title,
        message: message,
        prefix: prefix,
      ).interact();
  void writeSection(String title, {String? message, String? prefix}) => _section(
        title,
        message: message,
        prefix: prefix,
      ).render();

  /// Constructs an [Prompt] component with the supplied_theme.
  String prompt(
    String prompt, {
    Validator<String>? validator,
    String initialText = '',
    String? defaultValue,
    String? value,
  }) =>
      Prompt.withTheme(
        theme: _theme,
        prompt: prompt,
        validator: validator,
        initialText: initialText,
        defaultValue: defaultValue,
        value: value,
      ).interact();

  /// Constructs a [Password] component with the supplied_theme.
  String password(
    String prompt, {
    bool confirmation = false,
    String? confirmPrompt,
    String? confirmError,
    String? value,
  }) =>
      Password.withTheme(
        theme: _theme,
        prompt: prompt,
        confirmation: confirmation,
        confirmPrompt: confirmPrompt,
        confirmError: confirmError,
        value: value,
      ).interact();

  /// Constructs a [Confirm] component with the supplied_theme.
  bool confirm(
    String prompt, {
    bool? defaultValue,
    bool enterForConfirm = false,
    bool? value,
  }) =>
      Confirm.withTheme(
        theme: _theme,
        prompt: prompt,
        defaultValue: defaultValue,
        enterForConfirm: enterForConfirm,
        value: value,
      ).interact();

  /// Constructs a [SelectOne] component with the supplied_theme.
  T selectOne<T>(
    String prompt, {
    required List<T> choices,
    T? defaultValue,
    String Function(T)? display,
    int? value,
  }) {
    final result = SelectOne.withTheme(
      theme: _theme,
      prompt: prompt,
      choices: choices.map((e) => display?.call(e) ?? e.toString()).toList(),
      initialIndex: defaultValue != null ? choices.indexOf(defaultValue) : 0,
      value: value,
    ).interact();
    return choices[result];
  }

  /// Constructs a [SelectAny] component with the supplied_theme.
  List<T> selectAny<T>(
    String prompt, {
    required List<T> choices,
    List<T>? defaultValues,
    String Function(T)? display,
    List<int>? value,
  }) {
    final result = SelectAny.withTheme(
      theme: _theme,
      prompt: prompt,
      choices: choices.map((e) => display?.call(e) ?? e.toString()).toList(),
      defaults: defaultValues != null ? choices.map((e) => defaultValues.contains(e)).toList() : null,
      value: value,
    ).interact();
    return result.map((index) => choices[index]).toList();
  }

  TableRow selectTable(
    String prompt, {
    required List<String> headers,
    required List<TableRow> rows,
  }) {
    final result = SelectTable.withTheme(
      prompt,
      theme: _theme,
      headers: headers,
      rows: rows,
    ).interact();
    return rows[result];
  }

  Table table({
    required List<Column> columns,
    required List<TableRow> rows,
    int columnSpacing = 2,
  }) =>
      Table.withTheme(
        columns: columns,
        theme: _theme,
        columnPadding: columnSpacing,
      );

  ProgressState progress(
    String prompt, {
    required int length,
    double size = 1.0,
    ProgressFn? startLabel,
    ProgressFn? endLabel,
    bool hideProgressOnFinish = true,
  }) =>
      Progress.withTheme(
        prompt,
        length: length,
        theme: _theme,
        size: size,
        startLabel: startLabel,
        endLabel: endLabel,
        hideProgressOnFinish: hideProgressOnFinish,
      ).interact();

  /// Constructs a [Loader] component with the supplied_theme.
  LoaderState processing(
    String prompt, {
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
    bool throwOnError = false,
    Function(Object error)? onError,
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
      onError?.call(e);
      if (throwOnError) {
        rethrow;
      }
      return Future.value();
    }
  }

  void cleanScreen() {
    _ctx.cleanScreen();
  }
}
