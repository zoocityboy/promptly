part of 'framework.dart';

enum LogLevel implements Comparable<LogLevel> {
  verbose(0),
  info(1),
  warning(2),
  error(3),
  fatal(4);

  final int severity;
  const LogLevel(this.severity);

  @override
  int compareTo(LogLevel other) => severity.compareTo(other.severity);
  bool operator <(LogLevel other) => severity < other.severity;
  bool operator >(LogLevel other) => severity > other.severity;
  bool operator <=(LogLevel other) => severity <= other.severity;
  bool operator >=(LogLevel other) => severity >= other.severity;

  bool allowed(LogLevel level) => level <= this;
}

class TempDirectory {
  TempDirectory({this.folderName = 'promptly'}) {
    _createUnique();
  }

  /// Get temp directory path
  String get path => Directory.systemTemp.path;

  /// Get temp directory name
  final String folderName;

  /// Get date file name
  String get date {
    final now = DateTime.now().toUtc();
    return '${now.year}-${now.month}-${now.day}';
  }

  /// Get current log file in temp directory
  File get logFile => File(p.join(path, folderName, '$date.log'));

  /// Get unique temp directory
  void _createUnique() {
    if (!logFile.existsSync()) {
      logFile.createSync(recursive: true);
    }
  }

  /// Clean up temp directory
  void cleanup(Directory dir) {
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }
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
    this.subcommand,
    this.durationInMilliseconds,
  }) {
    this.dateTime = dateTime ?? DateTime.now().toUtc();
  }
  late final DateTime dateTime;
  final LogLevel level;
  final String message;
  final String? command;
  final String? subcommand;
  final int? durationInMilliseconds;
  String get duration {
    if (durationInMilliseconds == null) return '';
    if (durationInMilliseconds == 0) return '';
    return '[${durationInMilliseconds}ms] ';
  }

  String get commandName {
    if (command == null) {
      return '';
    }
    return '[$command] ';
  }

  String get subcommandName {
    if (subcommand == null) {
      return '';
    }
    return '[$subcommand] ';
  }

  String get formatedTime => '${DateFormat('Hms.SSS').format(dateTime)} ';
  String withTime() => '$formatedTime$duration$commandName$subcommandName$message';
  String withoutTime() => '$duration$commandName$subcommandName$message';

  @override
  int get hashCode => Object.hash(
        dateTime,
        level,
        message,
        command,
        subcommand,
        durationInMilliseconds,
      );

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LogItem &&
          runtimeType == other.runtimeType &&
          dateTime == other.dateTime &&
          level == other.level &&
          message == other.message &&
          command == other.command &&
          subcommand == other.subcommand &&
          durationInMilliseconds == other.durationInMilliseconds;
}

/// A simple logger that logs to stdout.
class Logger {
  static final Logger _instance = Logger._internal();
  static final FileLogger fileLogger = FileLogger(filePath: 'log.txt');

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
  set level(LogLevel level) {
    _level = level;
  }

  // ignore: unnecessary_getters_setters
  LogLevel get level => _level;

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
  void log(
    String message, {
    LogLevel level = LogLevel.info,
    String? commandName,
  }) {
    if (_level.index >= level.index) {
      _printer(
        LogItem(
          dateTime: DateTime.now().toUtc(),
          level: level,
          message: message,
          command: commandName,
        ),
      );
    }
  }

  void verbose(String message) => log(message, level: LogLevel.verbose);

  /// Log an info message.
  void info(String message) => log(message);

  /// Log a warning message.
  void warning(String message) => log(message, level: LogLevel.warning);

  /// Log an error message.
  void error(String message) => log(message, level: LogLevel.error);

  /// Log a fatal message.
  void fatal(String message) => log(message, level: LogLevel.fatal);

  LogItem trace(String message, {String? commandName, String? subcommand, int? durationInMilliseconds}) => _delayed(
        LogItem(
          level: LogLevel.verbose,
          message: message,
          command: commandName,
          subcommand: subcommand,
          durationInMilliseconds: durationInMilliseconds,
        ),
      );

  /// Logs a message with a delay.
  ///
  /// The message will be logged at the specified [level], which defaults to
  /// [LogLevel.info].
  ///
  /// [message] The message to be logged.
  /// [level] The level at which the message should be logged. Defaults to
  /// [LogLevel.info].
  LogItem _delayed(LogItem item) {
    if (_queue.length > _maxQueueSize) {
      _queue.removeFirst();
    }
    _queue.add(item);
    return item;
  }

  /// Flushes the logger, ensuring that all buffered log messages are written out.
  void flush({bool withTime = true}) {
    final logFile = TempDirectory().logFile;
    final sink = logFile.openWrite(mode: FileMode.append);
    _printer(
      LogItem(
        level: LogLevel.info,
        message: 'Trace items [${_queue.length}]... at ${logFile.path}',
      ),
    );
    for (final item in _queue) {
      sink.writeln((withTime ? item.withTime() : item.withoutTime()).removeAnsi());
      _printer(item);
    }
    sink.flush();
    _queue.clear();
  }
}
