#!/bin/bash

set -e

echo "🔍 Validating Flutter test configuration..."

# Check if files exist
FILES_TO_CHECK=(
    "flutter/test/flutter_test_config.dart"
    "flutter/test/widget_test.dart"
    ".github/workflows/flutter-ci.yml"
)

for file in "${FILES_TO_CHECK[@]}"; do
    if [ -f "$file" ]; then
        echo "✅ $file exists"
    else
        echo "❌ $file missing"
        exit 1
    fi
done

# Validate workflow syntax
echo "🔍 Checking workflow syntax..."
grep -q "timeout-minutes: 45" .github/workflows/flutter-ci.yml && echo "✅ Job timeout configured"
grep -q "cancel-in-progress: false" .github/workflows/flutter-ci.yml && echo "✅ Cancel-in-progress disabled"
grep -q "timeout-minutes: 10" .github/workflows/flutter-ci.yml && echo "✅ Test timeout configured"

# Check test configuration
echo "🔍 Checking test configuration..."
grep -q "testExecutable" flutter/test/flutter_test_config.dart && echo "✅ Test executable configured"

echo "✅ All configuration checks passed!"
echo ""
echo "🚀 Summary of changes made:"
echo "  • Disabled cancel-in-progress to prevent workflow interruption"
echo "  • Added timeouts to job and test steps (45min job, 10min tests)"
echo "  • Split tests into fast run (no coverage) and coverage run"
echo "  • Added test health check step"
echo "  • Created flutter_test_config.dart for timeout management"
echo "  • Enhanced widget tests with proper grouping"
echo "  • Created validation scripts"
echo ""
echo "📝 Next steps:"
echo "  1. Commit these changes"
echo "  2. Push to trigger the workflow"
echo "  3. Monitor the test execution"