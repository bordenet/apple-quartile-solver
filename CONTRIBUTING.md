# Contributing to Apple Quartile Solver

Thank you for your interest in contributing! This document provides guidelines for contributing to the project.

## Getting Started

### Prerequisites

- Go 1.21 or later
- Git
- (Optional) Flutter 3.0+ for web UI development
- (Optional) Python 3.8+ for Streamlit UI development

### Setup

1. **Fork and clone the repository**
   ```bash
   git clone https://github.com/yourusername/apple-quartile-solver.git
   cd apple-quartile-solver
   ```

2. **Run automated setup**
   ```bash
   ./scripts/setup-go.sh          # Setup Go environment
   ./scripts/setup-web.sh         # Setup web UIs (optional)
   ./scripts/install-hooks.sh     # Install git hooks
   ```

3. **Verify setup**
   ```bash
   ./scripts/validate.sh
   ```

## Development Workflow

### 1. Create a Feature Branch

```bash
git checkout -b feature/your-feature-name
```

### 2. Make Changes

- Follow the code style guidelines (see below)
- Keep files under 400 lines
- Add tests for new functionality
- Update documentation as needed

### 3. Validate Your Changes

```bash
# Run all validation checks
./scripts/validate.sh

# Auto-fix formatting issues
./scripts/validate.sh --fix

# Run tests
go test -v -cover
```

### 4. Commit Your Changes

```bash
git add .
git commit -m "Add feature: description"
```

**Commit Message Guidelines**:
- Use imperative mood ("Add feature" not "Added feature")
- Be specific and descriptive
- Reference issues if applicable

**Good examples**:
- `Add support for 5-tile puzzles`
- `Fix plural generation for words ending in 'y'`
- `Update README with installation instructions`

**Bad examples**:
- `Updates`
- `Fixed stuff`
- `WIP`

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a pull request on GitHub with:
- Clear description of changes
- Test plan
- Screenshots (if UI changes)
- Related issues

## Code Style Guidelines

### Go

- Use `gofmt` for formatting (enforced by pre-commit hooks)
- Follow [Effective Go](https://golang.org/doc/effective_go.html)
- Add comments for exported functions
- Use descriptive variable names
- Keep functions focused and small

### Python (Streamlit)

- Follow [PEP 8](https://www.python.org/dev/peps/pep-0008/)
- Use type hints
- Keep files modular (under 200 lines)
- Use meaningful variable names

### Dart (Flutter)

- Follow [Flutter style guide](https://flutter.dev/docs/development/tools/formatting)
- Use Provider for state management
- Keep widgets small and focused
- Extract reusable components

### Shell Scripts

- Use `scripts/lib/common.sh` library
- Include header with PURPOSE, USAGE, EXAMPLES
- Use logging functions: `log_info`, `log_success`, `log_error`
- Make scripts executable: `chmod +x`

## File Size Constraint

**CRITICAL**: No file should exceed 400 lines.

If a file approaches 400 lines:
1. Extract helper functions to separate files
2. Create modular packages/modules
3. Split into logical components

## Testing

### Running Tests

```bash
# Run all tests
go test -v

# With coverage
go test -v -cover

# Benchmarks
go test -bench=. -benchmem
```

### Writing Tests

- Add tests for all new functionality
- Update existing tests when changing behavior
- Aim for high test coverage
- Include edge cases and error conditions

## Pre-Commit Hooks

Pre-commit hooks automatically validate your code before commits:

- Go code formatting (gofmt)
- Go linting (go vet)
- Go tests
- Binary detection

To bypass hooks (not recommended):
```bash
git commit --no-verify
```

## Documentation

Update documentation when:
- Adding new features
- Changing APIs or interfaces
- Modifying setup process
- Adding new scripts

**Documentation files**:
- `README.md` - Main project documentation
- `WEB_UI_README.md` - Web UI documentation
- `docs/` - Design and technical documentation
- `CLAUDE.md` - AI assistant guidelines

## Questions or Issues?

- Open an issue on GitHub
- Check existing issues and pull requests
- Review the documentation in `docs/` and `starter-kit/`

## License

By contributing, you agree that your contributions will be licensed under the MIT License.

