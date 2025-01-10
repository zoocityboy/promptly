import 'package:promptly/promptly.dart';
import 'package:promptly/src/framework/framework.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:promptly/src/utils/string_buffer.dart';
import 'package:wcwidth/wcwidth.dart';

/// A `Header` component that extends `TypeComponent<String>`.
///
/// This component is used to render a header with a title, optional prefix,
/// and an optional message. It also supports theming and context management.
///
/// The `Header` class has two constructors:
///
/// - `Header`: Requires a `title` and optionally accepts a `prefix`, `message`,
///   and `context`. It uses the default theme if no theme is provided.
/// - `Header.withTheme`: Requires a `theme` and `title`, and optionally accepts
///   a `prefix`, `message`, and `context`.
///
/// Properties:
///
/// - `theme`: The theme used for styling the header.
/// - `title`: The title of the header.
/// - `prefix`: The prefix symbol for the header.
/// - `message`: An optional message to be displayed in the header.
/// - `_context`: The context in which the header is rendered.
///
/// Methods:
///
/// - `render`: Renders the header using the provided or default context.
/// - `interact`: Returns the formatted header as a string.
///
/// Private getters:
///
/// - `_formated`: Returns the formatted header string with the title, message,
///   and appropriate styling based on the theme and context.
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

class Section extends TypeComponent<String> {
  Section({
    required this.title,
    String? prefix,
    this.message,
    Context? context,
  })  : theme = Theme.defaultTheme,
        _context = context ?? Context(),
        prefix = prefix ?? Theme.defaultTheme.symbols.header;

  Section.withTheme({
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
      ..write(theme.colors.text(' $title ').inverse())
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
