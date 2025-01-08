part of 'framework.dart';

enum LogLevel {
  verbose,
  info,
  warning,
  error,
  fatal,
}

/// A function that outputs a log message.
typedef LogPrinter = void Function(LogItem item);

/// Default printer that prints to stdout.
/// A default printer function for logging messages.
///
/// This function takes a log level and a message, and prints the message
/// to the console with the appropriate log level.
///
/// - Parameters:
///   - level: The log level of the message.
///   - message: The message to be logged.
void defaultPrinter(LogItem item) => [LogLevel.error, LogLevel.fatal].contains(item.level)
    ? stderr.writeln(item.withTime())
    : stdout.writeln(item.withTime());

@immutable
class LogItem {
  LogItem({
    DateTime? dateTime,
    required this.level,
    required this.message,
    this.command,
  }) {
    this.dateTime = dateTime ?? DateTime.now().toUtc();
  }
  late final DateTime dateTime;
  final LogLevel level;
  final String message;
  final String? command;

  String get commandName {
    if (command == null) {
      return ' ';
    }
    return '[$command] ';
  }

  String withTime() => '${dateTime.hour}:${dateTime.minute}:${dateTime.second} $commandName$message';
  String withoutTime() => '$commandName$message';
}

/// A simple logger that logs to stdout.
class Logger {
  static final Logger _instance = Logger._internal();

  /// Access to singleton instance
  static Logger get instance => _instance;
  factory Logger({
    LogPrinter printer = defaultPrinter,
    LogLevel level = LogLevel.info,
    int maxQueueSize = 100,
  }) {
    _instance._printer = printer;
    _instance._level = level;
    _instance._maxQueueSize = maxQueueSize;

    return _instance;
  }
  Logger._internal()
      : _level = LogLevel.info,
        _printer = defaultPrinter,
        _maxQueueSize = 100;

  final ListQueue<LogItem> _queue = ListQueue<LogItem>();

  // ignore: avoid_setters_without_getters
  /// Sets the [LogPrinter] instance to be used for logging.
  ///
  /// The [printer] parameter is the [LogPrinter] instance that will handle
  /// the formatting and output of log messages.
  // ignore: avoid_setters_without_getters
  set printer(LogPrinter printer) {
    _printer = printer;
  }

  /// The logging level for the logger.
  ///
  /// This determines the severity of the messages that will be logged.
  /// Only messages with a severity equal to or higher than this level will be logged.
  LogLevel _level;

  /// The logging level for the logger.
  // ignore: avoid_setters_without_getters
  set level(LogLevel level) {
    _level = level;
  }

  /// A printer instance used to handle the log output.
  ///
  /// This is an instance of [LogPrinter] which is responsible for formatting
  /// and printing log messages.
  LogPrinter _printer;

  int _maxQueueSize;

  /// Log a message if the specified log level is greater than or equal to the current log level.
  ///
  /// The `level.index >= _level.index` check ensures that only messages with a log level
  /// equal to or higher than the current log level are logged.
  void log(String message, {LogLevel level = LogLevel.info, bool delayed = false, String? commandName}) {
    // stdout.writeln('[${level.name}${level.index} >= ${_level.index}] $message');
    // stdout.writeln('-> ${LogLevel.values.map((e) => '${e.index} ${e.name},').toList()}');

    if (delayed) {
      _delayed(message, level: level, commandName: commandName);
    } else {
      if (_level.index >= level.index) {
        _printer(LogItem(dateTime: DateTime.now().toUtc(), level: level, message: message, command: commandName));
      }
    }
  }

  void verbose(String message, {bool delayed = false}) => log(message, level: LogLevel.verbose, delayed: delayed);

  /// Log an info message.
  void info(String message, {bool delayed = false}) => log(message, delayed: delayed);

  /// Log a warning message.
  void warning(String message, {bool delayed = false}) => log(message, level: LogLevel.warning, delayed: delayed);

  /// Log an error message.
  void error(String message, {bool delayed = false}) => log(message, level: LogLevel.error, delayed: delayed);

  /// Log a fatal message.
  void fatal(String message, {bool delayed = false}) => log(message, level: LogLevel.fatal, delayed: delayed);

  void trace(String message, {String? commandName}) => log(
        message,
        level: LogLevel.verbose,
        delayed: true,
        commandName: commandName,
      );

  /// Logs a message with a delay.
  ///
  /// The message will be logged at the specified [level], which defaults to
  /// [LogLevel.info].
  ///
  /// [message] The message to be logged.
  /// [level] The level at which the message should be logged. Defaults to
  /// [LogLevel.info].
  void _delayed(String message, {LogLevel level = LogLevel.info, String? commandName}) {
    if (_queue.length > _maxQueueSize) {
      _queue.removeFirst();
    }
    _queue.add(LogItem(dateTime: DateTime.now().toUtc(), level: level, message: message, command: commandName));
  }

  /// Flushes the logger, ensuring that all buffered log messages are written out.
  void flush({bool withTime = true}) {
    _printer(
      LogItem(
        level: LogLevel.verbose,
        message: 'Flushing log messages [${_queue.length}]...',
      ),
    );
    for (final item in _queue) {
      _printer(item);
    }
    _queue.clear();
  }
}
