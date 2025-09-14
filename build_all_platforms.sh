#!/bin/bash

# FoodEx - Multi-Platform Build Script
# Created by: MOUBI9A
# Date: September 14, 2025

echo "🍽️  FoodEx - Multi-Platform Build Script"
echo "========================================"
echo ""

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "\n${PURPLE}=== $1 ===${NC}"
}

# Check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed or not in PATH"
        exit 1
    fi
    
    print_status "Flutter version:"
    flutter --version
    echo ""
}

# Clean previous builds
clean_project() {
    print_header "Cleaning Project"
    flutter clean
    flutter pub get
    print_success "Project cleaned and dependencies installed"
}

# Build for Android
build_android() {
    print_header "Building for Android"
    
    # Build APK
    print_status "Building APK..."
    if flutter build apk --release --target-platform android-arm64; then
        print_success "APK built successfully: build/app/outputs/flutter-apk/app-release.apk"
    else
        print_error "APK build failed"
        return 1
    fi
    
    # Build App Bundle (for Google Play Store)
    print_status "Building App Bundle..."
    if flutter build appbundle --release; then
        print_success "App Bundle built successfully: build/app/outputs/bundle/release/app-release.aab"
    else
        print_error "App Bundle build failed"
        return 1
    fi
}

# Build for iOS
build_ios() {
    print_header "Building for iOS"
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_warning "iOS builds are only supported on macOS"
        return 1
    fi
    
    print_status "Building iOS app..."
    if flutter build ios --release --no-codesign; then
        print_success "iOS app built successfully: build/ios/iphoneos/Runner.app"
        print_status "Note: Code signing required for device deployment"
    else
        print_error "iOS build failed"
        return 1
    fi
}

# Build for Web
build_web() {
    print_header "Building for Web"
    
    print_status "Building web app..."
    if flutter build web --release --web-renderer html; then
        print_success "Web app built successfully: build/web/"
        print_status "You can serve this with any web server"
    else
        print_error "Web build failed"
        return 1
    fi
}

# Build for macOS
build_macos() {
    print_header "Building for macOS"
    
    if [[ "$OSTYPE" != "darwin"* ]]; then
        print_warning "macOS builds are only supported on macOS"
        return 1
    fi
    
    print_status "Building macOS app..."
    if flutter build macos --release; then
        print_success "macOS app built successfully: build/macos/Build/Products/Release/FoodEx.app"
    else
        print_error "macOS build failed"
        return 1
    fi
}

# Build for Windows
build_windows() {
    print_header "Building for Windows"
    
    if [[ "$OSTYPE" != "msys" && "$OSTYPE" != "cygwin" && "$OSTYPE" != "win32" ]]; then
        print_warning "Windows builds are only supported on Windows"
        return 1
    fi
    
    print_status "Building Windows app..."
    if flutter build windows --release; then
        print_success "Windows app built successfully: build/windows/x64/runner/Release/"
    else
        print_error "Windows build failed"
        return 1
    fi
}

# Build for Linux
build_linux() {
    print_header "Building for Linux"
    
    if [[ "$OSTYPE" != "linux-gnu"* ]]; then
        print_warning "Linux builds are only supported on Linux"
        return 1
    fi
    
    print_status "Building Linux app..."
    if flutter build linux --release; then
        print_success "Linux app built successfully: build/linux/x64/release/bundle/"
    else
        print_error "Linux build failed"
        return 1
    fi
}

# Show usage
show_usage() {
    echo "Usage: $0 [PLATFORM]"
    echo ""
    echo "Available platforms:"
    echo "  android  - Build APK and App Bundle for Android"
    echo "  ios      - Build for iOS (macOS only)"
    echo "  web      - Build for Web browsers"
    echo "  macos    - Build for macOS (macOS only)"
    echo "  windows  - Build for Windows (Windows only)"
    echo "  linux    - Build for Linux (Linux only)"
    echo "  all      - Build for all supported platforms"
    echo "  clean    - Clean project and install dependencies"
    echo ""
    echo "Examples:"
    echo "  $0 android"
    echo "  $0 web"
    echo "  $0 all"
}

# Main execution
main() {
    check_flutter
    
    case "$1" in
        "android")
            clean_project
            build_android
            ;;
        "ios")
            clean_project
            build_ios
            ;;
        "web")
            clean_project
            build_web
            ;;
        "macos")
            clean_project
            build_macos
            ;;
        "windows")
            clean_project
            build_windows
            ;;
        "linux")
            clean_project
            build_linux
            ;;
        "all")
            clean_project
            print_header "Building for All Supported Platforms"
            
            # Build for current platform
            if [[ "$OSTYPE" == "darwin"* ]]; then
                build_android
                build_ios
                build_web
                build_macos
            elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
                build_android
                build_web
                build_linux
            elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || "$OSTYPE" == "win32" ]]; then
                build_android
                build_web
                build_windows
            else
                print_warning "Unknown platform, building web only"
                build_web
            fi
            ;;
        "clean")
            clean_project
            ;;
        *)
            show_usage
            exit 1
            ;;
    esac
    
    print_header "Build Complete"
    print_success "FoodEx build process finished!"
    echo ""
    echo "📱 Mobile: APK/AAB files for Android, .app for iOS"
    echo "🌐 Web: Static files ready for web hosting"
    echo "💻 Desktop: Native executables for macOS/Windows/Linux"
    echo ""
    echo "Created by: MOUBI9A"
    echo "=============================================="
}

# Run main function with all arguments
main "$@"
