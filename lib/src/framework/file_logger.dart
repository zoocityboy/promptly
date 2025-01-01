import 'dart:io';

/// FileLogger pro ukládání logů do souboru
class FileLogger {
  final String filePath;
  late final IOSink _sink;

  FileLogger({required this.filePath}) {
    final file = File(filePath);
    _sink = file.openWrite(mode: FileMode.append);
    _log('--- Nová relace logování ---');
  }

  /// Zaznamená obecnou zprávu do souboru
  void log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    _sink.writeln('[$timestamp] $message');
    _sink.flush();
  }

  /// Zaznamená konkrétní span do souboru
  void logSpan(Map<String, dynamic> span) {
    final timestamp = DateTime.now().toIso8601String();
    _sink.writeln(
        '[$timestamp] Span: ${span['name']}, Duration: ${span['durationMs']}ms, Attributes: ${span['attributes']}');
    _sink.flush();
  }

  /// Interní metoda pro počáteční log
  void _log(String message) {
    final timestamp = DateTime.now().toIso8601String();
    _sink.writeln('[$timestamp] $message');
  }

  /// Zavře souborový stream
  Future<void> close() async {
    await _sink.flush();
    await _sink.close();
  }
}
