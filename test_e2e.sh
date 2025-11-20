#!/usr/bin/env bash

################################################################################
# Apple Quartile Solver - End-to-End Tests
################################################################################
# PURPOSE: Test the complete application workflow
#   - Build the binary
#   - Test with sample puzzles
#   - Verify output correctness
#   - Test error conditions
#
# USAGE:
#   ./test_e2e.sh
################################################################################

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

FAILURES=0

log_test() {
    echo -e "${YELLOW}TEST:${NC} $1"
}

log_pass() {
    echo -e "${GREEN}✓${NC} $1"
}

log_fail() {
    echo -e "${RED}✗${NC} $1"
    ((FAILURES++))
}

# Build the binary
log_test "Building binary"
if go build -o applequartile .; then
    log_pass "Binary built successfully"
else
    log_fail "Failed to build binary"
    exit 1
fi

# Test 1: Help flag
log_test "Testing --help flag"
if ./applequartile --help > /dev/null 2>&1; then
    log_pass "Help flag works"
else
    log_fail "Help flag failed"
fi

# Test 2: Missing arguments
log_test "Testing missing arguments"
if ! ./applequartile > /dev/null 2>&1; then
    log_pass "Correctly rejects missing arguments"
else
    log_fail "Should reject missing arguments"
fi

# Test 3: Non-existent dictionary file
log_test "Testing non-existent dictionary file"
if ! ./applequartile --dictionary /nonexistent/file.pl --puzzle ./samples/puzzle1.txt > /dev/null 2>&1; then
    log_pass "Correctly rejects non-existent dictionary"
else
    log_fail "Should reject non-existent dictionary"
fi

# Test 4: Non-existent puzzle file
log_test "Testing non-existent puzzle file"
# Create a minimal test dictionary
cat > /tmp/test_dict.pl << 'EOF'
s(100000001,1,'test',n,1,4).
EOF

if ! ./applequartile --dictionary /tmp/test_dict.pl --puzzle /nonexistent/puzzle.txt > /dev/null 2>&1; then
    log_pass "Correctly rejects non-existent puzzle"
else
    log_fail "Should reject non-existent puzzle"
fi

rm -f /tmp/test_dict.pl

# Test 5: Empty puzzle file
log_test "Testing empty puzzle file"
cat > /tmp/test_dict.pl << 'EOF'
s(100000001,1,'test',n,1,4).
EOF

touch /tmp/empty_puzzle.txt

if ! ./applequartile --dictionary /tmp/test_dict.pl --puzzle /tmp/empty_puzzle.txt > /dev/null 2>&1; then
    log_pass "Correctly rejects empty puzzle"
else
    log_fail "Should reject empty puzzle"
fi

rm -f /tmp/test_dict.pl /tmp/empty_puzzle.txt

# Test 6: Valid execution with sample puzzle
log_test "Testing valid execution with sample puzzle"
if [ -f "./prolog/wn_s.pl" ] && [ -f "./samples/puzzle1.txt" ]; then
    OUTPUT=$(./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle1.txt 2>&1)
    if echo "$OUTPUT" | grep -q "Loading dictionary"; then
        log_pass "Successfully processed sample puzzle"
    else
        log_fail "Failed to process sample puzzle"
    fi
else
    log_pass "Skipping (dictionary or sample not available)"
fi

# Test 7: Debug mode
log_test "Testing debug mode"
cat > /tmp/test_dict.pl << 'EOF'
s(100000001,1,'cat',n,1,3).
s(100000002,1,'at',n,1,2).
EOF

cat > /tmp/test_puzzle.txt << 'EOF'
c
a
t
EOF

OUTPUT=$(./applequartile --debug --dictionary /tmp/test_dict.pl --puzzle /tmp/test_puzzle.txt 2>&1)
if echo "$OUTPUT" | grep -q "Loaded.*words into trie"; then
    log_pass "Debug mode works correctly"
else
    log_fail "Debug mode output missing"
fi

rm -f /tmp/test_dict.pl /tmp/test_puzzle.txt

# Test 8: Verify word finding
log_test "Testing word finding functionality"
cat > /tmp/test_dict.pl << 'EOF'
s(100000001,1,'cat',n,1,3).
s(100000002,1,'at',n,1,2).
s(100000003,1,'act',v,1,3).
EOF

cat > /tmp/test_puzzle.txt << 'EOF'
c
a
t
EOF

OUTPUT=$(./applequartile --dictionary /tmp/test_dict.pl --puzzle /tmp/test_puzzle.txt 2>&1)
if echo "$OUTPUT" | grep -q "cat" && echo "$OUTPUT" | grep -q "at"; then
    log_pass "Successfully found words in puzzle"
else
    log_fail "Failed to find expected words"
fi

rm -f /tmp/test_dict.pl /tmp/test_puzzle.txt

################################################################################
# GUI Launch Tests
################################################################################

log_test "Testing Streamlit can import"
if command -v python3 &> /dev/null; then
    cd streamlit_app
    if [ -d "venv" ]; then
        # shellcheck source=/dev/null
        source venv/bin/activate
        if python3 -c "import app; print('✅ Streamlit app imports successfully')" &> /dev/null; then
            log_pass "Streamlit app imports successfully"
        else
            log_fail "Streamlit app import failed"
        fi
        deactivate 2>/dev/null || true
    else
        echo -e "${YELLOW}⊘${NC} Streamlit venv not found, skipping test (run ./scripts/setup-web.sh to set up)"
    fi
    cd ..
else
    echo -e "${YELLOW}⊘${NC} Python not installed, skipping Streamlit test"
fi

log_test "Testing Flutter web can build"
if command -v flutter &> /dev/null; then
    cd quartile_solver_web
    if [ -f "assets/wn_s.pl" ]; then
        if flutter build web --release &> /tmp/flutter_build.log; then
            log_pass "Flutter web builds successfully"
        else
            log_fail "Flutter web build failed"
            cat /tmp/flutter_build.log
        fi
    else
        echo -e "${YELLOW}⊘${NC} Flutter assets/wn_s.pl not found, skipping test (run ./scripts/setup-web.sh to set up)"
    fi
    cd ..
else
    echo -e "${YELLOW}⊘${NC} Flutter not installed, skipping GUI test"
fi

# Summary
echo ""
if [ $FAILURES -eq 0 ]; then
    echo -e "${GREEN}✅ All E2E tests passed!${NC}"
    exit 0
else
    echo -e "${RED}❌ $FAILURES E2E test(s) failed${NC}"
    exit 1
fi

