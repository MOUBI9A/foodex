#!/bin/bash

cd "$(dirname "$0")/.."

echo "🔧 Final comprehensive import cleanup..."

# Step 1: Fix all malformed imports first
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/presentati../../widgets/|package:food_delivery/presentation/widgets/|g' {} \;

# Step 2: Fix relative widget imports for pages in subdirectories
find lib/presentation/pages -name "*.dart" -exec sed -i '' 's|../widgets/|../../widgets/|g' {} \;
find lib/presentation/pages -name "*.dart" -exec sed -i '' 's|../../../widgets/|../../widgets/|g' {} \;

# Step 3: Fix core imports that are incorrect
find lib/presentation/pages -name "*.dart" -exec sed -i '' 's|../../core/constants/globs.dart|../../../core/constants/globs.dart|g' {} \;
find lib/presentation/pages -name "*.dart" -exec sed -i '' 's|../../core/network/service_call.dart|../../../core/network/service_call.dart|g' {} \;

# Step 4: Fix import paths for deeper nested directories (3 levels deep)
find lib/presentation/pages/*/. -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;
find lib/presentation/pages/*/. -name "*.dart" -exec sed -i '' 's|../../../core/|../../../../core/|g' {} \;

# Step 5: Specifically fix login folder imports (4 levels deep)
find lib/presentation/pages/login -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;
find lib/presentation/pages/login -name "*.dart" -exec sed -i '' 's|../../core/|../../../core/|g' {} \;

# Step 6: Fix more folder imports (4 levels deep)
find lib/presentation/pages/more -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;
find lib/presentation/pages/more -name "*.dart" -exec sed -i '' 's|../../core/|../../../core/|g' {} \;

find lib/presentation/pages/menu -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;

find lib/presentation/pages/profile -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;

find lib/presentation/pages/wallet -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;

find lib/presentation/pages/offer -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;

find lib/presentation/pages/chef -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;

find lib/presentation/pages/driver -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;

find lib/presentation/pages/home -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;

find lib/presentation/pages/on_boarding -name "*.dart" -exec sed -i '' 's|../../widgets/|../../../widgets/|g' {} \;

echo "✅ Comprehensive import cleanup completed!"
