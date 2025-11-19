/// Trie data structure for efficient word lookup
class TrieNode {
  final Map<String, TrieNode> children = {};
  bool isEnd = false;

  /// Insert a word into the trie
  void insert(String word) {
    TrieNode node = this;
    for (int i = 0; i < word.length; i++) {
      final char = word[i];
      if (!node.children.containsKey(char)) {
        node.children[char] = TrieNode();
      }
      node = node.children[char]!;
    }
    node.isEnd = true;
  }

  /// Search for a word in the trie
  bool search(String word) {
    TrieNode node = this;
    for (int i = 0; i < word.length; i++) {
      final char = word[i];
      if (!node.children.containsKey(char)) {
        return false;
      }
      node = node.children[char]!;
    }
    return node.isEnd;
  }

  /// Get the number of words in the trie
  int get wordCount {
    int count = isEnd ? 1 : 0;
    for (final child in children.values) {
      count += child.wordCount;
    }
    return count;
  }
}

