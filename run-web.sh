#!/bin/bash

# Web Quick Runner
# Usage: ./run-web.sh [debug|release|profile] [port]

set -e

MODE=${1:-debug}
PORT=${2:-3000}

echo "🌐 FoodEx - Web Runner"
echo "====================="

# Check for Flutter
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter not found. Please install Flutter first."
    exit 1
fi

# Clean and prepare
echo "🔧 Preparing project..."
flutter clean
flutter pub get

# Enable web if not enabled
echo "🌐 Enabling web support..."
flutter config --enable-web

# Run based on mode
case $MODE in
    "release")
        echo "🏗️ Building web app (Release)..."
        flutter build web --release
        echo "✅ Web app built: build/web"
        echo ""
        echo "📡 Serving web app locally..."
        echo "🌐 Open: http://localhost:8080"
        cd build/web && python3 -m http.server 8080 || python -m http.server 8080
        ;;
    "profile")
        echo "📊 Running web app (Profile mode)..."
        echo "🌐 Opening: http://localhost:$PORT"
        flutter run -d web-server --profile --web-port=$PORT
        ;;
    *)
        echo "🐛 Running web app (Debug mode)..."
        echo "🌐 Opening: http://localhost:$PORT"
        flutter run -d web-server --debug --hot --web-port=$PORT
        ;;
esac

echo "✅ Web execution completed!"