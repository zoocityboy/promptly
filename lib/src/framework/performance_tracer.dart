import 'dart:convert';

import 'package:promptly/src/framework/framework.dart';

/// create pretty print json
/// create a function for render json as pretty print
String prettyJson(Map json) {
  const encoder = JsonEncoder.withIndent('  ');
  return encoder.convert(json);
}

/// Reprezentuje jeden měřící span (úsek)
class TraceSpan {
  final String name;
  final DateTime startTime;
  DateTime? endTime;
  Map<String, dynamic> attributes = {};

  TraceSpan(this.name) : startTime = DateTime.now();

  /// Ukončí span a zaznamená čas
  void end() {
    endTime = DateTime.now();
  }

  /// Vrátí dobu trvání spanu v milisekundách
  Duration get duration {
    if (endTime == null) {
      throw StateError('Span $name ještě nebyl ukončen.');
    }
    return endTime!.difference(startTime);
  }

  /// Přidá atribut ke spanu
  void addAttribute(String key, dynamic value) {
    attributes[key] = value;
  }

  /// Vrátí informace o spanu
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'durationMs': duration.inMilliseconds,
      'attributes': attributes,
    };
  }
}

/// Hlavní třída pro měření výkonu
class PerformanceTracer {
  final List<TraceSpan> _spans = [];
  final Logger logger;

  PerformanceTracer({required this.logger});
  String get createName {
    final date2ListInt = utf8.encoder.convert(DateTime.now().toIso8601String());
    return base64Encode(date2ListInt);
  }

  /// Vytvoří nový span
  TraceSpan startSpan({String? name, Map<String, dynamic> attributes = const {}}) {
    final name0 = name ?? createName;
    final span = TraceSpan(name0);
    span.attributes = attributes;
    _spans.add(span);
    logger.info('Start span: $name', delayed: true);
    return span;
  }

  /// Ukončí span a zaznamená jeho data
  void endSpan(TraceSpan span) {
    span.end();
    logger.info(
      '''
Finish span: ${span.name}, duration: ${span.duration.inMilliseconds} ms
${prettyJson(span.toMap())}
''',
      delayed: true,
    );
  }

  /// Vrátí všechny zaznamenané spany
  List<Map<String, dynamic>> getSpans() {
    return _spans.map((span) => span.toMap()).toList();
  }
}
