import '../models/trie.dart';
import '../models/puzzle.dart';
import '../models/solver_result.dart';

/// Service for solving Quartile puzzles
class SolverService {
  final TrieNode trie;

  SolverService(this.trie);

  /// Solve a puzzle and return all valid words
  Future<SolverResult> solve(Puzzle puzzle) async {
    final startTime = DateTime.now();
    final validWords = <String>{};
    int permutationsChecked = 0;

    // Generate all permutations for combinations of 1-4 tiles
    for (int r = 1; r <= 4 && r <= puzzle.tiles.length; r++) {
      final combinations = _generateCombinations(puzzle.tiles, r);

      for (final combo in combinations) {
        final permutations = _generatePermutations(combo);

        for (final perm in permutations) {
          final word = perm.join('');
          permutationsChecked++;

          if (trie.search(word)) {
            validWords.add(word);
          }
        }
      }
    }

    final processingTime = DateTime.now().difference(startTime);

    return SolverResult(
      words: validWords.toList(),
      processingTime: processingTime,
      permutationsChecked: permutationsChecked,
    );
  }

  /// Generate all combinations of r elements from list
  List<List<String>> _generateCombinations(List<String> list, int r) {
    final results = <List<String>>[];

    void combine(int start, List<String> current) {
      if (current.length == r) {
        results.add(List.from(current));
        return;
      }

      for (int i = start; i < list.length; i++) {
        current.add(list[i]);
        combine(i + 1, current);
        current.removeLast();
      }
    }

    combine(0, []);
    return results;
  }

  /// Generate all permutations of a list
  List<List<String>> _generatePermutations(List<String> list) {
    if (list.isEmpty) return [];
    if (list.length == 1) return [list];

    final results = <List<String>>[];

    for (int i = 0; i < list.length; i++) {
      final current = list[i];
      final remaining = [...list.sublist(0, i), ...list.sublist(i + 1)];
      final subPerms = _generatePermutations(remaining);

      for (final subPerm in subPerms) {
        results.add([current, ...subPerm]);
      }
    }

    return results;
  }
}

