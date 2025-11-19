# Design Specification: Apple Quartile Solver Web UI

## 1. Architecture

### 1.1 System Architecture
```
┌─────────────────────────────────────────┐
│         Web Browser (Client)            │
├─────────────────────────────────────────┤
│  ┌───────────────────────────────────┐  │
│  │      UI Layer (Flutter/Dart)      │  │
│  ├───────────────────────────────────┤  │
│  │   Business Logic Layer            │  │
│  │   - Trie Implementation           │  │
│  │   - Permutation Generator         │  │
│  │   - Word Form Generator           │  │
│  ├───────────────────────────────────┤  │
│  │   Data Layer                      │  │
│  │   - Dictionary Parser             │  │
│  │   - Local Storage                 │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

### 1.2 Component Hierarchy
```
App
├── DictionaryLoader (Splash/Loading)
└── MainScreen
    ├── AppBar
    ├── PuzzleInputPanel
    │   ├── TileInputField
    │   ├── SamplePuzzleButtons
    │   └── ActionButtons (Solve/Clear)
    ├── ResultsPanel
    │   ├── ResultsHeader (count, sort)
    │   ├── ResultsList
    │   └── ResultsActions (copy, export)
    └── StatusBar
```

## 2. Data Models

### 2.1 Core Classes

#### TrieNode
```dart
class TrieNode {
  Map<String, TrieNode> children;
  bool isEnd;
  
  TrieNode();
  void insert(String word);
  bool search(String word);
}
```

#### Puzzle
```dart
class Puzzle {
  List<String> tiles;
  DateTime? solvedAt;
  
  Puzzle(this.tiles);
  bool isValid();
  int get tileCount;
}
```

#### SolverResult
```dart
class SolverResult {
  List<String> words;
  Duration processingTime;
  int permutationsChecked;
  
  SolverResult({
    required this.words,
    required this.processingTime,
    required this.permutationsChecked,
  });
  
  List<String> sortedByLength();
  List<String> sortedAlphabetically();
  Map<int, List<String>> groupedByLength();
}
```

### 2.2 State Management

#### AppState
```dart
class AppState extends ChangeNotifier {
  // Dictionary state
  bool isDictionaryLoaded = false;
  int dictionaryWordCount = 0;
  
  // Puzzle state
  List<String> currentTiles = [];
  
  // Results state
  SolverResult? currentResult;
  bool isProcessing = false;
  
  // UI state
  SortOrder sortOrder = SortOrder.default;
  
  // Methods
  Future<void> loadDictionary();
  Future<void> solvePuzzle(List<String> tiles);
  void clearPuzzle();
  void setSortOrder(SortOrder order);
}
```

## 3. UI Components

### 3.1 Layout Structure

#### Desktop (≥1024px)
```
┌────────────────────────────────────────────┐
│  Apple Quartile Solver          [?] [⚙]   │
├──────────────────┬─────────────────────────┤
│                  │                         │
│  Puzzle Input    │    Results              │
│  ┌────────────┐  │  ┌──────────────────┐   │
│  │            │  │  │ 29 words found   │   │
│  │  Tiles     │  │  ├──────────────────┤   │
│  │  (textarea)│  │  │ 1. discretion    │   │
│  │            │  │  │ 2. ornithology   │   │
│  └────────────┘  │  │ 3. proverbial    │   │
│                  │  │ ...              │   │
│  [Sample 1-5]    │  └──────────────────┘   │
│                  │                         │
│  [Solve] [Clear] │  [Copy] [Export]        │
│                  │                         │
└──────────────────┴─────────────────────────┘
```

#### Mobile (≤768px)
```
┌────────────────────────┐
│  Quartile Solver  [≡]  │
├────────────────────────┤
│  Puzzle Input          │
│  ┌──────────────────┐  │
│  │ Tiles (textarea) │  │
│  └──────────────────┘  │
│  [Sample Puzzles ▼]    │
│  [Solve] [Clear]       │
├────────────────────────┤
│  Results (29 words)    │
│  ┌──────────────────┐  │
│  │ 1. discretion    │  │
│  │ 2. ornithology   │  │
│  │ ...              │  │
│  └──────────────────┘  │
│  [Copy] [Export]       │
└────────────────────────┘
```

### 3.2 Component Specifications

#### TileInputField
- **Type**: Multi-line text input
- **Validation**: Real-time, non-empty lines only
- **Placeholder**: "Enter puzzle tiles (one per line)\nExample:\ndis\ncre\nti\non"
- **Max height**: 400px (scrollable)
- **Font**: Monospace, 16px
- **Behavior**: Auto-trim whitespace, convert to lowercase

#### SamplePuzzleButtons
- **Layout**: Horizontal scroll on mobile, grid on desktop
- **Buttons**: "Puzzle 1" through "Puzzle 5"
- **Action**: Load sample puzzle into input field
- **Style**: Outlined buttons, 40px height

#### SolveButton
- **States**: 
  - Default: "Solve Puzzle"
  - Processing: "Solving..." with spinner
  - Disabled: When no tiles entered
- **Style**: Primary color, elevated
- **Keyboard**: Enter key triggers solve

#### ResultsList
- **Layout**: Vertical list with alternating row colors
- **Item format**: `{index}. {word}`
- **Grouping**: Optional headers by word length
- **Virtualization**: For 1000+ results
- **Empty state**: "No words found" message

## 4. Visual Design System

### 4.1 Color Palette
- **Primary**: #007AFF (iOS Blue)
- **Success**: #34C759 (Green)
- **Background**: #F2F2F7 (Light Gray)
- **Surface**: #FFFFFF (White)
- **Text Primary**: #000000
- **Text Secondary**: #8E8E93
- **Border**: #C6C6C8

### 4.2 Typography
- **Headings**: SF Pro Display / System UI, 24px, 600 weight
- **Body**: SF Pro Text / System UI, 16px, 400 weight
- **Monospace**: SF Mono / Consolas, 14px (for tiles)
- **Results**: System UI, 16px, 400 weight

### 4.3 Spacing
- **Base unit**: 8px
- **Padding**: 16px (mobile), 24px (desktop)
- **Gap**: 16px between components
- **Border radius**: 8px

### 4.4 Animations
- **Transitions**: 200ms ease-in-out
- **Loading spinner**: Circular, 40px diameter
- **Result appearance**: Fade in, stagger 50ms

## 5. Algorithms

### 5.1 Trie Implementation
- O(m) insertion where m = word length
- O(m) search where m = word length
- Space: O(ALPHABET_SIZE * N * M) where N = words, M = avg length

### 5.2 Permutation Generation
- Generate combinations C(n,r) for r=1 to 4
- Generate permutations P(r) for each combination
- Total: Σ(r=1 to 4) C(n,r) * r!

### 5.3 Word Form Generation
- Plurals: -s, -es, -ies rules
- Verbs: -ed, -ing rules
- Generated at dictionary load time

## 6. File Structure

### Flutter Web
```
quartile_solver_web/
├── lib/
│   ├── main.dart                 # App entry point
│   ├── models/
│   │   ├── trie.dart            # Trie data structure
│   │   ├── puzzle.dart          # Puzzle model
│   │   └── solver_result.dart   # Result model
│   ├── services/
│   │   ├── dictionary_service.dart
│   │   ├── solver_service.dart
│   │   └── word_generator.dart
│   ├── providers/
│   │   └── app_state.dart       # State management
│   └── widgets/
│       ├── puzzle_input.dart
│       ├── results_panel.dart
│       └── sample_buttons.dart
├── web/
│   ├── index.html
│   └── assets/
│       └── wn_s.pl              # Dictionary
└── pubspec.yaml
```

### Streamlit
```
streamlit_app/
├── app.py                       # Main app (< 400 lines)
├── solver/
│   ├── trie.py                  # Trie implementation
│   ├── solver.py                # Core solver logic
│   └── word_generator.py        # Word forms
├── data/
│   └── wn_s.pl                  # Dictionary
└── requirements.txt
```

## 7. Performance Targets

- Dictionary load: < 3s
- Trie build: < 2s
- Solve 20 tiles: < 1s
- UI render: 60fps
- Memory: < 100MB

