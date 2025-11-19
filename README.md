# Apple Quartile Solver

Solves Apple News Quartile puzzles by finding valid English words from letter combinations using the WordNet dictionary.

## Prerequisites

- Go 1.21 or later
- Internet connection (for initial WordNet download)

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
