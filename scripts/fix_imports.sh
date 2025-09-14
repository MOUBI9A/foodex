#!/bin/bash

# Fix Import Paths After Project Reorganization
echo "🔧 Fixing import paths after Clean Architecture reorganization..."

# Navigate to project root
cd "$(dirname "$0")/.."

# Fix imports in presentation layer
echo "📁 Fixing presentation layer imports..."

# Update color_extension imports
find lib/presentation -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/color_extension.dart|package:food_delivery/core/theme/color_extension.dart|g' {} \;
find lib/presentation -name "*.dart" -exec sed -i '' 's|../common/color_extension.dart|../../core/theme/color_extension.dart|g' {} \;
find lib/presentation -name "*.dart" -exec sed -i '' 's|../../common/color_extension.dart|../../core/theme/color_extension.dart|g' {} \;

# Update extension imports
find lib/presentation -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/extension.dart|package:food_delivery/core/utils/extension.dart|g' {} \;

# Update globs imports
find lib/presentation -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/globs.dart|package:food_delivery/core/constants/globs.dart|g' {} \;
find lib/presentation -name "*.dart" -exec sed -i '' 's|../../common/globs.dart|../../core/constants/globs.dart|g' {} \;

# Update service_call imports
find lib/presentation -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/service_call.dart|package:food_delivery/core/network/service_call.dart|g' {} \;
find lib/presentation -name "*.dart" -exec sed -i '' 's|../../common/service_call.dart|../../core/network/service_call.dart|g' {} \;

# Update common_widget imports
find lib/presentation -name "*.dart" -exec sed -i '' 's|package:food_delivery/common_widget/|package:food_delivery/presentation/widgets/|g' {} \;
find lib/presentation -name "*.dart" -exec sed -i '' 's|../../common_widget/|../widgets/|g' {} \;
find lib/presentation -name "*.dart" -exec sed -i '' 's|../common_widget/|../widgets/|g' {} \;

# Update view imports to presentation/pages
find lib/presentation -name "*.dart" -exec sed -i '' 's|package:food_delivery/view/|package:food_delivery/presentation/pages/|g' {} \;

# Update models imports
find lib/presentation -name "*.dart" -exec sed -i '' 's|package:food_delivery/models/|package:food_delivery/data/models/|g' {} \;
find lib/presentation -name "*.dart" -exec sed -i '' 's|../../models/|../../data/models/|g' {} \;

# Update services imports
find lib/presentation -name "*.dart" -exec sed -i '' 's|package:food_delivery/services/|package:food_delivery/data/repositories/|g' {} \;
find lib/presentation -name "*.dart" -exec sed -i '' 's|../../services/|../../data/repositories/|g' {} \;

echo "📁 Fixing core layer imports..."

# Fix imports in core layer
find lib/core -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/|package:food_delivery/core/utils/|g' {} \;

echo "📁 Fixing data layer imports..."

# Fix imports in data layer
find lib/data -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/|package:food_delivery/core/utils/|g' {} \;

echo "📁 Fixing main.dart imports..."

# Fix main.dart imports
sed -i '' 's|package:food_delivery/common/|package:food_delivery/core/|g' lib/main.dart
sed -i '' 's|package:food_delivery/view/|package:food_delivery/presentation/pages/|g' lib/main.dart

echo "📁 Fixing test imports..."

# Fix test imports
find test -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/|package:food_delivery/core/|g' {} \;
find test -name "*.dart" -exec sed -i '' 's|package:food_delivery/view/|package:food_delivery/presentation/pages/|g' {} \;

echo "✅ Import fixes completed!"
echo "🧪 Running dart analyze to check for remaining issues..."

dart analyze --no-fatal-infos --no-fatal-warnings
