#!/bin/bash

# FoodEx Development Helper Script
# Common development tasks and utilities

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "🔧 FoodEx Development Helper"
    echo "============================"
    echo -e "${NC}"
}

print_success() {
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

# Clean project thoroughly
clean_project() {
    print_info "Cleaning project thoroughly..."
    
    flutter clean
    
    # Remove additional cache directories
    rm -rf .dart_tool
    rm -rf build
    rm -rf .flutter-plugins-dependencies
    rm -rf .packages
    
    # Clean iOS
    if [ -d "ios" ]; then
        cd ios
        rm -rf Pods
        rm -rf Podfile.lock
        rm -rf .symlinks
        cd ..
    fi
    
    # Clean Android
    if [ -d "android" ]; then
        cd android
        ./gradlew clean 2>/dev/null || true
        cd ..
    fi
    
    # Clean macOS
    if [ -d "macos" ]; then
        cd macos
        rm -rf Pods
        rm -rf Podfile.lock
        cd ..
    fi
    
    print_success "Project cleaned thoroughly"
}

# Setup project
setup_project() {
    print_info "Setting up project..."
    
    # Get dependencies
    flutter pub get
    
    # Generate platform configurations
    flutter config --enable-web
    flutter config --enable-macos-desktop
    flutter config --enable-windows-desktop
    flutter config --enable-linux-desktop
    
    # Update iOS pods if on macOS
    if [[ "$OSTYPE" == "darwin"* ]] && [ -d "ios" ]; then
        print_info "Updating iOS pods..."
        cd ios && pod install --repo-update && cd ..
    fi
    
    # Update macOS pods if on macOS
    if [[ "$OSTYPE" == "darwin"* ]] && [ -d "macos" ]; then
        print_info "Updating macOS pods..."
        cd macos && pod install --repo-update && cd ..
    fi
    
    print_success "Project setup completed"
}

# Run tests
run_tests() {
    print_info "Running all tests..."
    
    flutter test
    
    print_success "All tests completed"
}

# Run analysis
run_analysis() {
    print_info "Running code analysis..."
    
    flutter analyze
    
    print_success "Code analysis completed"
}

# Format code
format_code() {
    print_info "Formatting Dart code..."
    
    dart format lib/
    dart format test/
    
    print_success "Code formatting completed"
}

# Update dependencies
update_dependencies() {
    print_info "Updating dependencies..."
    
    flutter pub upgrade
    
    print_success "Dependencies updated"
}

# Generate icons and splash screens
generate_assets() {
    print_info "Generating app icons and splash screens..."
    
    # Check if flutter_launcher_icons is available
    flutter pub deps | grep flutter_launcher_icons > /dev/null && {
        flutter packages pub run flutter_launcher_icons:main
        print_success "App icons generated"
    } || print_warning "flutter_launcher_icons not found in pubspec.yaml"
    
    # Check if flutter_native_splash is available
    flutter pub deps | grep flutter_native_splash > /dev/null && {
        flutter packages pub run flutter_native_splash:create
        print_success "Splash screens generated"
    } || print_warning "flutter_native_splash not found in pubspec.yaml"
}

# Check project health
health_check() {
    print_info "Running project health check..."
    
    echo "Flutter Doctor:"
    flutter doctor
    
    echo ""
    print_info "Available devices:"
    flutter devices
    
    echo ""
    print_info "Dependency status:"
    flutter pub deps
    
    print_success "Health check completed"
}

# Build for all platforms
build_all() {
    local mode=${1:-release}
    print_info "Building for all supported platforms in $mode mode..."
    
    # Web
    print_info "Building web..."
    flutter build web --$mode
    print_success "Web build completed"
    
    # Android
    print_info "Building Android APK..."
    flutter build apk --$mode
    print_success "Android APK build completed"
    
    # macOS (if on macOS)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        print_info "Building macOS..."
        flutter build macos --$mode
        print_success "macOS build completed"
        
        print_info "Building iOS..."
        flutter build ios --$mode --no-codesign
        print_success "iOS build completed"
    fi
    
    # Windows (if on Windows)
    if [[ "$OSTYPE" == "msys" ]]; then
        print_info "Building Windows..."
        flutter build windows --$mode
        print_success "Windows build completed"
    fi
    
    # Linux (if on Linux)
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        print_info "Building Linux..."
        flutter build linux --$mode
        print_success "Linux build completed"
    fi
    
    print_success "All builds completed successfully!"
}

# Show help
show_help() {
    echo -e "${YELLOW}Usage: ./dev.sh [command]${NC}"
    echo ""
    echo -e "${YELLOW}Commands:${NC}"
    echo "  clean        - Clean project thoroughly"
    echo "  setup        - Setup project (get deps, enable platforms)"
    echo "  test         - Run all tests"
    echo "  analyze      - Run code analysis"
    echo "  format       - Format Dart code"
    echo "  update       - Update dependencies"
    echo "  assets       - Generate icons and splash screens"
    echo "  health       - Check project health"
    echo "  build        - Build for all platforms (release)"
    echo "  build-debug  - Build for all platforms (debug)"
    echo "  full         - Full setup (clean + setup + test + analyze)"
    echo ""
    echo -e "${YELLOW}Examples:${NC}"
    echo "  ./dev.sh clean"
    echo "  ./dev.sh setup"
    echo "  ./dev.sh full"
    echo "  ./dev.sh build"
}

# Full development setup
full_setup() {
    print_info "Running full development setup..."
    
    clean_project
    setup_project
    run_tests
    run_analysis
    
    print_success "Full setup completed successfully!"
}

# Main function
main() {
    print_header
    
    case $1 in
        "clean")
            clean_project
            ;;
        "setup")
            setup_project
            ;;
        "test")
            run_tests
            ;;
        "analyze")
            run_analysis
            ;;
        "format")
            format_code
            ;;
        "update")
            update_dependencies
            ;;
        "assets")
            generate_assets
            ;;
        "health")
            health_check
            ;;
        "build")
            build_all release
            ;;
        "build-debug")
            build_all debug
            ;;
        "full")
            full_setup
            ;;
        "help"|"--help"|"-h"|"")
            show_help
            ;;
        *)
            print_error "Unknown command: $1"
            show_help
            exit 1
            ;;
    esac
}

main "$@"