# 🚀 FoodEx Project Runner Scripts

This directory contains comprehensive scripts to run the FoodEx Flutter application on all supported platforms with ease.

## 📋 Available Scripts

### 🎯 **Master Runner**: `./run.sh`
The main script that handles all platforms and modes.

```bash
# Usage
./run.sh [platform] [mode]

# Examples
./run.sh android debug      # Run on Android in debug mode
./run.sh ios release        # Build iOS release
./run.sh web                # Run web app (default: debug)
./run.sh macos profile      # Run macOS in profile mode

# Special commands
./run.sh doctor            # Run Flutter doctor
./run.sh devices           # Show available devices
./run.sh clean             # Clean and prepare project
```

### 📱 **Platform-Specific Scripts**

#### Android: `./run-android.sh`
```bash
./run-android.sh [debug|release|profile]

# Examples
./run-android.sh           # Debug mode (default)
./run-android.sh release   # Build and install APK
./run-android.sh profile   # Profile mode for performance testing
```

#### iOS: `./run-ios.sh` (macOS only)
```bash
./run-ios.sh [debug|release|profile]

# Examples
./run-ios.sh              # Debug mode (default)
./run-ios.sh release      # Build release IPA
./run-ios.sh profile      # Profile mode
```

#### Web: `./run-web.sh`
```bash
./run-web.sh [debug|release|profile] [port]

# Examples
./run-web.sh              # Debug mode on port 3000
./run-web.sh release      # Build and serve release
./run-web.sh debug 8080   # Debug mode on port 8080
```

#### macOS: `./run-macos.sh` (macOS only)
```bash
./run-macos.sh [debug|release|profile]

# Examples
./run-macos.sh            # Debug mode (default)
./run-macos.sh release    # Build and launch release app
```

#### Windows: `./run-windows.bat` (Windows only)
```batch
run-windows.bat [debug|release|profile]

REM Examples
run-windows.bat           & Debug mode (default)
run-windows.bat release   & Build and launch release app
```

#### Linux: `./run-linux.sh` (Linux only)
```bash
./run-linux.sh [debug|release|profile]

# Examples
./run-linux.sh            # Debug mode (default)
./run-linux.sh release    # Build and launch release app
```

### 🔧 **Development Helper**: `./dev.sh`
Comprehensive development utilities and project management.

```bash
# Common tasks
./dev.sh clean            # Thorough project cleanup
./dev.sh setup            # Full project setup
./dev.sh test             # Run all tests
./dev.sh analyze          # Code analysis
./dev.sh format           # Format code
./dev.sh update           # Update dependencies

# Advanced tasks
./dev.sh health           # Project health check
./dev.sh build            # Build for all platforms (release)
./dev.sh build-debug      # Build for all platforms (debug)
./dev.sh assets           # Generate icons/splash screens
./dev.sh full             # Full development setup
```

## 🛠️ Setup Instructions

### 1. **Make Scripts Executable** (Linux/macOS)
```bash
chmod +x *.sh
```

### 2. **Windows Setup**
- Scripts are ready to use with `.bat` extension
- Run from Command Prompt or PowerShell

### 3. **Prerequisites Check**
```bash
# Check Flutter installation
./run.sh doctor

# See available devices
./run.sh devices
```

## 📚 Detailed Usage Examples

### 🚀 **Quick Start**
```bash
# First time setup
./dev.sh full

# Run on your preferred platform
./run.sh android          # Android development
./run.sh web               # Web development  
./run.sh macos            # macOS development (macOS only)
```

### 🔄 **Development Workflow**
```bash
# Start development session
./dev.sh clean && ./dev.sh setup

# Make changes to code...

# Test your changes
./dev.sh test && ./dev.sh analyze

# Run on device
./run.sh android debug    # Hot reload enabled
```

### 🏗️ **Production Builds**
```bash
# Build for specific platform
./run-android.sh release     # Android APK
./run-ios.sh release         # iOS IPA (macOS only)
./run-web.sh release         # Web build

# Build for all platforms
./dev.sh build              # Release builds for all
```

### 🐛 **Debugging & Testing**
```bash
# Code analysis and formatting
./dev.sh analyze && ./dev.sh format

# Profile performance
./run.sh android profile    # Android profiling
./run.sh ios profile        # iOS profiling

# Health check
./dev.sh health             # Comprehensive project check
```

## 🎯 Platform-Specific Notes

### 📱 **Android**
- Automatically starts emulator if no device found
- Installs APK on connected device in release mode
- Supports hot reload in debug mode

### 🍎 **iOS** (macOS required)
- Opens iOS Simulator if no device connected
- Updates CocoaPods automatically
- No code signing in release builds (manual signing required)

### 🌐 **Web**
- Serves on customizable port (default: 3000)
- Uses CanvasKit renderer for better performance
- Automatic browser opening in debug mode

### 🖥️ **macOS** (macOS required)
- Updates CocoaPods automatically
- Launches built app automatically in release mode
- Full native macOS app support

### 🪟 **Windows**
- Enables Windows desktop support automatically
- Launches built executable in release mode
- Requires Windows development setup

### 🐧 **Linux**
- Installs required system dependencies
- Builds native Linux applications
- Requires GTK+ development libraries

## 🔧 Environment Variables

### **Web Development**
```bash
export WEB_PORT=8080        # Custom web server port
./run-web.sh debug         # Will use port 8080
```

### **Android Development**
```bash
export ANDROID_EMULATOR="Pixel_7_Pro_API_34"  # Default emulator
```

## 🚨 Troubleshooting

### **Common Issues**

#### Flutter Not Found
```bash
# Check Flutter installation
flutter --version

# Add to PATH if needed
export PATH="$PATH:/path/to/flutter/bin"
```

#### No Devices Available
```bash
# Check available devices
./run.sh devices

# Start Android emulator
flutter emulators --launch <emulator_name>

# Start iOS Simulator (macOS only)
open -a Simulator
```

#### Permission Denied (Linux/macOS)
```bash
# Make scripts executable
chmod +x *.sh
```

#### Build Failures
```bash
# Clean and retry
./dev.sh clean
./dev.sh setup
./run.sh [platform] [mode]
```

### **Platform-Specific Issues**

#### **Android SDK Issues**
- Ensure Android SDK is properly installed
- Check `flutter doctor` for missing components
- Update SDK to version 35+ for modern dependencies

#### **iOS Development Issues** 
- Requires macOS and Xcode
- Ensure iOS development tools are installed
- Run `xcode-select --install` if needed

#### **Web Development Issues**
- Enable web support: `flutter config --enable-web`
- Clear browser cache if issues persist
- Use incognito mode for testing

## 📈 Performance Tips

### **Development Mode**
- Use debug mode for active development (hot reload)
- Use profile mode for performance testing
- Use release mode for final testing/deployment

### **Build Optimization**
```bash
# Web performance
./run-web.sh release       # Optimized web build with tree shaking

# Mobile performance  
./run-android.sh profile   # Profile mode for performance analysis
./run-ios.sh profile       # iOS performance profiling
```

## 🎉 Happy Coding!

These scripts are designed to streamline your FoodEx development workflow. For issues or improvements, please check the project documentation or create an issue in the repository.

**Repository**: https://github.com/MOUBI9A/foodex.git