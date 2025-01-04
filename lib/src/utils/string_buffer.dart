import 'package:promptly/src/console.dart';
import 'package:promptly_ansi/theme/theme.dart';

extension StringBufferX on StringBuffer {
  void verticalLine() {
    this
      ..write(console.theme.prefixLine(''))
      ..write('\n');
  }

  void writeLine(String line) {
    this.write(line);
    this.write('\n');
  }

  void newLine() {
    this.write('\n');
  }
}

class LinkData {
  const LinkData({required this.uri, this.message});
  final Uri uri;
  final String? message;

  String link() {
    const leading = '\x1B]8;;';
    const trailing = '\x1B\\';

    return '$leading$uri$trailing${message ?? uri}$leading$trailing';
  }
}
