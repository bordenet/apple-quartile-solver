# Apple Quartile Solver

[![CI](https://github.com/bordenet/apple-quartile-solver/workflows/CI/badge.svg)](https://github.com/bordenet/apple-quartile-solver/actions)
[![codecov](https://codecov.io/gh/bordenet/apple-quartile-solver/branch/main/graph/badge.svg)](https://codecov.io/gh/bordenet/apple-quartile-solver)
[![Go Version](https://img.shields.io/badge/Go-1.21+-00ADD8?logo=go)](https://go.dev/)
[![Python Version](https://img.shields.io/badge/Python-3.8+-3776AB?logo=python&logoColor=white)](https://www.python.org/)
[![Flutter Version](https://img.shields.io/badge/Flutter-3.27+-02569B?logo=flutter)](https://flutter.dev/)
[![License](https://img.shields.io/badge/License-CC0_1.0-lightgrey.svg)](LICENSE)

Solves Apple News Quartile puzzles by finding valid English words from letter combinations using the WordNet dictionary.

## Features

- **Multiple Interfaces**: Command-line (Go), Web UI (Flutter), and Streamlit (Python)
- **Fast Performance**: Solves 20-tile puzzles in under 1 second
- **Comprehensive Dictionary**: WordNet 3.0 with 117k+ base words
- **Automated Testing**: 70%+ code coverage with unit and E2E tests
- **CI/CD Pipeline**: Automated testing and validation on every commit

## Table of Contents

- [Quick Start](#quick-start)
- [Prerequisites](#prerequisites)
- [Setup](#setup)
- [Usage](#usage)
- [Development](#development)
- [Testing](#testing)
- [Project Structure](#project-structure)
- [Documentation](#documentation)
- [Contributing](#contributing)
- [License](#license)

## Quick Start

### Automated Setup (Recommended)

```bash
# Setup Go environment and build
./scripts/setup-go.sh

# Setup web UIs (optional)
./scripts/setup-web.sh

# Install git hooks for code quality
./scripts/install-hooks.sh
```

### Manual Setup - Command-Line Interface

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

## Development

### Validation & Testing

```bash
# Run all validation checks (formatting, linting, tests)
./scripts/validate.sh

# Auto-fix formatting issues
./scripts/validate.sh --fix

# Run tests only
go test -v

# With coverage
go test -v -cover

# Run E2E tests
./test_e2e.sh

# Benchmarks
go test -bench=. -benchmem
```

### Pre-Commit Hooks

Git hooks automatically validate code before commits:

```bash
# Install hooks (one-time setup)
./scripts/install-hooks.sh

# Hooks will run automatically on 'git commit'
# To bypass (not recommended): git commit --no-verify
```

## Testing

### Test Coverage

Current test coverage: **70%+** (unit tests) + comprehensive E2E tests

**Unit Tests:**

- Trie operations (insert, search, edge cases)
- Dictionary loading (parsing, error handling, malformed data)
- Word form generation (plurals, verb conjugation)
- Permutation generation
- Input validation
- Performance benchmarks

**End-to-End Tests:**

- Binary execution and help output
- Error handling (missing files, empty puzzles)
- Complete puzzle solving workflow
- Debug mode functionality

**Running Tests:**

```bash
# Go unit tests
go test -v -cover

# Python tests (Streamlit)
cd streamlit_app && pytest --cov=solver

# E2E tests
./test_e2e.sh

# All tests via CI
./scripts/validate.sh
```

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed guidelines on:

- Setting up your development environment
- Code style standards
- Testing requirements
- Commit message conventions
- Pull request process

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
├── scripts/                # Automation scripts
│   ├── lib/common.sh      # Shared shell library
│   ├── setup-go.sh        # Go environment setup
│   ├── setup-web.sh       # Web UI setup
│   ├── validate.sh        # Code validation
│   └── install-hooks.sh   # Git hooks installer
├── streamlit_app/          # Streamlit web UI
│   ├── app.py             # Main app (190 lines)
│   └── solver/            # Solver package (186 lines)
├── quartile_solver_web/   # Flutter web UI
│   └── lib/               # Modular architecture (903 lines)
├── starter-kit/            # Engineering best practices
│   ├── README.md          # Starter kit overview
│   ├── SAFETY_NET.md      # Safety mechanisms guide
│   ├── SHELL_SCRIPT_STANDARDS.md
│   └── common.sh          # Shell script library
└── docs/                  # Design documentation
    ├── PRD.md
    ├── DESIGN_SPEC.md
    ├── VISUAL_DESIGN.md
    └── WEB_UI_GUIDE.md
```

All code files are under 400 lines for maintainability.

## Documentation

### User Documentation
- **[WEB_UI_README.md](WEB_UI_README.md)** - Web interface overview and quick start
- **[docs/PRD.md](docs/PRD.md)** - Product requirements document
- **[docs/DESIGN_SPEC.md](docs/DESIGN_SPEC.md)** - Technical design specification
- **[docs/VISUAL_DESIGN.md](docs/VISUAL_DESIGN.md)** - Visual design system
- **[docs/WEB_UI_GUIDE.md](docs/WEB_UI_GUIDE.md)** - Detailed implementation guide

### Engineering Documentation
- **[starter-kit/README.md](starter-kit/README.md)** - Engineering best practices overview
- **[starter-kit/SAFETY_NET.md](starter-kit/SAFETY_NET.md)** - Automated safety mechanisms
- **[starter-kit/SHELL_SCRIPT_STANDARDS.md](starter-kit/SHELL_SCRIPT_STANDARDS.md)** - Shell scripting conventions
- **[starter-kit/DEVELOPMENT_PROTOCOLS.md](starter-kit/DEVELOPMENT_PROTOCOLS.md)** - Development workflows

## License

MIT License - See [LICENSE](LICENSE) file for details.
