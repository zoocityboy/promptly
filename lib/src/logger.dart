import 'dart:collection';
import 'dart:io' as io;

enum ZooLogLevel {
  verbose,
  info,
  warning,
  error,
  fatal,
}

/// A function that outputs a log message.
typedef ZooLogPrinter = void Function(ZooLogLevel level, String message);

/// Default printer that prints to stdout.
/// A default printer function for logging messages.
///
/// This function takes a log level and a message, and prints the message
/// to the console with the appropriate log level.
///
/// - Parameters:
///   - level: The log level of the message.
///   - message: The message to be logged.
void defaultPrinter(ZooLogLevel level, String message) =>
    [ZooLogLevel.error, ZooLogLevel.fatal].contains(level) ? io.stderr.writeln(message) : io.stdout.writeln(message);

/// A simple logger that logs to stdout.
class ZooLogger {
  static final ZooLogger _instance = ZooLogger._internal();

  /// Access to singleton instance
  static ZooLogger get instance => _instance;
  factory ZooLogger({
    ZooLogPrinter printer = defaultPrinter,
    ZooLogLevel level = ZooLogLevel.info,
    int maxQueueSize = 100,
  }) {
    _instance._printer = printer;
    _instance._level = level;
    _instance._maxQueueSize = maxQueueSize;
    return _instance;
  }
  ZooLogger._internal()
      : _level = ZooLogLevel.info,
        _printer = defaultPrinter,
        _maxQueueSize = 100;

  final Queue<MapEntry<ZooLogLevel, String>> _queue = Queue();

  /// The logging level for the logger.
  ///
  /// This determines the severity of the messages that will be logged.
  /// Only messages with a severity equal to or higher than this level will be logged.
  ZooLogLevel _level;

  /// The logging level for the logger.
  // ignore: avoid_setters_without_getters
  set level(ZooLogLevel level) {
    _level = level;
  }

  /// A printer instance used to handle the log output.
  ///
  /// This is an instance of [ZooLogPrinter] which is responsible for formatting
  /// and printing log messages.
  ZooLogPrinter _printer;

  int _maxQueueSize;

  /// Log a message if the specified log level is greater than or equal to the current log level.
  ///
  /// The `level.index >= _level.index` check ensures that only messages with a log level
  /// equal to or higher than the current log level are logged.
  void log(String message, {ZooLogLevel level = ZooLogLevel.info, bool delayed = false}) {
    if (level.index >= _level.index) {
      if (delayed) {
        _delayed(message, level: level);
      } else {
        _printer(level, message);
      }
    }
  }

  /// Log an info message.
  void info(String message, {bool delayed = false}) => log(message, delayed: delayed);

  /// Log a warning message.
  void warning(String message, {bool delayed = false}) => log(message, level: ZooLogLevel.warning, delayed: delayed);

  /// Log an error message.
  void error(String message, {bool delayed = false}) => log(message, level: ZooLogLevel.error, delayed: delayed);

  /// Log a fatal message.
  void fatal(String message, {bool delayed = false}) => log(message, level: ZooLogLevel.fatal, delayed: delayed);

  /// Logs a message with a delay.
  ///
  /// The message will be logged at the specified [level], which defaults to
  /// [ZooLogLevel.info].
  ///
  /// [message] The message to be logged.
  /// [level] The level at which the message should be logged. Defaults to
  /// [ZooLogLevel.info].
  void _delayed(String message, {ZooLogLevel level = ZooLogLevel.info}) {
    if (_queue.length >= _maxQueueSize) {
      _queue.removeFirst();
    }
    _queue.add(MapEntry(level, message));
  }

  /// Flushes the logger, ensuring that all buffered log messages are written out.
  void flush() {
    while (_queue.isNotEmpty) {
      final item = _queue.removeFirst();
      log(item.value, level: item.key);
    }
    _queue.clear();
  }
}
