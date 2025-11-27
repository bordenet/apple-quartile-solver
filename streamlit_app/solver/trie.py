"""Trie data structure for efficient word lookup.

This module provides a trie (prefix tree) implementation optimized for
dictionary word lookups. The trie allows O(m) time complexity for both
insertion and search operations, where m is the length of the word.
"""

from typing import Dict


class TrieNode:
    """A node in a trie data structure for efficient word storage and lookup.

    Each node contains a dictionary of child nodes (keyed by character) and
    a flag indicating whether the node represents the end of a valid word.

    Attributes:
        children: Dictionary mapping characters to child TrieNode instances.
        is_end: Boolean flag indicating if this node marks the end of a word.
    """

    def __init__(self) -> None:
        """Initialize a new TrieNode with empty children and is_end=False."""
        self.children: Dict[str, "TrieNode"] = {}
        self.is_end: bool = False

    def insert(self, word: str) -> None:
        """Insert a word into the trie.

        Args:
            word: The word to insert into the trie.
        """
        node = self
        for char in word:
            if char not in node.children:
                node.children[char] = TrieNode()
            node = node.children[char]
        node.is_end = True

    def search(self, word: str) -> bool:
        """Search for a word in the trie.

        Args:
            word: The word to search for.

        Returns:
            True if the word exists in the trie, False otherwise.
        """
        node = self
        for char in word:
            if char not in node.children:
                return False
            node = node.children[char]
        return node.is_end

    def word_count(self) -> int:
        """Count the total number of words stored in the trie.

        Returns:
            The total count of words in the trie rooted at this node.
        """
        count = 1 if self.is_end else 0
        for child in self.children.values():
            count += child.word_count()
        return count
