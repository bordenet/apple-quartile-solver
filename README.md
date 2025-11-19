# Apple Quartile Solver

Solves Apple News Quartile puzzles by finding valid English words from letter combinations using the WordNet dictionary.

**Available Interfaces:**
- **Command-line** (Go) - Fast, efficient CLI tool
- **Web UI** (Flutter/Streamlit) - Interactive browser-based interfaces

## Quick Start

### Command-Line Interface

```bash
# Download dictionary
curl -O https://wordnetcode.princeton.edu/3.0/WNprolog-3.0.tar.gz
tar -xzf WNprolog-3.0.tar.gz

# Build and run
go build -o applequartile
./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle1.txt
```

### Web Interfaces

**Streamlit (Python)**
```bash
cd streamlit_app
python3 -m venv venv && source venv/bin/activate
pip install -r requirements.txt
streamlit run app.py
```

**Flutter Web**
```bash
cd quartile_solver_web
flutter pub get
mkdir -p assets && cp ../prolog/wn_s.pl assets/
flutter run -d chrome
```

See [WEB_UI_README.md](WEB_UI_README.md) for detailed web UI documentation.

## Prerequisites

### Command-Line
- Go 1.21 or later
- Internet connection (for initial WordNet download)

### Web UIs
- **Streamlit**: Python 3.8+
- **Flutter**: Flutter 3.0+, Dart 3.0+

## Setup

### 1. Download WordNet Dictionary

```bash
curl -O https://wordnetcode.princeton.edu/3.0/WNprolog-3.0.tar.gz
tar -xzf WNprolog-3.0.tar.gz
```

This creates a `prolog/` directory containing `wn_s.pl`.

### 2. Build

```bash
go build -o applequartile
```

## Usage

```bash
./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle1.txt
```

### Options

- `--dictionary PATH` - Path to WordNet dictionary file (wn_s.pl)
- `--puzzle PATH` - Path to puzzle file with letter combinations
- `--debug` - Enable verbose output
- `--help` - Show help message

### Examples

```bash
# Basic usage
./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle1.txt

# Debug mode
./applequartile --debug --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle2.txt
```

## Testing

```bash
# Run all tests
go test -v

# With coverage
go test -v -cover

# Benchmarks
go test -bench=. -benchmem
```

Test coverage includes:
- Trie operations (insert, search, edge cases)
- Dictionary loading (parsing, error handling, malformed data)
- Word form generation (plurals, verb conjugation)
- Permutation generation
- Input validation
- Performance benchmarks

## How It Works

1. Loads WordNet dictionary into a trie data structure
2. Generates word forms (plurals, verb conjugations)
3. Reads puzzle file with letter combinations
4. Generates all permutations of combinations (1-4 tiles)
5. Validates permutations against dictionary
6. Outputs valid words

## Implementation Details

- **Data structure**: Trie for O(m) word lookup where m = word length
- **Dictionary**: WordNet 3.0 Prolog database (~117k base words)
- **Word forms**: Automatic plural and verb conjugation generation
- **Permutations**: Generates all combinations and orderings of 1-4 tiles

## Project Structure

```
apple-quartile-solver/
├── main.go                 # CLI implementation (330 lines)
├── main_test.go            # Tests (507 lines)
├── samples/                # Sample puzzles
├── streamlit_app/          # Streamlit web UI
│   ├── app.py             # Main app (190 lines)
│   └── solver/            # Solver package (186 lines)
├── quartile_solver_web/   # Flutter web UI
│   └── lib/               # Modular architecture (903 lines)
└── docs/                  # Design documentation
    ├── PRD.md
    ├── DESIGN_SPEC.md
    ├── VISUAL_DESIGN.md
    └── WEB_UI_GUIDE.md
```

All code files are under 400 lines for maintainability.

## Documentation

- **[WEB_UI_README.md](WEB_UI_README.md)** - Web interface overview and quick start
- **[docs/PRD.md](docs/PRD.md)** - Product requirements document
- **[docs/DESIGN_SPEC.md](docs/DESIGN_SPEC.md)** - Technical design specification
- **[docs/VISUAL_DESIGN.md](docs/VISUAL_DESIGN.md)** - Visual design system
- **[docs/WEB_UI_GUIDE.md](docs/WEB_UI_GUIDE.md)** - Detailed implementation guide
