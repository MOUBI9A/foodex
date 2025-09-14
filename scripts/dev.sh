#!/bin/bash

# FoodEx Development Setup Script
# This script helps with common development tasks

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

# Check if Flutter is installed
check_flutter() {
    if ! command -v flutter &> /dev/null; then
        print_error "Flutter is not installed. Please install Flutter first."
        exit 1
    fi
    print_success "Flutter is installed: $(flutter --version | head -n1)"
}

# Clean and get dependencies
setup_dependencies() {
    print_status "Cleaning and getting dependencies..."
    flutter clean
    flutter pub get
    print_success "Dependencies setup complete"
}

# Check for issues
analyze_code() {
    print_status "Analyzing code..."
    flutter analyze
    print_success "Code analysis complete"
}

# Run tests
run_tests() {
    print_status "Running tests..."
    flutter test
    print_success "Tests completed"
}

# Build for specific platform
build_platform() {
    local platform=$1
    print_status "Building for $platform..."
    
    case $platform in
        "android")
            flutter build apk --release
            print_success "Android APK built successfully"
            ;;
        "ios")
            flutter build ios --release --no-codesign
            print_success "iOS build completed"
            ;;
        "web")
            flutter build web --release
            print_success "Web build completed"
            ;;
        "macos")
            flutter build macos --release
            print_success "macOS build completed"
            ;;
        "windows")
            flutter build windows --release
            print_success "Windows build completed"
            ;;
        "linux")
            flutter build linux --release
            print_success "Linux build completed"
            ;;
        *)
            print_error "Unknown platform: $platform"
            exit 1
            ;;
    esac
}

# Main script logic
main() {
    echo "🍽️  FoodEx Development Script"
    echo "=============================="
    
    case "${1:-help}" in
        "setup")
            check_flutter
            setup_dependencies
            analyze_code
            print_success "Setup complete! You can now run 'flutter run' to start the app."
            ;;
        "clean")
            print_status "Cleaning project..."
            flutter clean
            flutter pub get
            print_success "Project cleaned and dependencies refreshed"
            ;;
        "analyze")
            analyze_code
            ;;
        "test")
            run_tests
            ;;
        "build")
            if [ -z "$2" ]; then
                print_error "Please specify a platform: android, ios, web, macos, windows, linux"
                exit 1
            fi
            check_flutter
            build_platform "$2"
            ;;
        "build-all")
            check_flutter
            print_status "Building for all platforms..."
            build_platform "android"
            build_platform "ios"
            build_platform "web"
            build_platform "macos"
            build_platform "windows"
            build_platform "linux"
            print_success "All builds completed!"
            ;;
        "help"|*)
            echo "Usage: $0 <command> [options]"
            echo ""
            echo "Commands:"
            echo "  setup        - Set up the project dependencies and check for issues"
            echo "  clean        - Clean the project and refresh dependencies"
            echo "  analyze      - Run Flutter analyzer"
            echo "  test         - Run all tests"
            echo "  build <platform> - Build for specific platform (android, ios, web, macos, windows, linux)"
            echo "  build-all    - Build for all platforms"
            echo "  help         - Show this help message"
            echo ""
            echo "Examples:"
            echo "  $0 setup"
            echo "  $0 build android"
            echo "  $0 build-all"
            ;;
    esac
}

# Run the main function with all arguments
main "$@"
