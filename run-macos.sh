#!/bin/bash

# macOS Quick Runner
# Usage: ./run-macos.sh [debug|release|profile]

set -e

MODE=${1:-debug}

echo "🖥️ FoodEx - macOS Runner"
echo "========================"

# Check if on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ macOS development requires macOS"
    exit 1
fi

# Check for Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

# Clean and prepare
echo "🔧 Preparing project..."
flutter clean
flutter pub get

# Enable macOS if not enabled
echo "🖥️ Enabling macOS support..."
flutter config --enable-macos-desktop

# Update pods
echo "📦 Updating macOS dependencies..."
cd macos && pod install --repo-update && cd ..

# Run based on mode
case $MODE in
    "release")
        echo "🏗️ Building macOS app (Release)..."
        flutter build macos --release
        echo "✅ macOS app built: build/macos/Build/Products/Release/food_delivery.app"
        echo "🚀 Launching app..."
        open build/macos/Build/Products/Release/food_delivery.app
        ;;
    "profile")
        echo "📊 Running macOS app (Profile mode)..."
        flutter run -d macos --profile
        ;;
    *)
        echo "🐛 Running macOS app (Debug mode)..."
        flutter run -d macos --debug --hot
        ;;
esac

echo "✅ macOS execution completed!"