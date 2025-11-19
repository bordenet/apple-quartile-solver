/// Generates word forms (plurals, verb conjugations)
class WordGenerator {
  /// Generate plural form of a noun
  static String generatePlural(String word) {
    if (word.endsWith('s') ||
        word.endsWith('sh') ||
        word.endsWith('ch') ||
        word.endsWith('x') ||
        word.endsWith('z')) {
      return word + 'es';
    }

    if (word.endsWith('y') &&
        word.length > 1 &&
        !'aeiou'.contains(word[word.length - 2])) {
      return word.substring(0, word.length - 1) + 'ies';
    }

    return word + 's';
  }

  /// Generate past tense and present participle forms of a verb
  static Map<String, String> generateVerbForms(String word) {
    String past;
    String participle;

    // Past tense
    if (word.endsWith('e')) {
      past = word + 'd';
    } else {
      past = word + 'ed';
    }

    // Present participle
    if (word.endsWith('e') && word.length > 1) {
      participle = word.substring(0, word.length - 1) + 'ing';
    } else {
      participle = word + 'ing';
    }

    return {'past': past, 'participle': participle};
  }
}

