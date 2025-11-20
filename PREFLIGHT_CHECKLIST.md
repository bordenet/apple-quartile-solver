# Pre-Flight Checklist

**Purpose**: Prevent shipping broken code by verifying all components work end-to-end before pushing to main.

**When to use**: Before every commit to main, especially before claiming "production ready" or "A+ quality."

---

## ✅ 1. Build All Components

```bash
# Go CLI
go build -o applequartile
./applequartile --version || echo "Binary works: ✓"

# Flutter Web
cd quartile_solver_web
flutter build web --release
cd ..

# Streamlit (verify imports)
cd streamlit_app
python3 -c "import app; print('✅ Streamlit imports work')"
cd ..
```

**Expected**: All builds succeed, no errors.

---

## ✅ 2. Run All Automated Tests

```bash
# Go tests
go test -v -cover

# Python tests
cd streamlit_app
source venv/bin/activate
pytest test_solver.py -v
cd ..

# Flutter tests
cd quartile_solver_web
flutter test
cd ..

# E2E tests
./test_e2e.sh
```

**Expected**: All tests pass, coverage ≥70%.

---

## ✅ 3. Verify GUIs Actually Launch

### Streamlit
```bash
cd streamlit_app
source venv/bin/activate
timeout 10 streamlit run app.py --server.headless=true &
sleep 5
curl -s http://localhost:8501 | grep -q "Apple Quartile" && echo "✅ Streamlit loads"
pkill -f streamlit
cd ..
```

### Flutter Web
```bash
cd quartile_solver_web
flutter run -d web-server --web-port=8502 &
FLUTTER_PID=$!
sleep 10
curl -s http://localhost:8502 | grep -q "<!DOCTYPE html>" && echo "✅ Flutter loads"
kill $FLUTTER_PID
cd ..
```

**Expected**: Both GUIs start and serve content.

---

## ✅ 4. Test Sample Puzzles in CLI

```bash
for i in 1 2 3 4 5; do
    echo "Testing puzzle$i.txt..."
    ./applequartile --dictionary ./prolog/wn_s.pl --puzzle ./samples/puzzle$i.txt | head -5
done
```

**Expected**: All 5 puzzles solve successfully.

---

## ✅ 5. Verify Documentation Accuracy

- [ ] README Quick Start instructions work exactly as written
- [ ] All hyperlinks resolve (no 404s)
- [ ] Version numbers match actual requirements
- [ ] Code examples run without modification
- [ ] File line counts are current (if mentioned)

---

## ✅ 6. Check for Common Issues

```bash
# No TODO/FIXME in production code
grep -r "TODO\|FIXME\|HACK" --include="*.go" --include="*.py" --include="*.dart" . | grep -v test

# No hardcoded paths
grep -r "/Users/\|C:\\\\" --include="*.go" --include="*.py" --include="*.dart" .

# No committed secrets
git diff --cached | grep -i "password\|secret\|api_key\|token"

# All required files exist
test -f prolog/wn_s.pl || echo "❌ Dictionary missing"
test -f quartile_solver_web/assets/wn_s.pl || echo "❌ Flutter assets missing"
```

**Expected**: No issues found.

---

## ✅ 7. Validate Code Quality

```bash
./scripts/validate.sh
```

**Expected**: All checks pass.

---

## ✅ 8. Test Setup Scripts

```bash
# In a clean directory, verify setup scripts work
./scripts/setup-go.sh
./scripts/setup-web.sh
```

**Expected**: Scripts complete successfully, all dependencies installed.

---

## ✅ 9. Verify CI Will Pass

```bash
# Run the same checks CI will run
go test -v -cover
go vet ./...
cd streamlit_app && pytest && cd ..
cd quartile_solver_web && flutter analyze && flutter test && cd ..
```

**Expected**: All CI checks pass locally.

---

## ✅ 10. Final Smoke Test

1. **CLI**: Solve a puzzle from scratch
2. **Streamlit**: Open in browser, load sample, solve, verify results
3. **Flutter**: Open in browser, load sample, solve, verify results

**Expected**: All three interfaces work perfectly.

---

## 🚀 Ready to Ship

If all 10 checks pass:
```bash
git add .
git commit -m "Your descriptive commit message"
git push origin main
```

Then monitor GitHub Actions to ensure CI passes.

---

## 📝 Notes

- **Never skip this checklist** before pushing to main
- **Especially important** before tagging releases or sharing with colleagues
- **Update this checklist** as new components are added
- **Automate what you can** - consider adding these checks to pre-commit hooks

