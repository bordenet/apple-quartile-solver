#!/usr/bin/env bash

################################################################################
# Apple Quartile Solver - Go Setup
################################################################################
# PURPOSE: Install and verify Go dependencies for the solver
#   - Check Go installation
#   - Download dependencies
#   - Build the solver binary
#
# USAGE:
#   ./scripts/setup-go.sh
#
# DEPENDENCIES:
#   - Go 1.21+ (brew install go)
################################################################################

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
init_script

readonly REPO_ROOT="$(get_repo_root)"

main() {
    log_header "Apple Quartile Solver - Go Setup"

    log_section "Checking Go installation"
    require_command "go" "brew install go"
    
    local go_version
    go_version=$(go version | awk '{print $3}' | sed 's/go//')
    log_success "Go $go_version installed"

    log_section "Downloading Go dependencies"
    cd "$REPO_ROOT"
    go mod download
    log_success "Dependencies downloaded"

    log_section "Building solver binary"
    go build -o applequartile main.go
    log_success "Binary built: applequartile"

    log_section "Running tests"
    go test -v
    log_success "All tests passed"

    log_success "Go setup complete!"
    echo ""
    log_info "Run the solver with: ./applequartile --help"
}

main "$@"

