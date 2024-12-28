import 'package:tint/tint.dart';
import 'package:zoo_console/src/framework/framework.dart';
import 'package:zoo_console/zoo_console.dart';

class ZooConsole with ConsoleMixin {
  ZooConsole({Theme? theme})
      : _ctx = Context(),
        _theme = theme ?? Theme.zooTheme;
  final Theme _theme;
  final Context _ctx;
  int get spacing => _theme.spacing;

  Theme get theme => _theme;

  String get prefixVerticalStyled => '│'.padRight(spacing).gray();
  String get prefixStartStyled => '┌'.padRight(spacing).gray();
  String get prefixEndStyled => '└'.padRight(spacing).gray();
  String get prefixDiamondStyled => '◇'.padRight(spacing).green();
  String get prefixUsageStyled => '◇'.padRight(spacing).green();
  String get prefixErrorStyled => '■'.padRight(spacing).red();
  String get prefixTraceStartStyled => '•'.padRight(spacing).cyan();
  String get prefixTraceItemStyled => '▹'.padRight(spacing).cyan().dim();
  String get prefixTStyled => '├'.padRight(spacing).gray();

  void write(String message) {
    _ctx.write(message);
  }

  void writeln(String message) {
    _ctx.writeln(message);
  }

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

  void fatal(String? message, {Object? error, StackTrace? stackTrace}) {
    final sb = StringBuffer();
    sb.write('$message');
    if (error != null) {
      sb.write(' $error');
    }
    _ctx.write(prefixErrorStyled);
    _ctx.write(sb.toString().red());
  }

  void clearScreen() {
    Context.reset();
  }

  void start(String title, {String? message}) {
    final sb = StringBuffer();
    sb.write(_theme.hintStyle('┌'));
    sb.write(' ' * (spacing - 1));
    sb.write(' $title '.onGreen().white());
    if (message != null) {
      sb.write(' ');
      sb.write(_theme.hintStyle(message));
    }
    _ctx.writeln(sb.toString());
    verticalLine();
  }

  void end(String title, {String? message}) {
    final sb = StringBuffer();
    sb.write(_theme.hintStyle('└'));
    sb.write(' ' * (spacing - 1));
    sb.write(' $title '.onMagenta().white());
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

mixin ConsoleMixin {}
Theme zooConsoleTheme = Theme.zooTheme;
String prompt(
  String prompt, {
  bool Function(String)? validator,
  String initialText = '',
  String? defaultValue,
}) =>
    Input.withTheme(
      theme: zooConsoleTheme,
      prompt: prompt,
      validator: validator,
      initialText: initialText,
      defaultValue: defaultValue,
    ).interact();

/// Constructs a [Password] component with the suppliedzooConsoleTheme.
String password(
  String prompt, {
  bool confirmation = false,
  String? confirmPrompt,
  String? confirmError,
}) =>
    Password.withTheme(
      theme: zooConsoleTheme,
      prompt: prompt,
      confirmation: confirmation,
      confirmPrompt: confirmPrompt,
      confirmError: confirmError,
    ).interact();

/// Constructs a [Confirm] component with the suppliedzooConsoleTheme.
bool confirm(
  String prompt, {
  bool? defaultValue,
  bool waitForNewLine = false,
}) =>
    Confirm.withTheme(
      theme: zooConsoleTheme,
      prompt: prompt,
      defaultValue: defaultValue,
      waitForNewLine: waitForNewLine,
    ).interact();

/// Constructs a [Select] component with the suppliedzooConsoleTheme.
T select<T>(
  String prompt, {
  required List<T> options,
  T? defaultValue,
  required String Function(T) display,
}) {
  final result = Select.withTheme(
    theme: zooConsoleTheme,
    prompt: prompt,
    options: options.map(display).toList(),
    initialIndex: defaultValue != null ? options.indexOf(defaultValue) : 0,
  ).interact();
  return options[result];
}

/// Constructs a [MultiSelect] component with the suppliedzooConsoleTheme.
List<T> multiSelect<T>(
  String prompt, {
  required List<T> options,
  List<T>? defaultValues,
  required String Function(T) display,
}) {
  final result = MultiSelect.withTheme(
    theme: zooConsoleTheme,
    prompt: prompt,
    options: options.map(display).toList(),
    defaults: defaultValues != null ? options.map((e) => defaultValues.contains(e)).toList() : null,
  ).interact();
  return result.map((index) => options[index]).toList();
}

/// Constructs a [Spinner] component with the suppliedzooConsoleTheme.
SpinnerState progress(
  String prompt, {
  String? successMessage,
  String? failedMessage,
  bool clear = false,
}) =>
    Spinner.withTheme(
      prompt: prompt,
      theme: zooConsoleTheme,
      icon: zooConsoleTheme.successPrefix,
      failedIcon: zooConsoleTheme.errorPrefix,
      clear: clear,
    ).interact();
Future<void> task(
  String prompt, {
  required Future<void> Function(SpinnerState spinner) task,
  String? successMessage,
  String? failedMessage,
  bool clear = false,
}) async {
  final spinner = Spinner.withTheme(
    prompt: prompt,
    theme: zooConsoleTheme,
    icon: zooConsoleTheme.successPrefix,
    failedIcon: zooConsoleTheme.errorPrefix,
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
