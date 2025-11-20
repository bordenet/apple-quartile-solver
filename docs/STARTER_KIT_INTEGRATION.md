# Starter Kit Integration

This document describes how the engineering starter-kit has been integrated into the Apple Quartile Solver project.

## Overview

The starter-kit provides engineering best practices from real-world projects, including:
- Standardized shell scripting conventions
- Automated validation and safety nets
- Pre-commit hooks for code quality
- Consistent development workflows

## What Was Added

### 1. Scripts Directory (`scripts/`)

**`scripts/lib/common.sh`** - Shared shell script library
- Standardized logging functions (log_info, log_success, log_error, etc.)
- Error handling utilities (die, require_command, require_file)
- Path utilities (get_script_dir, get_repo_root)
- User interaction helpers (ask_yes_no)
- Platform detection (is_macos, is_linux)
- Color-coded output for better readability

**`scripts/setup-go.sh`** - Go environment setup
- Checks Go installation
- Downloads dependencies
- Builds the solver binary
- Runs tests to verify setup

**`scripts/setup-web.sh`** - Web UI setup
- Sets up Flutter web UI (optional)
- Sets up Streamlit UI (optional)
- Creates Python virtual environment
- Installs all dependencies
- Supports `--flutter-only` and `--streamlit-only` flags

**`scripts/validate.sh`** - Comprehensive validation
- Go code formatting checks (gofmt)
- Go linting (go vet)
- Go tests
- Flutter analysis (if available)
- Python linting (if available)
- Binary tracking checks
- Supports `--fix` flag for auto-formatting

**`scripts/install-hooks.sh`** - Git hooks installer
- Installs pre-commit hook
- Installs binary check hook
- One-time setup for automated validation

### 2. Pre-Commit Hooks

Git hooks automatically run validation before commits:

**Pre-commit hook** (`.git/hooks/pre-commit`)
- Runs `./scripts/validate.sh` before every commit
- Blocks commits if validation fails
- Provides clear error messages and fix instructions
- Can be bypassed with `git commit --no-verify` (not recommended)

**Check-binaries hook** (`.git/hooks/check-binaries`)
- Prevents compiled binaries from being committed
- Checks for Mach-O, ELF, and PE executables
- Platform-specific binaries should be built from source

### 3. Updated .gitignore

Enhanced to exclude:
- Go build artifacts (*.exe, *.dll, *.so, *.dylib, *.test, *.out)
- Test coverage files (coverage.txt, *.coverprofile)
- Temporary files (*.tmp, *.swp, *~)
- go.sum (generated file)

### 4. Starter Kit Documentation

The `starter-kit/` directory contains comprehensive engineering documentation:
- **README.md** - Overview and usage guide
- **SAFETY_NET.md** - Automated safety mechanisms
- **SHELL_SCRIPT_STANDARDS.md** - Shell scripting conventions
- **DEVELOPMENT_PROTOCOLS.md** - Development workflows
- **CODE_STYLE_STANDARDS.md** - Cross-language style guide
- **common.sh** - Reference implementation

## Usage

### First-Time Setup

```bash
# 1. Setup Go environment
./scripts/setup-go.sh

# 2. Setup web UIs (optional)
./scripts/setup-web.sh

# 3. Install git hooks
./scripts/install-hooks.sh
```

### Daily Development

```bash
# Run validation before committing
./scripts/validate.sh

# Auto-fix formatting issues
./scripts/validate.sh --fix

# Commit (hooks run automatically)
git commit -m "Your message"
```

### Setup Individual Components

```bash
# Setup only Flutter
./scripts/setup-web.sh --flutter-only

# Setup only Streamlit
./scripts/setup-web.sh --streamlit-only
```

## Benefits

### Before Starter Kit Integration
- ❌ Manual setup steps prone to errors
- ❌ Inconsistent validation across developers
- ❌ No automated quality checks
- ❌ Binary accidentally committed to git
- ❌ Each script had different style

### After Starter Kit Integration
- ✅ One-command setup for entire project
- ✅ Automated validation on every commit
- ✅ Consistent, color-coded script output
- ✅ Pre-commit hooks prevent broken commits
- ✅ All scripts follow same conventions
- ✅ Clear error messages with fix instructions

## Testing

All scripts have been tested and verified:

```bash
✅ ./scripts/setup-go.sh - Builds binary and runs tests
✅ ./scripts/setup-web.sh - Sets up both web UIs
✅ ./scripts/validate.sh - Runs all validation checks
✅ ./scripts/install-hooks.sh - Installs git hooks
✅ Pre-commit hook - Blocks invalid commits
```

## Maintenance

The starter-kit is a living collection of best practices. To update:

1. Improve practices in this project
2. Update `starter-kit/` documentation
3. Copy improvements to other projects

## References

- **Starter Kit Origin**: [RecipeArchive](https://github.com/bordenet/RecipeArchive)
- **Shell Standards**: [starter-kit/SHELL_SCRIPT_STANDARDS.md](../starter-kit/SHELL_SCRIPT_STANDARDS.md)
- **Safety Net Guide**: [starter-kit/SAFETY_NET.md](../starter-kit/SAFETY_NET.md)

