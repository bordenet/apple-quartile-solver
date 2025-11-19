#!/usr/bin/env bash

################################################################################
# Apple Quartile Solver - Web UI Setup
################################################################################
# PURPOSE: Install and verify web UI dependencies
#   - Check Flutter installation (for Flutter web)
#   - Check Python installation (for Streamlit)
#   - Install dependencies for both UIs
#
# USAGE:
#   ./scripts/setup-web.sh [--flutter-only|--streamlit-only]
#
# DEPENDENCIES:
#   - Flutter 3.0+ (brew install flutter)
#   - Python 3.8+ (brew install python3)
################################################################################

# Source common library
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/lib/common.sh"
init_script

readonly REPO_ROOT="$(get_repo_root)"

# Parse arguments
SETUP_FLUTTER=true
SETUP_STREAMLIT=true

while [[ $# -gt 0 ]]; do
    case $1 in
        --flutter-only)
            SETUP_STREAMLIT=false
            shift
            ;;
        --streamlit-only)
            SETUP_FLUTTER=false
            shift
            ;;
        *)
            log_error "Unknown option: $1"
            echo "Usage: $0 [--flutter-only|--streamlit-only]"
            exit 1
            ;;
    esac
done

setup_flutter() {
    log_section "Setting up Flutter Web UI"
    
    require_command "flutter" "brew install flutter"
    
    local flutter_version
    flutter_version=$(flutter --version | head -1 | awk '{print $2}')
    log_success "Flutter $flutter_version installed"
    
    cd "$REPO_ROOT/quartile_solver_web"
    
    log_info "Getting Flutter dependencies..."
    flutter pub get
    log_success "Flutter dependencies installed"
    
    log_info "Running Flutter analyzer..."
    flutter analyze || log_warning "Flutter analyzer found issues (non-fatal)"
    
    log_success "Flutter web UI setup complete"
}

setup_streamlit() {
    log_section "Setting up Streamlit UI"
    
    require_command "python3" "brew install python3"
    
    local python_version
    python_version=$(python3 --version | awk '{print $2}')
    log_success "Python $python_version installed"
    
    cd "$REPO_ROOT/streamlit_app"
    
    if [[ ! -d "venv" ]]; then
        log_info "Creating Python virtual environment..."
        python3 -m venv venv
        log_success "Virtual environment created"
    fi
    
    log_info "Installing Streamlit dependencies..."
    source venv/bin/activate
    pip install -q --upgrade pip
    pip install -q -r requirements.txt
    log_success "Streamlit dependencies installed"
    
    log_success "Streamlit UI setup complete"
}

main() {
    log_header "Apple Quartile Solver - Web UI Setup"
    
    if [[ "$SETUP_FLUTTER" == true ]]; then
        setup_flutter
    fi
    
    if [[ "$SETUP_STREAMLIT" == true ]]; then
        setup_streamlit
    fi
    
    log_success "Web UI setup complete!"
    echo ""
    
    if [[ "$SETUP_FLUTTER" == true ]]; then
        log_info "Run Flutter web: cd quartile_solver_web && flutter run -d chrome"
    fi
    
    if [[ "$SETUP_STREAMLIT" == true ]]; then
        log_info "Run Streamlit: cd streamlit_app && source venv/bin/activate && streamlit run app.py"
    fi
}

main "$@"

