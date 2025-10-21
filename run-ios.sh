#!/bin/bash

# iOS Quick Runner
# Usage: ./run-ios.sh [debug|release|profile]
 
set -e

MODE=${1:-debug}

echo "🍎 FoodEx - iOS Runner"
echo "====================="

# Check if on macOS
if [[ "$OSTYPE" != "darwin"* ]]; then
    echo "❌ iOS development requires macOS"
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

# Check for iOS devices/simulators
echo "📱 Checking for iOS devices..."
flutter devices | grep -i ios || {
    echo "⚠️ No iOS devices/simulators found."
    echo "🚀 Opening iOS Simulator..."
    open -a Simulator
    echo "⏳ Waiting for simulator to start..."
    sleep 10
}

# Update pods
echo "📦 Updating iOS dependencies..."
cd ios && pod install --repo-update && cd ..

# Run based on mode
case $MODE in
    "release")
        echo "🏗️ Building iOS app (Release)..."
        flutter build ios --release --no-codesign
        echo "✅ iOS app built: build/ios/iphoneos/Runner.app"
        echo "📝 Note: Code signing required for device deployment"
        ;;
    "profile")
        echo "📊 Running iOS app (Profile mode)..."
        flutter run -d ios --profile
        ;;
    *)
        echo "🐛 Running iOS app (Debug mode)..."
        flutter run -d ios --debug --hot
        ;;
esac

echo "✅ iOS execution completed!"