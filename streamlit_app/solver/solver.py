"""Quartile puzzle solver.

This module provides the core puzzle-solving functionality for the
Apple Quartile Solver. It generates all possible word combinations
from puzzle tiles and validates them against a dictionary trie.
"""

from itertools import combinations, permutations
from typing import List, Set, Tuple

from .trie import TrieNode


def solve_puzzle(tiles: List[str], trie: TrieNode) -> Tuple[List[str], int]:
    """Solve a Quartile puzzle by finding all valid words from tile combinations.

    Generates all permutations of 1-4 tile combinations and checks each
    against the dictionary trie to find valid English words.

    Args:
        tiles: List of puzzle tiles (letter combinations).
        trie: Dictionary trie containing valid words.

    Returns:
        Tuple containing:
            - List[str]: Sorted list of valid words found
            - int: Total number of permutations checked
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
    """Parse puzzle input text into a list of tiles.

    Splits the input text by newlines, strips whitespace, and converts
    to lowercase.

    Args:
        text: Raw puzzle input text with tiles separated by newlines.

    Returns:
        List of cleaned tile strings.
    """
    return [line.strip().lower() for line in text.strip().split("\n") if line.strip()]


def validate_puzzle(tiles: List[str]) -> Tuple[bool, str]:
    """Validate puzzle format and constraints.

    Checks that the puzzle has a valid number of tiles and that each
    tile meets length requirements.

    Args:
        tiles: List of puzzle tiles to validate.

    Returns:
        Tuple containing:
            - bool: True if the puzzle is valid, False otherwise
            - str: Error message if invalid, empty string if valid
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
