"""Tests for the Quartile solver package"""

import pytest
import tempfile
import os
from solver import (
    TrieNode,
    load_dictionary,
    solve_puzzle,
    parse_puzzle_input,
    validate_puzzle,
    generate_plural,
    generate_verb_forms,
)


class TestTrieNode:
    """Test cases for TrieNode class"""

    def test_insert_and_search(self):
        """Test basic insert and search operations"""
        trie = TrieNode()
        trie.insert("hello")
        assert trie.search("hello")
        assert not trie.search("hell")
        assert not trie.search("helloworld")

    def test_empty_string(self):
        """Test handling of empty string"""
        trie = TrieNode()
        trie.insert("")
        assert trie.search("")

    def test_unicode_characters(self):
        """Test handling of unicode characters"""
        trie = TrieNode()
        trie.insert("café")
        assert trie.search("café")
        assert not trie.search("cafe")

    def test_word_count(self):
        """Test word count functionality"""
        trie = TrieNode()
        trie.insert("cat")
        trie.insert("dog")
        trie.insert("bird")
        assert trie.word_count() == 3

    def test_prefix_not_word(self):
        """Test that prefixes are not counted as words"""
        trie = TrieNode()
        trie.insert("testing")
        assert not trie.search("test")
        assert trie.search("testing")


class TestDictionaryLoading:
    """Test cases for dictionary loading"""

    def test_load_dictionary(self):
        """Test loading a dictionary file"""
        content = """s(100000001,1,'dog',n,1,6).
s(100000002,1,'cat',n,1,3).
s(100000003,1,'run',v,1,3)."""

        with tempfile.NamedTemporaryFile(mode='w', suffix='.pl', delete=False) as f:
            f.write(content)
            temp_path = f.name

        try:
            trie, word_count = load_dictionary(temp_path)
            assert word_count > 0
            assert trie.search("dog")
            assert trie.search("dogs")  # plural
            assert trie.search("cat")
            assert trie.search("cats")  # plural
            assert trie.search("run")
        finally:
            os.unlink(temp_path)

    def test_skip_capitalized_words(self):
        """Test that capitalized words are skipped"""
        content = """s(100000001,1,'PROPER',n,1,6).
s(100000002,1,'normal',n,1,3)."""

        with tempfile.NamedTemporaryFile(mode='w', suffix='.pl', delete=False) as f:
            f.write(content)
            temp_path = f.name

        try:
            trie, _ = load_dictionary(temp_path)
            assert not trie.search("proper")
            assert not trie.search("PROPER")
            assert trie.search("normal")
        finally:
            os.unlink(temp_path)


class TestSolver:
    """Test cases for puzzle solver"""

    def test_solve_simple_puzzle(self):
        """Test solving a simple puzzle"""
        trie = TrieNode()
        trie.insert("cat")
        trie.insert("at")
        trie.insert("act")

        tiles = ["c", "a", "t"]
        words, perms_checked = solve_puzzle(tiles, trie)

        assert "cat" in words
        assert "at" in words
        assert "act" in words
        assert perms_checked > 0

    def test_parse_puzzle_input(self):
        """Test parsing puzzle input"""
        input_text = "dis\ncre\nti\non"
        tiles = parse_puzzle_input(input_text)
        assert tiles == ["dis", "cre", "ti", "on"]

    def test_parse_puzzle_input_with_whitespace(self):
        """Test parsing with extra whitespace"""
        input_text = "  dis  \n\n  cre  \n  ti  "
        tiles = parse_puzzle_input(input_text)
        assert tiles == ["dis", "cre", "ti"]

    def test_validate_puzzle_empty(self):
        """Test validation of empty puzzle"""
        is_valid, error = validate_puzzle([])
        assert not is_valid
        assert "No tiles" in error

    def test_validate_puzzle_too_many_tiles(self):
        """Test validation of puzzle with too many tiles"""
        tiles = ["tile"] * 21
        is_valid, error = validate_puzzle(tiles)
        assert not is_valid
        assert "Too many" in error

    def test_validate_puzzle_tile_too_long(self):
        """Test validation of tile that's too long"""
        tiles = ["a" * 11]
        is_valid, error = validate_puzzle(tiles)
        assert not is_valid
        assert "too long" in error

    def test_validate_puzzle_valid(self):
        """Test validation of valid puzzle"""
        tiles = ["dis", "cre", "ti", "on"]
        is_valid, error = validate_puzzle(tiles)
        assert is_valid
        assert error == ""


class TestWordGeneration:
    """Test cases for word form generation"""

    def test_generate_plural_regular(self):
        """Test regular plural generation"""
        assert generate_plural("cat") == "cats"
        assert generate_plural("dog") == "dogs"

    def test_generate_plural_special_endings(self):
        """Test plural generation for special endings"""
        assert generate_plural("box") == "boxes"
        assert generate_plural("church") == "churches"
        assert generate_plural("dish") == "dishes"
        assert generate_plural("buzz") == "buzzes"

    def test_generate_plural_y_ending(self):
        """Test plural generation for words ending in y"""
        assert generate_plural("fly") == "flies"
        assert generate_plural("boy") == "boys"  # vowel before y
        assert generate_plural("key") == "keys"  # vowel before y

    def test_generate_verb_forms(self):
        """Test verb form generation"""
        past, participle = generate_verb_forms("walk")
        assert past == "walked"
        assert participle == "walking"

        past, participle = generate_verb_forms("make")
        assert past == "maked"
        assert participle == "making"

