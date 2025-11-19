"""Quartile puzzle solver"""

from itertools import combinations, permutations
from typing import List, Set
from .trie import TrieNode


def solve_puzzle(tiles: List[str], trie: TrieNode) -> tuple[List[str], int]:
    """
    Solve a Quartile puzzle

    Args:
        tiles: List of puzzle tiles
        trie: Dictionary trie

    Returns:
        Tuple of (valid_words, permutations_checked)
    """
    valid_words: Set[str] = set()
    permutations_checked = 0

    # Generate all permutations for combinations of 1-4 tiles
    for r in range(1, min(5, len(tiles) + 1)):
        for combo in combinations(tiles, r):
            for perm in permutations(combo):
                word = "".join(perm)
                permutations_checked += 1

                if trie.search(word):
                    valid_words.add(word)

    return sorted(valid_words), permutations_checked


def parse_puzzle_input(text: str) -> List[str]:
    """Parse puzzle input text into list of tiles"""
    return [line.strip().lower() for line in text.strip().split("\n") if line.strip()]


def validate_puzzle(tiles: List[str]) -> tuple[bool, str]:
    """
    Validate puzzle format

    Returns:
        Tuple of (is_valid, error_message)
    """
    if not tiles:
        return False, "No tiles entered"

    if len(tiles) > 20:
        return False, "Too many tiles (maximum 20)"

    for tile in tiles:
        if not tile:
            return False, "Empty tile found"
        if len(tile) > 10:
            return False, f"Tile '{tile}' is too long (maximum 10 characters)"

    return True, ""
