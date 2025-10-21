#!/bin/bash

# Linux Quick Runner
# Usage: ./run-linux.sh [debug|release|profile]

set -e

MODE=${1:-debug}

echo "🐧 FoodEx - Linux Runner"
echo "========================"

# Check for Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

# Clean and prepare
echo "🔧 Preparing project..."
flutter clean
flutter pub get

# Enable Linux if not enabled
echo "🐧 Enabling Linux support..."
flutter config --enable-linux-desktop

# Install Linux dependencies if needed
echo "📦 Checking Linux dependencies..."
sudo apt-get update > /dev/null 2>&1 || true
sudo apt-get install -y clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev > /dev/null 2>&1 || {
    echo "⚠️ Some dependencies might be missing. Please install manually:"
    echo "   sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev liblzma-dev"
}

# Run based on mode
case $MODE in
    "release")
        echo "🏗️ Building Linux app (Release)..."
        flutter build linux --release
        echo "✅ Linux app built: build/linux/x64/release/bundle/"
        echo "🚀 Launching app..."
        ./build/linux/x64/release/bundle/food_delivery &
        ;;
    "profile")
        echo "📊 Running Linux app (Profile mode)..."
        flutter run -d linux --profile
        ;;
    *)
        echo "🐛 Running Linux app (Debug mode)..."
        flutter run -d linux --debug --hot
        ;;
esac

echo "✅ Linux execution completed!"