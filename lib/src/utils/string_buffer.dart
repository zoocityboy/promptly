import 'package:promptly/src/console.dart';
import 'package:promptly/src/theme/theme.dart';
import 'package:tint/tint.dart';

/// Extension on [StringBuffer] to provide additional utility methods.
extension StringBufferX on StringBuffer {
  /// Writes a prefix line using the console theme.
  void prefixLine() {
    this.write(console.theme.prefixLine(''));
  }

  void section(String title) {
    this
      ..write(console.theme.prefixSectionLine(''))
      ..write(console.theme.colors.text(title).inverse())
      ..newLine();
  }

  /// Writes a vertical line using the console theme and adds a newline.
  void verticalLine() {
    this
      ..prefixLine()
      ..newLine();
  }

  /// Writes a line followed by a newline.
  ///
  /// [line] The line to write.
  void writeLine(String line) {
    this.write(line);
    newLine();
  }

  /// Writes a newline.
  void newLine() {
    this.write('\n');
  }

  /// Writes text with a prefix and optional spacing.
  ///
  /// [prefix] The prefix to write before the text.
  /// [text] The text to write.
  /// [spacing] Optional spacing between the prefix and the text.
  void withPrefix(String prefix, String text, {int? spacing, StyleFunction? style}) {
    final spc = spacing ?? console.theme.spacing;
    // this.write((style ?? console.theme.colors.prefix)('$spc'));
    if (spc > 0) {
      this.write(
        (style ?? console.theme.colors.prefix)(prefix.removeAnsi().padRight(spc)),
      );
    }
    this.write(text);
  }

  /// Writes a header line using the console theme.
  ///
  /// [name] The name of the header.
  /// [message] Optional message to include in the header.
  void header(String name, {String? message}) {
    write(console.headerLine(name, message: message));
  }
}

/// Extension on [String] to provide ANSI escape code removal.
extension StringAnsi on String {
  /// Removes ANSI escape codes from the string.
  String removeAnsi() {
    return replaceAll(RegExp(r'\x1B\[[0-9;]*[a-zA-Z]'), '');
  }
}

/// Class representing link data with a URI and an optional message.
class LinkData {
  /// Creates a [LinkData] instance.
  ///
  /// [uri] The URI of the link.
  /// [message] Optional message to display for the link.
  const LinkData({required this.uri, this.message});

  /// The URI of the link.
  final Uri uri;

  /// Optional message to display for the link.
  final String? message;

  /// Generates a clickable link string with ANSI escape codes.
  ///
  /// Returns the formatted link string.
  String link() {
    const leading = '\x1B]8;;';
    const trailing = '\x1B\\';

    return '$leading$uri$trailing${message ?? uri}$leading$trailing';
  }
}
