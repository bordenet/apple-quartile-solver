import 'package:flutter/services.dart';
import '../models/trie.dart';
import 'word_generator.dart';

/// Service for loading and managing the WordNet dictionary
class DictionaryService {
  TrieNode? _trie;
  int _wordCount = 0;
  bool _isLoaded = false;

  bool get isLoaded => _isLoaded;
  int get wordCount => _wordCount;
  TrieNode? get trie => _trie;

  /// Load dictionary from assets
  Future<void> loadDictionary() async {
    if (_isLoaded) return;

    _trie = TrieNode();
    _wordCount = 0;

    try {
      final content = await rootBundle.loadString('assets/wn_s.pl');
      final lines = content.split('\n');

      // WordNet format: s(synset_id,w_num,'word',pos,sense_num,tag_count).
      final regex = RegExp(r"s\(\d+,\d+,'([^']+)',([nvasr]),\d+,\d+\)\.?");

      for (final line in lines) {
        final match = regex.firstMatch(line);
        if (match == null) continue;

        final word = match.group(1)?.trim().toLowerCase();
        final partOfSpeech = match.group(2);

        if (word == null || word.isEmpty) continue;

        // Skip capitalized words (proper nouns)
        if (match.group(1)![0].toUpperCase() == match.group(1)![0]) {
          continue;
        }

        // Insert base word
        _trie!.insert(word);
        _wordCount++;

        // Generate and insert plural forms for nouns
        if (partOfSpeech == 'n') {
          final plural = WordGenerator.generatePlural(word);
          _trie!.insert(plural);
          _wordCount++;
        }

        // Generate and insert verb forms
        if (partOfSpeech == 'v') {
          final forms = WordGenerator.generateVerbForms(word);
          _trie!.insert(forms['past']!);
          _trie!.insert(forms['participle']!);
          _wordCount += 2;
        }
      }

      _isLoaded = true;
    } catch (e) {
      throw Exception('Failed to load dictionary: $e');
    }
  }
}
