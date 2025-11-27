"""Generate word forms (plurals, verb conjugations).

This module provides functions for generating common English word forms
from base words, including plural forms for nouns and verb conjugations
(past tense and present participle).
"""

from typing import Tuple


def generate_plural(word: str) -> str:
    """Generate the plural form of a noun using basic English rules.

    Applies common English pluralization rules:
    - Words ending in s, sh, ch, x, z: add 'es'
    - Words ending in consonant + y: change y to 'ies'
    - All other words: add 's'

    Args:
        word: The singular noun to pluralize.

    Returns:
        The plural form of the word.
    """
    if word.endswith(("s", "sh", "ch", "x", "z")):
        return word + "es"

    if word.endswith("y") and len(word) > 1 and word[-2] not in "aeiou":
        return word[:-1] + "ies"

    return word + "s"


def generate_verb_forms(word: str) -> Tuple[str, str]:
    """Generate past tense and present participle forms of a verb.

    Applies basic English verb conjugation rules:
    - Past tense: add 'd' if ends in 'e', otherwise add 'ed'
    - Present participle: remove 'e' if present, then add 'ing'

    Args:
        word: The base form of the verb.

    Returns:
        Tuple containing:
            - str: Past tense form (e.g., 'walked', 'loved')
            - str: Present participle form (e.g., 'walking', 'loving')
    """
    # Past tense
    if word.endswith("e"):
        past = word + "d"
    else:
        past = word + "ed"

    # Present participle
    if word.endswith("e") and len(word) > 1:
        participle = word[:-1] + "ing"
    else:
        participle = word + "ing"

    return past, participle
