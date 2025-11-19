#!/usr/bin/env bash

################################################################################
# Apple Quartile Solver - Validation Script
################################################################################
# PURPOSE: Run all validation checks before committing
#   - Go code formatting and linting
#   - Go tests
#   - Flutter analysis (if available)
#   - Python linting (if available)
#   - Check for binaries in git
#
# USAGE:
#   ./scripts/validate.sh [--fix]
#
# OPTIONS:
#   --fix    Automatically fix formatting issues
################################################################################

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
init_script

REPO_ROOT=""
REPO_ROOT="$(get_repo_root)"
readonly REPO_ROOT

# Parse arguments
FIX_MODE=false
if [[ "${1:-}" == "--fix" ]]; then
    FIX_MODE=true
fi

# Track failures
FAILURES=0

validate_go() {
    log_section "Validating Go code"

    cd "$REPO_ROOT" || die "Failed to change to repository root"
    
    # Check formatting
    log_info "Checking Go formatting..."
    if [[ "$FIX_MODE" == true ]]; then
        go fmt ./...
        log_success "Go code formatted"
    else
        local unformatted
        unformatted=$(gofmt -l . | grep -v vendor || true)
        if [[ -n "$unformatted" ]]; then
            log_error "Unformatted Go files found:"
            echo "$unformatted"
            log_info "Run with --fix to auto-format"
            ((FAILURES++))
        else
            log_success "Go code properly formatted"
        fi
    fi
    
    # Run go vet
    log_info "Running go vet..."
    if go vet ./...; then
        log_success "go vet passed"
    else
        log_error "go vet failed"
        ((FAILURES++))
    fi
    
    # Run tests
    log_info "Running Go tests..."
    if go test -v ./...; then
        log_success "All Go tests passed"
    else
        log_error "Go tests failed"
        ((FAILURES++))
    fi
    
    # Check if binary is built
    if [[ -f "applequartile" ]]; then
        log_info "Testing binary execution..."
        if ./applequartile --help > /dev/null 2>&1; then
            log_success "Binary executes correctly"
        else
            log_warning "Binary exists but --help failed"
        fi
    fi
}

validate_flutter() {
    if [[ ! -d "$REPO_ROOT/quartile_solver_web" ]]; then
        return 0
    fi
    
    if ! command -v flutter &> /dev/null; then
        log_warning "Flutter not installed, skipping Flutter validation"
        return 0
    fi
    
    log_section "Validating Flutter web"

    cd "$REPO_ROOT/quartile_solver_web" || die "Failed to change to Flutter directory"
    
    log_info "Running Flutter analyzer..."
    if flutter analyze; then
        log_success "Flutter analysis passed"
    else
        log_warning "Flutter analysis found issues (non-fatal)"
    fi
}

validate_python() {
    if [[ ! -d "$REPO_ROOT/streamlit_app" ]]; then
        return 0
    fi
    
    log_section "Validating Python code"

    cd "$REPO_ROOT/streamlit_app" || die "Failed to change to Streamlit directory"

    # Check if venv exists
    if [[ ! -d "venv" ]]; then
        log_warning "Python venv not found, skipping Python validation"
        log_info "Run: ./scripts/setup-web.sh --streamlit-only"
        return 0
    fi

    # shellcheck source=/dev/null
    source venv/bin/activate
    
    # Check if flake8 is available
    if command -v flake8 &> /dev/null; then
        log_info "Running flake8..."
        if flake8 app.py solver/ --max-line-length=120; then
            log_success "Python linting passed"
        else
            log_warning "Python linting found issues (non-fatal)"
        fi
    fi
}

check_binaries() {
    log_section "Checking for uncommitted binaries"

    cd "$REPO_ROOT" || die "Failed to change to repository root"
    
    # Check if applequartile binary is in git
    if git ls-files --error-unmatch applequartile &> /dev/null; then
        log_error "Binary 'applequartile' is tracked in git!"
        log_info "Remove with: git rm --cached applequartile"
        ((FAILURES++))
    else
        log_success "No binaries tracked in git"
    fi
}

main() {
    log_header "Apple Quartile Solver - Validation"
    
    validate_go
    validate_flutter
    validate_python
    check_binaries
    
    echo ""
    if [[ $FAILURES -eq 0 ]]; then
        log_success "✅ All validation checks passed!"
        exit 0
    else
        log_error "❌ $FAILURES validation check(s) failed"
        exit 1
    fi
}

main "$@"

