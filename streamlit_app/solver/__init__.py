"""Quartile solver package.

This package provides the core functionality for solving Apple Quartile puzzles.
It includes a trie-based dictionary, puzzle solving algorithms, and word form
generation utilities.

Modules:
    trie: Trie data structure for efficient word lookup
    dictionary: Dictionary loading and management
    solver: Core puzzle solving functionality
    word_generator: Word form generation (plurals, verb conjugations)
"""

from .dictionary import load_dictionary
from .solver import parse_puzzle_input, solve_puzzle, validate_puzzle
from .trie import TrieNode
from .word_generator import generate_plural, generate_verb_forms

__all__ = [
    "TrieNode",
    "load_dictionary",
    "solve_puzzle",
    "parse_puzzle_input",
    "validate_puzzle",
    "generate_plural",
    "generate_verb_forms",
]
