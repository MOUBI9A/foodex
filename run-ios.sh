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
# Extract device ID from flutter devices output (field between • symbols)
IOS_DEVICE=$(flutter devices | grep -i "ios" | head -1 | sed 's/.*• \([^ ]*\) •.*/\1/')

if [ -z "$IOS_DEVICE" ]; then
    echo "⚠️ No iOS devices/simulators found."
    echo "🚀 Opening iOS Simulator..."
    open -a Simulator
    echo "⏳ Waiting for simulator to start..."
    sleep 10
    
    # Try to get device again
    IOS_DEVICE=$(flutter devices | grep -i "ios" | head -1 | sed 's/.*• \([^ ]*\) •.*/\1/')
    
    if [ -z "$IOS_DEVICE" ]; then
        echo "❌ No iOS devices available. Please start a simulator manually."
        exit 1
    fi
fi

echo "📱 Using device: $IOS_DEVICE"
flutter devices | grep -i ios

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
        flutter run -d "$IOS_DEVICE" --profile
        ;;
    *)
        echo "🐛 Running iOS app (Debug mode)..."
        flutter run -d "$IOS_DEVICE" --debug --hot
        ;;
esac

echo "✅ iOS execution completed!"