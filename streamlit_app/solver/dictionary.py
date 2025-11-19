"""Dictionary loading and management"""

import re
from .trie import TrieNode
from .word_generator import generate_plural, generate_verb_forms


def load_dictionary(dictionary_path: str) -> tuple[TrieNode, int]:
    """
    Load WordNet dictionary and build trie

    Returns:
        Tuple of (trie, word_count)
    """
    trie = TrieNode()
    word_count = 0

    # WordNet format: s(synset_id,w_num,'word',pos,sense_num,tag_count).
    pattern = re.compile(r"s\(\d+,\d+,'([^']+)',([nvasr]),\d+,\d+\)\.?")

    with open(dictionary_path, "r", encoding="utf-8") as f:
        for line in f:
            match = pattern.match(line.strip())
            if not match:
                continue

            word = match.group(1).strip().lower()
            part_of_speech = match.group(2)

            # Skip capitalized words (proper nouns)
            if match.group(1)[0].isupper():
                continue

            # Insert base word
            trie.insert(word)
            word_count += 1

            # Generate and insert plural forms for nouns
            if part_of_speech == "n":
                plural = generate_plural(word)
                trie.insert(plural)
                word_count += 1

            # Generate and insert verb forms
            if part_of_speech == "v":
                past, participle = generate_verb_forms(word)
                trie.insert(past)
                trie.insert(participle)
                word_count += 2

    return trie, word_count
