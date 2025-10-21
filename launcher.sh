#!/bin/bash

# FoodEx Quick Launcher
# Interactive menu for easy project running

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

print_header() {
    clear
    echo -e "${BLUE}"
    echo "🍕====================================🍕"
    echo "     FoodEx Quick Launcher"
    echo "🍕====================================🍕"
    echo -e "${NC}"
}

show_menu() {
    echo -e "${CYAN}Select a platform to run FoodEx:${NC}"
    echo ""
    echo "  1) 🤖 Android (Debug)"
    echo "  2) 🤖 Android (Release APK)" 
    echo "  3) 🍎 iOS (Debug)"
    echo "  4) 🍎 iOS (Release)"
    echo "  5) 🌐 Web (Debug)"
    echo "  6) 🌐 Web (Release)"
    echo "  7) 🖥️  macOS (Debug)"
    echo "  8) 🖥️  macOS (Release)"
    echo "  9) 🪟 Windows (Debug)"
    echo " 10) 🪟 Windows (Release)"
    echo " 11) 🐧 Linux (Debug)"
    echo " 12) 🐧 Linux (Release)"
    echo ""
    echo -e "${YELLOW}Development Tools:${NC}"
    echo " 13) 🔧 Clean Project"
    echo " 14) 🔧 Setup Project"
    echo " 15) 🧪 Run Tests"
    echo " 16) 🔍 Code Analysis"
    echo " 17) 💾 Full Dev Setup"
    echo " 18) 🏗️  Build All Platforms"
    echo " 19) 🏥 Health Check"
    echo ""
    echo " 20) 📱 Show Devices"
    echo " 21) 📋 Flutter Doctor"
    echo " 22) ❓ Help"
    echo ""
    echo "  0) 🚪 Exit"
    echo ""
    echo -e "${CYAN}Enter your choice [0-22]: ${NC}"
}

run_choice() {
    case $1 in
        1)
            echo -e "${GREEN}🤖 Running Android (Debug)...${NC}"
            ./run-android.sh debug
            ;;
        2)
            echo -e "${GREEN}🤖 Building Android APK (Release)...${NC}"
            ./run-android.sh release
            ;;
        3)
            echo -e "${GREEN}🍎 Running iOS (Debug)...${NC}"
            ./run-ios.sh debug
            ;;
        4)
            echo -e "${GREEN}🍎 Building iOS (Release)...${NC}"
            ./run-ios.sh release
            ;;
        5)
            echo -e "${GREEN}🌐 Running Web (Debug)...${NC}"
            ./run-web.sh debug
            ;;
        6)
            echo -e "${GREEN}🌐 Building Web (Release)...${NC}"
            ./run-web.sh release
            ;;
        7)
            echo -e "${GREEN}🖥️ Running macOS (Debug)...${NC}"
            ./run-macos.sh debug
            ;;
        8)
            echo -e "${GREEN}🖥️ Building macOS (Release)...${NC}"
            ./run-macos.sh release
            ;;
        9)
            echo -e "${GREEN}🪟 Running Windows (Debug)...${NC}"
            ./run-windows.bat debug
            ;;
        10)
            echo -e "${GREEN}🪟 Building Windows (Release)...${NC}"
            ./run-windows.bat release
            ;;
        11)
            echo -e "${GREEN}🐧 Running Linux (Debug)...${NC}"
            ./run-linux.sh debug
            ;;
        12)
            echo -e "${GREEN}🐧 Building Linux (Release)...${NC}"
            ./run-linux.sh release
            ;;
        13)
            echo -e "${GREEN}🔧 Cleaning project...${NC}"
            ./dev.sh clean
            ;;
        14)
            echo -e "${GREEN}🔧 Setting up project...${NC}"
            ./dev.sh setup
            ;;
        15)
            echo -e "${GREEN}🧪 Running tests...${NC}"
            ./dev.sh test
            ;;
        16)
            echo -e "${GREEN}🔍 Running code analysis...${NC}"
            ./dev.sh analyze
            ;;
        17)
            echo -e "${GREEN}💾 Full development setup...${NC}"
            ./dev.sh full
            ;;
        18)
            echo -e "${GREEN}🏗️ Building all platforms...${NC}"
            ./dev.sh build
            ;;
        19)
            echo -e "${GREEN}🏥 Project health check...${NC}"
            ./dev.sh health
            ;;
        20)
            echo -e "${GREEN}📱 Available devices:${NC}"
            ./run.sh devices
            ;;
        21)
            echo -e "${GREEN}📋 Flutter doctor:${NC}"
            ./run.sh doctor
            ;;
        22)
            echo -e "${GREEN}❓ Help and documentation:${NC}"
            echo ""
            echo "📖 For detailed usage, see RUNNER_README.md"
            echo ""
            ./run.sh help
            ;;
        0)
            echo -e "${GREEN}👋 Goodbye! Happy coding!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}❌ Invalid choice. Please try again.${NC}"
            sleep 2
            ;;
    esac
}

# Main loop
main() {
    while true; do
        print_header
        show_menu
        read -r choice
        echo ""
        
        if [[ "$choice" =~ ^[0-9]+$ ]] && [ "$choice" -ge 0 ] && [ "$choice" -le 22 ]; then
            run_choice "$choice"
        else
            echo -e "${RED}❌ Please enter a number between 0 and 22${NC}"
            sleep 2
            continue
        fi
        
        if [ "$choice" != "0" ]; then
            echo ""
            echo -e "${YELLOW}Press Enter to continue...${NC}"
            read -r
        fi
    done
}

# Check if Flutter is available
if ! command -v flutter &> /dev/null; then
    echo -e "${RED}❌ Flutter not found. Please install Flutter first.${NC}"
    exit 1
fi

# Start the launcher
main