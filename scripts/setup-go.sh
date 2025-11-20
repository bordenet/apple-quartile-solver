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
# shellcheck source=lib/common.sh
source "$SCRIPT_DIR/lib/common.sh"
init_script

REPO_ROOT=""
REPO_ROOT="$(get_repo_root)"
readonly REPO_ROOT

main() {
    log_header "Apple Quartile Solver - Go Setup"

    log_section "Checking Go installation"
    require_command "go" "brew install go"

    local go_version
    go_version=$(go version | awk '{print $3}' | sed 's/go//')
    log_success "Go $go_version installed"

    cd "$REPO_ROOT" || die "Failed to change to repository root"

    log_section "Downloading WordNet dictionary"
    if [[ ! -f "prolog/wn_s.pl" ]]; then
        log_info "Downloading WordNet 3.0 Prolog database..."
        curl -L -o WNprolog-3.0.tar.gz https://wordnetcode.princeton.edu/3.0/WNprolog-3.0.tar.gz
        tar -xzf WNprolog-3.0.tar.gz
        log_success "Dictionary downloaded and extracted"
    else
        log_info "Dictionary already exists, skipping download"
    fi

    log_section "Downloading Go dependencies"
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
    log_info "Run the solver with: ./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle1.txt"
}

main "$@"

