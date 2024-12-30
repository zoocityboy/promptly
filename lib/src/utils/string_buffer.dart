extension StringBufferX on StringBuffer {
  void writeLine(String line) {
    write(line);
    write('\n');
  }

  void newLine() {
    write('\n');
  }
}

typedef LinkData = ({Uri uri, String? message});

extension LinkX on LinkData {
  String link() {
    const leading = '\x1B]8;;';
    const trailing = '\x1B\\';

    return '$leading$uri$trailing${message ?? uri}$leading$trailing';
  }
}
