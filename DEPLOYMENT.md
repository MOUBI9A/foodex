# FoodEx - Multi-Platform Deployment Guide

## 🚀 Platform Support

FoodEx supports all major platforms with optimized builds for each:

### 📱 Mobile Platforms
- **Android** (API 21+) - Phone, Tablet, Android TV
- **iOS** (iOS 12.0+) - iPhone, iPad, Apple TV

### 🌐 Web Platforms  
- **Progressive Web App** - All modern browsers
- **Chrome, Firefox, Safari, Edge** - Full feature support
- **Mobile browsers** - Responsive design

### 💻 Desktop Platforms
- **macOS** (10.14+) - Intel & Apple Silicon
- **Windows** (Windows 10+) - x64 architecture  
- **Linux** - Ubuntu, Fedora, Arch, and derivatives

## 🛠️ Build Instructions

### Prerequisites
```bash
# Install Flutter SDK (latest stable)
flutter doctor -v

# Verify all platforms are enabled
flutter config --list
```

### Quick Build Commands

#### Android
```bash
# Development APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Play Store Bundle
flutter build appbundle --release
```

#### iOS (macOS only)
```bash
# Development build
flutter build ios --debug --no-codesign

# Release build  
flutter build ios --release --no-codesign

# For App Store (requires Xcode)
open ios/Runner.xcworkspace
```

#### Web
```bash
# Development
flutter run -d chrome

# Release build
flutter build web --release --web-renderer html

# Optimized for PWA
flutter build web --pwa-strategy offline-first
```

#### macOS (macOS only)
```bash
# Development
flutter run -d macos

# Release build
flutter build macos --release

# Create DMG (requires additional tools)
# Follow: https://docs.flutter.dev/deployment/macos
```

#### Windows (Windows only)
```bash
# Development
flutter run -d windows

# Release build
flutter build windows --release

# Create installer (requires Inno Setup or similar)
```

#### Linux (Linux only)
```bash
# Development
flutter run -d linux

# Release build
flutter build linux --release

# Create AppImage/Snap/Flatpak (requires additional tools)
```

### Automated Multi-Platform Build
```bash
# Use our custom build script
./build_all_platforms.sh all

# Or specific platform
./build_all_platforms.sh android
./build_all_platforms.sh web
```

## 📦 Distribution

### App Stores

#### Google Play Store (Android)
1. Build App Bundle: `flutter build appbundle --release`
2. Upload `build/app/outputs/bundle/release/app-release.aab`
3. Follow Google Play Console guidelines

#### Apple App Store (iOS)
1. Open `ios/Runner.xcworkspace` in Xcode
2. Archive and upload through Xcode
3. Follow App Store Connect guidelines

#### Microsoft Store (Windows)
1. Build MSIX: `flutter build windows --release`
2. Create MSIX package using Visual Studio
3. Upload through Partner Center

#### Mac App Store (macOS) 
1. Build and sign in Xcode
2. Upload through App Store Connect
3. Follow macOS app guidelines

#### Chrome Web Store (PWA)
1. Build web: `flutter build web --release`
2. Package as Chrome extension
3. Upload to Chrome Web Store

### Direct Distribution

#### Web Hosting
```bash
# Build for web
flutter build web --release

# Deploy to any web server
# Files are in: build/web/

# Popular hosting options:
# - Firebase Hosting
# - Netlify
# - Vercel
# - GitHub Pages
# - AWS S3 + CloudFront
```

#### Desktop Distribution
```bash
# macOS - Create DMG
# Windows - Create installer with Inno Setup
# Linux - Create AppImage, Snap, or Flatpak

# See platform-specific guides in docs/deployment/
```

## 🎯 Platform-Specific Features

### Android
- ✅ Google Maps integration
- ✅ Push notifications (FCM)
- ✅ Camera access for food photos
- ✅ Location services
- ✅ Payment integrations
- ✅ Background processing

### iOS
- ✅ Apple Maps integration
- ✅ Apple Push Notifications
- ✅ Camera and photo library
- ✅ Core Location services
- ✅ Apple Pay integration
- ✅ Background app refresh

### Web (PWA)
- ✅ Responsive design
- ✅ Offline functionality
- ✅ Web push notifications
- ✅ Web Share API
- ✅ Progressive enhancement
- ⚠️ Limited camera access

### macOS
- ✅ Native window management
- ✅ Menu bar integration
- ✅ Dock support
- ✅ macOS notifications
- ✅ Keychain integration
- ✅ Full filesystem access

### Windows
- ✅ Windows-native UI
- ✅ System tray integration
- ✅ Windows notifications
- ✅ File associations
- ✅ Windows Hello integration
- ✅ Desktop shortcuts

### Linux
- ✅ GTK integration
- ✅ System notifications
- ✅ Desktop file associations
- ✅ Themed UI (follows system)
- ✅ Package manager support
- ✅ Wayland + X11 support

## 🔧 Configuration Files

### Platform Configurations
- `android/app/build.gradle` - Android build settings
- `ios/Runner/Info.plist` - iOS app configuration
- `web/manifest.json` - PWA configuration
- `macos/Runner/Info.plist` - macOS app settings
- `windows/CMakeLists.txt` - Windows build config
- `linux/CMakeLists.txt` - Linux build config

### Custom Configurations
- `windows/foodex_config.cmake` - Windows-specific settings
- `macos/foodex_config.xcconfig` - macOS-specific settings  
- `linux/foodex.desktop` - Linux desktop integration

## 📋 Release Checklist

### Pre-Release
- [ ] Update version in `pubspec.yaml`
- [ ] Run `flutter analyze` (no errors)
- [ ] Run `flutter test` (all tests pass)
- [ ] Test on physical devices
- [ ] Update CHANGELOG.md
- [ ] Update screenshots

### Build & Test
- [ ] Build for all target platforms
- [ ] Test installation packages
- [ ] Verify app functionality
- [ ] Check performance metrics
- [ ] Validate platform guidelines

### Deployment
- [ ] Upload to app stores
- [ ] Deploy web version
- [ ] Update documentation
- [ ] Create release notes
- [ ] Tag release in git

## 🎨 Brand Assets

### App Icons
- Android: `android/app/src/main/res/mipmap-*/ic_launcher.png`
- iOS: `ios/Runner/Assets.xcassets/AppIcon.appiconset/`
- Web: `web/icons/Icon-*.png`
- macOS: `macos/Runner/Assets.xcassets/AppIcon.appiconset/`
- Windows: `windows/runner/resources/app_icon.ico`

### Splash Screens
- Android: Configured in `android/app/src/main/res/drawable/`
- iOS: `ios/Runner/Assets.xcassets/LaunchImage.imageset/`
- Web: Custom loading screen in `web/index.html`

## 🌍 Localization

Current languages:
- English (en_US) - Primary
- French (fr_FR) - Secondary  
- Arabic (ar_MA) - Moroccan market

To add new languages:
1. Add to `lib/l10n/` directory
2. Update `pubspec.yaml` with new locale
3. Rebuild platform-specific assets

## 📞 Support

### Development
- **Platform**: Flutter 3.24+
- **Languages**: Dart, Native platform code
- **Architecture**: Clean Architecture + BLoC
- **State Management**: Provider + Riverpod

### Contact
- **Developer**: MOUBI9A
- **Repository**: https://github.com/MOUBI9A/FoodEx
- **Documentation**: README.md
- **Issues**: GitHub Issues tracker

---

**Created by MOUBI9A** | **September 2025** | **FoodEx v1.0.0**
