"""Trie data structure for efficient word lookup"""


class TrieNode:
    """Node in a trie data structure"""

    def __init__(self):
        self.children = {}
        self.is_end = False

    def insert(self, word: str) -> None:
        """Insert a word into the trie"""
        node = self
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.is_end = True

    def search(self, word: str) -> bool:
        """Search for a word in the trie"""
        node = self
        for char in word:
            if char not in node.children:
                return False
            node = node.children[char]
        return node.is_end

    def word_count(self) -> int:
        """Count total words in the trie"""
        count = 1 if self.is_end else 0
        for child in self.children.values():
            count += child.word_count()
        return count

