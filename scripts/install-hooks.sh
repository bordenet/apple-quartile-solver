#!/usr/bin/env bash

################################################################################
# Apple Quartile Solver - Install Git Hooks
################################################################################
# PURPOSE: Install pre-commit hooks to validate code before commits
#   - Copy hooks to .git/hooks/
#   - Make hooks executable
#
# USAGE:
#   ./scripts/install-hooks.sh
################################################################################

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
init_script

readonly REPO_ROOT="$(get_repo_root)"

main() {
    log_header "Installing Git Hooks"
    
    # Check if .git directory exists
    if [[ ! -d "$REPO_ROOT/.git" ]]; then
        die "Not a git repository. Run from repository root."
    fi
    
    log_section "Creating pre-commit hook"
    
    # Create pre-commit hook
    cat > "$REPO_ROOT/.git/hooks/pre-commit" << 'EOF'
#!/usr/bin/env bash
################################################################################
# Pre-Commit Hook - Apple Quartile Solver
################################################################################

set -e

REPO_ROOT="$(git rev-parse --show-toplevel)"

echo "🔍 Running pre-commit validation..."
echo ""

# Run validation script
if "$REPO_ROOT/scripts/validate.sh"; then
    echo ""
    echo "✅ Pre-commit validation passed"
    exit 0
else
    echo ""
    echo "❌ Pre-commit validation failed"
    echo ""
    echo "To fix issues automatically, run:"
    echo "  ./scripts/validate.sh --fix"
    echo ""
    echo "To bypass this check (not recommended):"
    echo "  git commit --no-verify"
    echo ""
    exit 1
fi
EOF
    
    chmod +x "$REPO_ROOT/.git/hooks/pre-commit"
    log_success "Pre-commit hook installed"
    
    log_section "Creating check-binaries hook"
    
    # Copy check-binaries template
    cp "$REPO_ROOT/starter-kit/check-binaries.template" "$REPO_ROOT/.git/hooks/check-binaries"
    chmod +x "$REPO_ROOT/.git/hooks/check-binaries"
    log_success "Check-binaries hook installed"
    
    log_success "Git hooks installed successfully!"
    echo ""
    log_info "Hooks will run automatically on 'git commit'"
    log_info "To test hooks now, run: ./scripts/validate.sh"
}

main "$@"

