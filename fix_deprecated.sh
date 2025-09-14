#!/bin/bash

# Fix deprecated withOpacity usage in Flutter codebase
# Replace .withOpacity(value) with .withValues(alpha: value)

echo "🔧 Fixing deprecated withOpacity usage..."

# Find all Dart files and replace withOpacity with withValues
find lib/ -name "*.dart" -type f -exec sed -i '' 's/\.withOpacity(\([^)]*\))/.withValues(alpha: \1)/g' {} \;

echo "✅ Fixed withOpacity deprecation warnings"

# Fix async BuildContext usage by adding mounted checks
echo "🔧 Fixing async BuildContext usage..."

# This is more complex and needs manual review, so we'll just report the locations
echo "⚠️  Manual review needed for async BuildContext usage in:"
grep -n "Don't use 'BuildContext's across async gaps" analyze_output.txt 2>/dev/null || echo "   No async context issues found"

echo "🎉 Deprecation fixes complete!"
