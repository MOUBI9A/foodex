#!/bin/bash

# Android Quick Runner
# Usage: ./run-android.sh [debug|release|profile]

set -e

MODE=${1:-debug}

echo "🤖 FoodEx - Android Runner"
echo "=========================="

# Check for Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

# Clean and prepare
echo "🔧 Preparing project..."
flutter clean
flutter pub get

# Check for devices/emulators
echo "📱 Checking for Android devices..."
flutter devices | grep -i android || {
    echo "⚠️ No Android devices found. Available emulators:"
    flutter emulators
    echo ""
    echo "💡 To start an emulator:"
    echo "   flutter emulators --launch <emulator_name>"
    echo ""
    echo "🚀 Starting default emulator..."
    flutter emulators --launch Pixel_7_Pro_API_34 || {
        echo "❌ Failed to start emulator. Please start one manually."
        exit 1
    }
    echo "⏳ Waiting for emulator to boot..."
    sleep 15
}

# Run based on mode
case $MODE in
    "release")
        echo "🏗️ Building Android APK (Release)..."
        flutter build apk --release
        echo "✅ APK built: build/app/outputs/flutter-apk/app-release.apk"
        echo "📱 Installing APK..."
        flutter install --device-id=$(flutter devices | grep android | head -1 | cut -d'•' -f2 | xargs)
        ;;
    "profile")
        echo "📊 Running Android app (Profile mode)..."
        flutter run -d android --profile
        ;;
    *)
        echo "🐛 Running Android app (Debug mode)..."
        flutter run -d android --debug --hot
        ;;
esac

echo "✅ Android execution completed!"