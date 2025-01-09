import 'package:promptly/promptly.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/string_buffer.dart';
import 'package:wcwidth/wcwidth.dart';

class Header extends TypeComponent<String> {
  Header({
    required this.title,
    String? prefix,
    this.message,
    Context? context,
  })  : theme = Theme.defaultTheme,
        _context = context ?? Context(),
        prefix = prefix ?? Theme.defaultTheme.symbols.header;

  Header.withTheme({
    required this.theme,
    String? prefix,
    required this.title,
    this.message,
    Context? context,
  })  : prefix = prefix ?? theme.symbols.header,
        _context = context ?? Context();

  final Theme theme;
  final String title;
  final String prefix;
  final String? message;
  final Context _context;

  String get _formated {
    final titleBuffer = StringBuffer(theme.prefixHeaderLine(''))
      ..write(theme.colors.success(' $title ').inverse())
      ..write(' ');
    final currentLng = titleBuffer.toString().wcwidth();

    ///
    final buffer = StringBuffer()..write(titleBuffer.toString());
    final maxLength = _context.windowWidth - buffer.length;
    final msg = (message ?? '').replaceAll('\n', '');
    if (msg.length >= maxLength - currentLng) {
      buffer.newLine();
      final lines = wrapText(msg, length: maxLength - currentLng, hangingIndent: 0).split('\n');
      buffer.prefixLine();
      for (final line in lines) {
        buffer.writeln(console.theme.prefixLine(console.theme.colors.hint(line)));
      }
    } else {
      buffer.write(console.theme.colors.hint(msg));
    }

    buffer
      ..newLine()
      ..prefixLine()
      ..newLine();
    return buffer.toString();
  }

  @override
  void render({Context? context}) {
    (context ?? _context).write(_formated);
  }

  @override
  String interact() => _formated;
}
