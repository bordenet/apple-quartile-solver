/// Result from solving a puzzle
class SolverResult {
  final List<String> words;
  final Duration processingTime;
  final int permutationsChecked;

  SolverResult({
    required this.words,
    required this.processingTime,
    required this.permutationsChecked,
  });

  int get wordCount => words.length;

  /// Sort words alphabetically
  List<String> sortedAlphabetically() {
    final sorted = List<String>.from(words);
    sorted.sort();
    return sorted;
  }

  /// Sort words by length (longest first)
  List<String> sortedByLength() {
    final sorted = List<String>.from(words);
    sorted.sort((a, b) {
      final lengthCompare = b.length.compareTo(a.length);
      if (lengthCompare != 0) return lengthCompare;
      return a.compareTo(b);
    });
    return sorted;
  }

  /// Group words by length
  Map<int, List<String>> groupedByLength() {
    final grouped = <int, List<String>>{};
    for (final word in words) {
      grouped.putIfAbsent(word.length, () => []).add(word);
    }
    return grouped;
  }

  /// Get longest word
  String? get longestWord {
    if (words.isEmpty) return null;
    return words.reduce((a, b) => a.length > b.length ? a : b);
  }

  /// Get shortest word
  String? get shortestWord {
    if (words.isEmpty) return null;
    return words.reduce((a, b) => a.length < b.length ? a : b);
  }
}
