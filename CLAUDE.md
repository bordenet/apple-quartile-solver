# AI Assistant Guidelines - Apple Quartile Solver

**Purpose**: Guidelines for AI assistants (Claude, GitHub Copilot, etc.) working on this project.

---

## Project Overview

**Apple Quartile Solver** is a word puzzle solver that finds valid English words from letter combinations using the WordNet dictionary.

**Tech Stack**:
- **Core**: Go 1.21+ (CLI solver)
- **Web UIs**: Flutter/Dart (web), Python/Streamlit
- **Dictionary**: WordNet 3.0 Prolog database
- **Testing**: Go test framework, 15 tests, 56%+ coverage

**Key Constraints**:
- All code files must be under 400 lines
- No binaries committed to git (build from source)
- Pre-commit hooks enforce validation

---

## Development Protocols

### 1. Code Quality Standards

**Before making changes**:
- Run `./scripts/validate.sh` to check current state
- Review existing code style and match it
- Check test coverage for affected areas

**After making changes**:
- Run `./scripts/validate.sh --fix` to auto-format
- Ensure all tests pass
- Update tests if behavior changes
- Run pre-commit hooks will validate automatically

### 2. File Size Constraint

**CRITICAL**: No file should exceed 400 lines.

If a file approaches 400 lines:
1. Extract helper functions to separate files
2. Create modular packages/modules
3. Split into logical components

**Example**: The Flutter web UI is split into:
- `models/` - Data structures (30-54 lines each)
- `services/` - Business logic (44-85 lines each)
- `providers/` - State management (127 lines)
- `widgets/` - UI components (136-167 lines each)

### 3. Testing Requirements

**Always update tests when**:
- Adding new functions
- Changing function signatures
- Modifying behavior
- Fixing bugs

**Run tests**:
```bash
go test -v              # Run all tests
go test -v -cover       # With coverage
go test -bench=.        # Benchmarks
```

### 4. Build & Compilation Issues

**5-Minute / 3-Attempt Escalation Policy**:

If you encounter build/compilation errors:
1. After 5 minutes OR 3 failed attempts, STOP
2. Ask the user for help or suggest external research
3. DO NOT continue trial-and-error troubleshooting

**Why**: Build toolchain issues often have known solutions. Wasting time on guesswork is inefficient.

### 5. Git Workflow

**Commit Message Standards**:
```bash
# ✅ Good (imperative mood, specific)
git commit -m "Add validation for empty puzzle input"
git commit -m "Fix plural generation for words ending in 'y'"
git commit -m "Update README with starter-kit integration"

# ❌ Bad (vague, past tense)
git commit -m "Updates"
git commit -m "Fixed stuff"
git commit -m "WIP"
```

**Pre-commit hooks**:
- Automatically run on `git commit`
- Validate Go code formatting, linting, tests
- Check for binaries in git
- Can bypass with `git commit --no-verify` (not recommended)

---

## Project Structure

```
apple-quartile-solver/
├── main.go                 # CLI implementation (330 lines)
├── main_test.go            # Tests (507 lines)
├── scripts/                # Automation scripts
│   ├── lib/common.sh      # Shared shell library
│   ├── setup-go.sh        # Go environment setup
│   ├── setup-web.sh       # Web UI setup
│   ├── validate.sh        # Code validation
│   └── install-hooks.sh   # Git hooks installer
├── samples/                # Sample puzzles
├── streamlit_app/          # Streamlit web UI
├── quartile_solver_web/   # Flutter web UI
├── starter-kit/            # Engineering best practices
└── docs/                  # Documentation
```

---

## Common Tasks

### Setup Development Environment
```bash
./scripts/setup-go.sh          # Setup Go
./scripts/setup-web.sh         # Setup web UIs
./scripts/install-hooks.sh     # Install git hooks
```

### Validate Code
```bash
./scripts/validate.sh          # Run all checks
./scripts/validate.sh --fix    # Auto-fix formatting
```

### Build and Run
```bash
go build -o applequartile
./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle1.txt
```

### Run Web UIs
```bash
# Streamlit
cd streamlit_app && source venv/bin/activate && streamlit run app.py

# Flutter
cd quartile_solver_web && flutter run -d chrome
```

---

## Code Style

### Go
- Use `gofmt` for formatting (enforced by validation)
- Follow standard Go conventions
- Extract helper functions when main() exceeds ~50 lines
- Use descriptive variable names (`tiles` not `lines`, `count` not `i`)
- Add comments for exported functions

### Shell Scripts
- Use `scripts/lib/common.sh` for all scripts
- Call `init_script` at start
- Use logging functions: `log_info`, `log_success`, `log_error`
- Include header with PURPOSE, USAGE, EXAMPLES
- Make scripts executable: `chmod +x script.sh`

### Python (Streamlit)
- Follow PEP 8
- Use type hints
- Keep files modular (under 200 lines)
- Use `@st.cache_resource` for expensive operations

### Dart (Flutter)
- Follow Flutter style guide
- Use Provider for state management
- Keep widgets focused and small
- Extract reusable components

---

## Documentation

**When to update docs**:
- Adding new features → Update README.md
- Changing APIs → Update relevant .md files
- Adding scripts → Document in README and script header
- Changing setup process → Update setup scripts and docs

**Documentation files**:
- `README.md` - Main project documentation
- `WEB_UI_README.md` - Web UI quick start
- `docs/PRD.md` - Product requirements
- `docs/DESIGN_SPEC.md` - Technical design
- `docs/STARTER_KIT_INTEGRATION.md` - Starter-kit usage

---

## References

- **Starter Kit**: See `starter-kit/` for engineering best practices
- **Shell Standards**: `starter-kit/SHELL_SCRIPT_STANDARDS.md`
- **Safety Net**: `starter-kit/SAFETY_NET.md`
- **Development Protocols**: `starter-kit/DEVELOPMENT_PROTOCOLS.md`

