"""Generate word forms (plurals, verb conjugations)"""


def generate_plural(word: str) -> str:
    """Generate plural form of a noun"""
    if word.endswith(("s", "sh", "ch", "x", "z")):
        return word + "es"

    if word.endswith("y") and len(word) > 1 and word[-2] not in "aeiou":
        return word[:-1] + "ies"

    return word + "s"


def generate_verb_forms(word: str) -> tuple[str, str]:
    """Generate past tense and present participle forms of a verb"""
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
