extension StringBufferX on StringBuffer {
  void writeLine(String line) {
    write(line);
    write('\n');
  }

  void newLine() {
    write('\n');
  }
}
