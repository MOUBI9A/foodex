#!/bin/bash

# Final import fixes for specific issues
cd "$(dirname "$0")/.."

echo "🔧 Final import path fixes..."

# Fix service_call imports within core
sed -i '' 's|package:food_delivery/core/utils/globs.dart|package:food_delivery/core/constants/globs.dart|g' lib/core/network/service_call.dart

# Fix main.dart imports
sed -i '' 's|package:food_delivery/core/color_extension.dart|package:food_delivery/core/theme/color_extension.dart|g' lib/main.dart
sed -i '' 's|package:food_delivery/core/locator.dart|package:food_delivery/core/utils/locator.dart|g' lib/main.dart
sed -i '' 's|common/my_http_overrides.dart|core/network/my_http_overrides.dart|g' lib/main.dart

# Fix extension imports
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/core/utils/extension.dart|package:food_delivery/core/utils/extensions.dart|g' {} \;

# Fix malformed imports that got corrupted
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/presentati../../widgets/|package:food_delivery/presentation/widgets/|g' {} \;

# Fix widget import paths
find lib/presentation/pages -name "*.dart" -exec sed -i '' 's|../widgets/|../../widgets/|g' {} \;

echo "✅ Final import fixes completed!"
