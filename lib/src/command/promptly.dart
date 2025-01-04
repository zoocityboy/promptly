import 'dart:io' as io;

import 'package:promptly/promptly.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/framework/performance_tracer.dart';
import 'package:promptly/src/theme/theme.dart';

class Promptly<T> {
  Promptly._();
  void addCommand(Command<T> command) {
    sl.get<PromptlyRunner<T>>().addCommand(command);
  }

  static Future<Promptly<T>> init<T>(
    String executableName, {
    String? description,
    String? version,
    Theme? theme,
  }) async {
    final console = Console(theme: theme);
    final logger = Logger(printer: consolePrinter);
    final pl = PerformanceTracer(logger: logger);
    final slSpan = pl.startSpan(name: 'Promptly.init');
    sl
      ..registerSingleton<Console>(console)
      ..registerSingleton<Logger>(logger)
      ..registerSingleton<PerformanceTracer>(pl)
      ..registerSingleton<PromptlyRunner<T>>(
        PromptlyRunner<T>(
          executableName,
          description ?? '',
          version: version ?? '',
          theme: theme,
        ),
      );
    await sl.allReady();
    pl.endSpan(slSpan);
    return Promptly<T>._();
  }

  X get<X extends Object>() {
    return sl.get<X>();
  }

  Future<dynamic> flushThenExit(T? status) {
    final logger = get<Logger>();
    logger.info('flushThenExit: $status');
    return Future.wait<void>([io.stdout.close(), io.stderr.close()]).then<void>(
      (_) {
        logger.flush();
        logger.info('Exit: $status ');
        if (status is int) {
          io.exit(status);
        }
        io.exit(0);
      },
      onError: (e) {
        logger.error('Error flushing stdout/stderr: $e');
        io.exit(1);
      },
    );
  }

  Future<dynamic> run(
    Iterable<String> args,
  ) async {
    final runner = get<PromptlyRunner<T>>();
    try {
      await flushThenExit(await runner.run(args));
    } on UsageException catch (_) {
      runner.printUsage();
      return null;
    } on Exception catch (e) {
      console.error(e.toString());
      return 64;
    } catch (e) {
      console.error(e.toString());
      return null;
    }
  }
}
