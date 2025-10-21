#!/bin/bash

# FoodEx Project Runner - Master Script
# Usage: ./run.sh [platform] [mode]
# Platforms: android, ios, web, macos, windows, linux
# Modes: debug, release, profile

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Project info
PROJECT_NAME="FoodEx"
echo -e "${BLUE}🍕 $PROJECT_NAME - Flutter Application Runner${NC}"
echo -e "${BLUE}================================================${NC}"

# Function to print colored output
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
    
    print_status "Flutter found: $(flutter --version | head -n 1)"
}

# Check Flutter doctor
check_flutter_doctor() {
    print_info "Running Flutter doctor..."
    flutter doctor
}

# Get available devices
get_devices() {
    print_info "Available devices:"
    flutter devices
}

# Clean and get dependencies
prepare_project() {
    print_info "Cleaning project..."
    flutter clean
    
    print_info "Getting dependencies..."
    flutter pub get
}

# Run on specific platform
run_platform() {
    local platform=$1
    local mode=${2:-debug}
    
    case $platform in
        "android")
            run_android $mode
            ;;
        "ios")
            run_ios $mode
            ;;
        "web")
            run_web $mode
            ;;
        "macos")
            run_macos $mode
            ;;
        "windows")
            run_windows $mode
            ;;
        "linux")
            run_linux $mode
            ;;
        *)
            show_help
            ;;
    esac
}

# Android runner
run_android() {
    local mode=$1
    print_info "🤖 Running on Android in $mode mode..."
    
    # Check for Android devices
    local android_devices=$(flutter devices | grep -i android)
    if [ -z "$android_devices" ]; then
        print_warning "No Android devices found. Starting emulator..."
        # Try to start an emulator
        flutter emulators --launch Pixel_7_Pro_API_34 || {
            print_error "Failed to start Android emulator"
            print_info "Available emulators:"
            flutter emulators
            exit 1
        }
        sleep 10
    fi
    
    if [ "$mode" = "release" ]; then
        print_info "Building Android APK in release mode..."
        flutter build apk --release
        print_status "APK built successfully: build/app/outputs/flutter-apk/app-release.apk"
    else
        flutter run -d android --$mode
    fi
}

# iOS runner
run_ios() {
    local mode=$1
    print_info "🍎 Running on iOS in $mode mode..."
    
    # Check if on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "iOS development requires macOS"
        exit 1
    fi
    
    # Check for iOS devices/simulators
    local ios_devices=$(flutter devices | grep -i ios)
    if [ -z "$ios_devices" ]; then
        print_warning "No iOS devices/simulators found. Opening iOS Simulator..."
        open -a Simulator
        sleep 5
    fi
    
    if [ "$mode" = "release" ]; then
        print_info "Building iOS app in release mode..."
        flutter build ios --release --no-codesign
        print_status "iOS app built successfully: build/ios/iphoneos/Runner.app"
    else
        flutter run -d ios --$mode
    fi
}

# Web runner
run_web() {
    local mode=$1
    print_info "🌐 Running on Web in $mode mode..."
    
    local port=${WEB_PORT:-3000}
    
    if [ "$mode" = "release" ]; then
        print_info "Building web app in release mode..."
        flutter build web --release
        print_status "Web app built successfully: build/web"
        print_info "You can serve it with: python -m http.server 8000 -d build/web"
    else
        print_info "Starting web development server on http://localhost:$port"
        flutter run -d chrome --web-port=$port --$mode
    fi
}

# macOS runner
run_macos() {
    local mode=$1
    print_info "🖥️  Running on macOS in $mode mode..."
    
    # Check if on macOS
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_error "macOS development requires macOS"
        exit 1
    fi
    
    if [ "$mode" = "release" ]; then
        print_info "Building macOS app in release mode..."
        flutter build macos --release
        print_status "macOS app built successfully: build/macos/Build/Products/Release/food_delivery.app"
    else
        flutter run -d macos --$mode
    fi
}

# Windows runner
run_windows() {
    local mode=$1
    print_info "🪟 Running on Windows in $mode mode..."
    
    if [ "$mode" = "release" ]; then
        print_info "Building Windows app in release mode..."
        flutter build windows --release
        print_status "Windows app built successfully: build/windows/runner/Release/"
    else
        flutter run -d windows --$mode
    fi
}

# Linux runner
run_linux() {
    local mode=$1
    print_info "🐧 Running on Linux in $mode mode..."
    
    if [ "$mode" = "release" ]; then
        print_info "Building Linux app in release mode..."
        flutter build linux --release
        print_status "Linux app built successfully: build/linux/x64/release/bundle/"
    else
        flutter run -d linux --$mode
    fi
}

# Show help
show_help() {
    echo -e "${YELLOW}Usage: ./run.sh [platform] [mode]${NC}"
    echo ""
    echo -e "${YELLOW}Platforms:${NC}"
    echo "  android    - Run on Android device/emulator"
    echo "  ios        - Run on iOS device/simulator (macOS only)"
    echo "  web        - Run in web browser"
    echo "  macos      - Run on macOS (macOS only)"
    echo "  windows    - Run on Windows"
    echo "  linux      - Run on Linux"
    echo ""
    echo -e "${YELLOW}Modes:${NC}"
    echo "  debug      - Debug mode (default)"
    echo "  release    - Release mode (optimized)"
    echo "  profile    - Profile mode (performance analysis)"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  ./run.sh android debug"
    echo "  ./run.sh ios release"
    echo "  ./run.sh web"
    echo "  ./run.sh macos profile"
    echo ""
    echo -e "${YELLOW}Special Commands:${NC}"
    echo "  ./run.sh doctor      - Run Flutter doctor"
    echo "  ./run.sh devices     - Show available devices"
    echo "  ./run.sh clean       - Clean and prepare project"
    echo ""
    echo -e "${YELLOW}Environment Variables:${NC}"
    echo "  WEB_PORT=3000       - Set web server port (default: 3000)"
}

# Main script logic
main() {
    check_flutter
    
    case $1 in
        "doctor")
            check_flutter_doctor
            ;;
        "devices")
            get_devices
            ;;
        "clean")
            prepare_project
            ;;
        "help"|"--help"|"-h")
            show_help
            ;;
        "")
            echo -e "${YELLOW}No platform specified. Showing available devices:${NC}"
            get_devices
            echo ""
            show_help
            ;;
        *)
            prepare_project
            run_platform $1 $2
            ;;
    esac
}

# Run main function with all arguments
main "$@"