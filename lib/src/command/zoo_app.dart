import 'dart:io' as io;

import 'package:promptly/promptly.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/framework/performance_tracer.dart';
import 'package:promptly/src/theme/theme.dart';

class Promptly<T> {
  Promptly._();
  void addCommand(Command<T> command) {
    io.stdout.writeln('Add command: ${command.name} ${sl.hashCode}');
    sl.get<CommandRunner<T>>().addCommand(command);
  }

  static Future<Promptly<T>> init<T>(
    String executableName, {
    String? description,
    String? version,
    Theme? theme,
  }) async {
    sl
      ..registerSingleton<Console>(Console(theme: theme))
      ..registerSingleton<Logger>(
        Logger(
          printer: (level, value) => sl.get<Console>().style(
                value,
                prefix: (console) => console.theme.colors.prefix(console.theme.symbols.vLine),
              ),
        ),
      )
      ..registerSingleton<PerformanceTracer>(PerformanceTracer(logger: sl.get<Logger>()))
      ..registerSingleton<CommandRunner<T>>(
        CommandRunner<T>(
          executableName,
          description ?? '',
          version: version ?? '',
          theme: theme,
        ),
      );
    await sl.allReady();
    return Promptly<T>._();
  }

  X get<X extends Object>() {
    io.stdout.writeln('get<$X>:  ${sl.hashCode}');
    return sl.get<X>();
  }

  Future<dynamic> flushThenExit(T? status) {
    return Future.wait<void>([io.stdout.close(), io.stderr.close()]).then<void>((_) {
      get<Logger>().flush();
      if (status is int) {
        io.exit(status);
      }
      io.exit(0);
    });
  }

  Future<dynamic> run(
    Iterable<String> args,
  ) async {
    final runner = get<CommandRunner<T>>();
    try {
      await flushThenExit(await runner.run(args));
    } on UsageException catch (e) {
      runner.printUsage();
      return null;
    } on Exception catch (e) {
      return 64;
    } catch (e) {
      return null;
    }
  }
}
