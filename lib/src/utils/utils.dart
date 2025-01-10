import 'dart:async' show StreamSubscription;
import 'dart:io' show ProcessSignal, exit;
import 'dart:math' show max, min;

import 'package:promptly/src/framework/framework.dart' show Context;

/// Catch sigint and reset to terminal defaults before exit.
StreamSubscription<ProcessSignal> handleSigint() {
  int sigints = 0;
  return ProcessSignal.sigint.watch().listen((event) async {
    if (++sigints >= 1) {
      Context.reset();
      exit(1);
    }
  });
}

class StringSimilarity {
  /// Calculate Levenshtein distance between two strings
  static int levenshteinDistance(String a, String b) {
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    List<int> prev = List.generate(b.length + 1, (i) => i);
    final List<int> curr = List<int>.filled(b.length + 1, 0);

    for (int i = 0; i < a.length; i++) {
      curr[0] = i + 1;
      for (int j = 0; j < b.length; j++) {
        final int cost = (a[i] == b[j]) ? 0 : 1;
        curr[j + 1] = [
          curr[j] + 1,
          prev[j + 1] + 1,
          prev[j] + cost,
        ].reduce((min, val) => val < min ? val : min);
      }
      prev = List.from(curr);
    }
    return curr[b.length];
  }

  /// Find similar strings in list
  static List<List<String>> findSimilar(
    List<String> words, {
    double threshold = 0.8,
  }) {
    final groups = <List<String>>[];
    final used = <int>{};

    for (var i = 0; i < words.length; i++) {
      if (used.contains(i)) continue;

      final group = <String>[words[i]];
      used.add(i);

      for (var j = i + 1; j < words.length; j++) {
        if (used.contains(j)) continue;

        final distance = levenshteinDistance(words[i], words[j]);
        final maxLength = [words[i].length, words[j].length].reduce(max);
        final similarity = 1 - (distance / maxLength);

        if (similarity >= threshold) {
          group.add(words[j]);
          used.add(j);
        }
      }

      if (group.length > 1) {
        groups.add(group);
      }
    }

    return groups;
  }
}
