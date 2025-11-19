import 'package:flutter/foundation.dart';
import '../models/puzzle.dart';
import '../models/solver_result.dart';
import '../services/dictionary_service.dart';
import '../services/solver_service.dart';

enum SortOrder { original, alphabetical, byLength }

/// Application state management
class AppState extends ChangeNotifier {
  final DictionaryService _dictionaryService = DictionaryService();
  SolverService? _solverService;

  bool _isDictionaryLoaded = false;
  bool _isProcessing = false;
  String _currentInput = '';
  SolverResult? _currentResult;
  SortOrder _sortOrder = SortOrder.original;
  String? _error;

  bool get isDictionaryLoaded => _isDictionaryLoaded;
  bool get isProcessing => _isProcessing;
  String get currentInput => _currentInput;
  SolverResult? get currentResult => _currentResult;
  SortOrder get sortOrder => _sortOrder;
  String? get error => _error;
  int get dictionaryWordCount => _dictionaryService.wordCount;

  /// Get sorted words based on current sort order
  List<String> get sortedWords {
    if (_currentResult == null) return [];

    switch (_sortOrder) {
      case SortOrder.alphabetical:
        return _currentResult!.sortedAlphabetically();
      case SortOrder.byLength:
        return _currentResult!.sortedByLength();
      case SortOrder.original:
      default:
        return _currentResult!.words;
    }
  }

  /// Load dictionary on app start
  Future<void> loadDictionary() async {
    try {
      _error = null;
      await _dictionaryService.loadDictionary();
      _solverService = SolverService(_dictionaryService.trie!);
      _isDictionaryLoaded = true;
      notifyListeners();
    } catch (e) {
      _error = 'Failed to load dictionary: $e';
      notifyListeners();
    }
  }

  /// Update puzzle input
  void updateInput(String input) {
    _currentInput = input;
    _error = null;
    notifyListeners();
  }

  /// Solve the current puzzle
  Future<void> solvePuzzle() async {
    if (!_isDictionaryLoaded || _solverService == null) {
      _error = 'Dictionary not loaded';
      notifyListeners();
      return;
    }

    try {
      _isProcessing = true;
      _error = null;
      notifyListeners();

      final puzzle = Puzzle.fromText(_currentInput);

      if (!puzzle.isValid()) {
        _error = 'Invalid puzzle: must have 1-20 tiles';
        _isProcessing = false;
        notifyListeners();
        return;
      }

      _currentResult = await _solverService!.solve(puzzle);
      _isProcessing = false;
      notifyListeners();
    } catch (e) {
      _error = 'Error solving puzzle: $e';
      _isProcessing = false;
      notifyListeners();
    }
  }

  /// Clear current puzzle and results
  void clearPuzzle() {
    _currentInput = '';
    _currentResult = null;
    _error = null;
    notifyListeners();
  }

  /// Load a sample puzzle
  void loadSample(int sampleNumber) {
    final samples = {
      1: 'dis\ncre\nti\non\nuns\ncra\nmb\nles\norn\nit\nhol\nogy\npro\nve\nrb\nial\nga\nte\nkee\nping',
      2: 'per\niwi\nnk\nle\nju\ndgm\nent\nal\ntoa\nst\nmas\nter\nsy\nmpa\nthi\nzed\nspli\nnt\neri\nng',
      3: 'ma\npur\ncha\nbib\nwi\nrshm\npor\nnn\nlio\nse\nall\nted\neli\nph\ncra\now\nly\nng\nile\ncked',
      4: 'hyd\ngra\nal\nsc\nhori\nran\nss\nto\nand\nzo\nge\nroo\nget\nali\nnta\nas\nts\nher\nzed\nlly',
      5: 'et\nci\nway\nve\nma\nent\nsa\nrcum\ning\nnts\nomp\nmes\npas\nriz\nme\nce\ninc\npea\nge\nker',
    };

    _currentInput = samples[sampleNumber] ?? '';
    _currentResult = null;
    _error = null;
    notifyListeners();
  }

  /// Change sort order
  void setSortOrder(SortOrder order) {
    _sortOrder = order;
    notifyListeners();
  }
}

