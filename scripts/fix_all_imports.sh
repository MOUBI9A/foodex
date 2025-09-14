#!/bin/bash

# Comprehensive Import Fix Script for Clean Architecture
echo "🔧 Fixing all import paths for Clean Architecture..."

cd "$(dirname "$0")/.."

# Fix color_extension imports (now in core/theme)
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/color_extension.dart|package:food_delivery/core/theme/color_extension.dart|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../common/color_extension.dart|../../core/theme/color_extension.dart|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../../common/color_extension.dart|../../core/theme/color_extension.dart|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../../../common/color_extension.dart|../../core/theme/color_extension.dart|g' {} \;

# Fix extension imports (now extensions.dart in core/utils)
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/extension.dart|package:food_delivery/core/utils/extensions.dart|g' {} \;

# Fix globs imports (now in core/constants)
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/globs.dart|package:food_delivery/core/constants/globs.dart|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../../common/globs.dart|../../core/constants/globs.dart|g' {} \;

# Fix service_call imports (now in core/network)
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/service_call.dart|package:food_delivery/core/network/service_call.dart|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../../common/service_call.dart|../../core/network/service_call.dart|g' {} \;

# Fix common_widget imports (now in presentation/widgets)
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/common_widget/|package:food_delivery/presentation/widgets/|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../../common_widget/|../widgets/|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../common_widget/|../widgets/|g' {} \;

# Fix view imports (now in presentation/pages)
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/view/|package:food_delivery/presentation/pages/|g' {} \;

# Fix models imports (now in data/models)
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/models/|package:food_delivery/data/models/|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../../models/|../../data/models/|g' {} \;

# Fix services imports (now in data/repositories)
find lib -name "*.dart" -exec sed -i '' 's|package:food_delivery/services/|package:food_delivery/data/repositories/|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../../services/|../../data/repositories/|g' {} \;

# Fix complex widget imports
find lib -name "*.dart" -exec sed -i '' 's|../widgets/round_textfield.dart|../../widgets/round_textfield.dart|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../widgets/round_button.dart|../../widgets/round_button.dart|g' {} \;
find lib -name "*.dart" -exec sed -i '' 's|../widgets/menu_item_row.dart|../../widgets/menu_item_row.dart|g' {} \;

# Fix main.dart imports
sed -i '' 's|package:food_delivery/common/|package:food_delivery/core/|g' lib/main.dart
sed -i '' 's|package:food_delivery/view/|package:food_delivery/presentation/pages/|g' lib/main.dart

# Fix test imports
find test -name "*.dart" -exec sed -i '' 's|package:food_delivery/common/locator.dart|package:food_delivery/core/utils/locator.dart|g' {} \;
find test -name "*.dart" -exec sed -i '' 's|package:food_delivery/view/|package:food_delivery/presentation/pages/|g' {} \;

echo "✅ All import paths have been updated!"
