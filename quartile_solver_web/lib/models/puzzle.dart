/// Represents a Quartile puzzle
class Puzzle {
  final List<String> tiles;

  Puzzle(this.tiles);

  /// Create puzzle from text input (one tile per line)
  factory Puzzle.fromText(String text) {
    final tiles = text
        .split('\n')
        .map((line) => line.trim().toLowerCase())
        .where((line) => line.isNotEmpty)
        .toList();
    return Puzzle(tiles);
  }

  /// Validate puzzle format
  bool isValid() {
    if (tiles.isEmpty || tiles.length > 20) return false;
    for (final tile in tiles) {
      if (tile.isEmpty || tile.length > 10) return false;
    }
    return true;
  }

  int get tileCount => tiles.length;

  String toText() => tiles.join('\n');
}

