#!/bin/bash

# FoodEx - Build All Platforms Script
# Builds production-ready apps for all supported platforms

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🍕 FoodEx - Multi-Platform Build Script${NC}"
echo -e "${BLUE}======================================${NC}"
echo ""

# Function to print status
print_status() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed or not in PATH"
    echo "Please install Flutter from: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Clean project
clean_project() {
    print_info "Cleaning project..."
    flutter clean
    flutter pub get
    print_status "Project cleaned and dependencies updated"
}

# Build for Web
build_web() {
    print_info "Building Web (Release)..."
    flutter build web --release
    if [ $? -eq 0 ]; then
        print_status "Web app built successfully"
        echo "   📦 Location: build/web"
        echo "   🌐 You can serve it with: python -m http.server 8000 -d build/web"
    else
        print_error "Web build failed"
        return 1
    fi
}

# Main build logic
main() {
    local platform=${1:-all}
    
    case $platform in
        "web"|"all")
            clean_project
            echo ""
            build_web
            ;;
        *)
            echo -e "${YELLOW}Usage: $0 [platform]${NC}"
            echo ""
            echo "Platforms:"
            echo "  web      - Build web app"
            echo "  all      - Build for all available platforms (default)"
            echo ""
            echo "Note: This script currently supports web builds."
            echo "For other platforms, use the run.sh script or flutter build commands directly."
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
