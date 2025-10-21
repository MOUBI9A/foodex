# 🍽️ FoodEx - Community Food Marketplace

[![Flutter](https://img.shields.io/badge/Flutter-3.32.5+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.8.1+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Status](https://img.shields.io/badge/Status-Frontend%20Complete-brightgreen?style=for-the-badge)](https://github.com/MOUBI9A/foodex)
[![Android](https://img.shields.io/badge/Android-Ready-3DDC84?style=for-the-badge&logo=android&logoColor=white)](https://developer.android.com)
[![iOS](https://img.shields.io/badge/iOS-Tested-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/ios/)
[![Web](https://img.shields.io/badge/Web-Live%20Demo-4285F4?style=for-the-badge&logo=googlechrome&logoColor=white)](https://web.dev/progressive-web-apps/)
[![macOS](https://img.shields.io/badge/macOS-Native-000000?style=for-the-badge&logo=apple&logoColor=white)](https://developer.apple.com/macos/)
[![Windows](https://img.shields.io/badge/Windows-Native-0078D4?style=for-the-badge&logo=windows&logoColor=white)](https://docs.microsoft.com/en-us/windows/apps/)
[![Linux](https://img.shields.io/badge/Linux-Native-FCC624?style=for-the-badge&logo=linux&logoColor=black)](https://docs.flutter.dev/development/platform-integration/linux)

> **✅ FRONTEND DEVELOPMENT COMPLETE - A beautiful, multi-platform food delivery app connecting customers with local home chefs**  
> *Designed with Moroccan-inspired aesthetics and modern Flutter Clean Architecture*

## 🎉 Project Status: COMPLETE

The Flutter front-end development is **100% complete** with 37+ screens, comprehensive wallet system, and full multi-platform support. The app is **ready for backend API integration**.

## 📋 Documentation

### 🎯 Quick Start Guides
- 🎉 [**Visual Feature Guide**](VISUAL_FEATURE_GUIDE.md) - **Complete visual tour of all 38 screens**
- ✅ [**Flutter Frontend Completion**](FLUTTER_FRONTEND_COMPLETION.md) - **Complete task list with all implemented features**
- 📦 [**Project Handoff Guide**](PROJECT_HANDOFF.md) - **Complete handoff documentation for all stakeholders**

### 🔗 For Backend Developers
- 🔗 [**Backend Integration Checklist**](BACKEND_INTEGRATION_CHECKLIST.md) - **Step-by-step guide for backend developers**
- 🔧 [Backend Integration Guide](docs/BACKEND_INTEGRATION_GUIDE.md) - API integration instructions
- 📡 [API Technical Specifications](docs/API_TECHNICAL_SPECIFICATIONS.md) - Complete API documentation
- 📮 [Postman Collection](docs/FoodEx_API_Postman_Collection.json) - Ready-to-use API testing collection

### 📊 Project Documentation
- 📖 [Project Structure](docs/PROJECT_STRUCTURE.md) - Detailed architecture overview
- 🚀 [Features Documentation](docs/FEATURES_DOCUMENTATION.md) - Complete feature list
- 📊 [Final Documentation](docs/FINAL_DOCUMENTATION.md) - Project completion summary
- 🧪 [Testing Report](docs/COMPREHENSIVE_TESTING_REPORT.md) - Testing results and validation
- 🚀 [Deployment Guide](docs/DEPLOYMENT.md) - Platform deployment instructions

## ✨ Features

### 🏠 **Home Chefs**
- Create and manage delicious meal offerings
- Real-time order management system
- Earnings tracking with detailed analytics
- Professional chef profiles with ratings

### 👥 **Customers**
- Browse local home chef offerings
- Secure wallet system with MAD currency
- Order tracking and delivery updates
- Rating and review system

### 🚚 **Delivery Drivers**
- Optimized delivery route management
- Real-time earnings dashboard
- Order assignment system
- Performance tracking

## 🚀 Quick Start

### Prerequisites
- Flutter 3.32.5+ 
- Dart 3.8.1+
- Your favorite IDE (VS Code, Android Studio, etc.)

### Installation

```bash
# Clone the repository
git clone https://github.com/MOUBI9A/foodex.git
cd foodex

# Install dependencies
flutter pub get

# Run the app
flutter run
```

### Platform-Specific Setup

<details>
<summary>📱 <strong>Mobile Development</strong></summary>

**Android:**
```bash
flutter run -d android
```

**iOS:** (Tested ✅)
```bash
flutter run -d ios
```
</details>

<details>
<summary>🌐 <strong>Web Development</strong></summary>

**Web:** (Live Demo Available ✅)
```bash
flutter run -d chrome
```
</details>

```bash
# Development
flutter run -d chrome

# Production build
flutter build web --release
```
</details>

<details>
<summary>💻 <strong>Desktop Development</strong></summary>

**macOS:**
```bash
flutter run -d macos
```

**Windows:**
```bash
flutter run -d windows
```

**Linux:**
```bash
flutter run -d linux
```
</details>

## 🏗️ Multi-Platform Build

### Quick Build
Use our automated build script:

```bash
# Build web version (fastest for demo)
./build_all_platforms.sh web

# Build all available platforms
./build_all_platforms.sh all
```

### Platform-Specific Builds
For detailed platform builds, use the comprehensive runner:

```bash
# Interactive launcher
./launcher.sh

# Or use run.sh for specific platforms
./run.sh web release    # Build web
./run.sh android debug  # Run on Android
./run.sh ios debug      # Run on iOS (macOS only)
```

## 🛠️ Architecture

### **Project Structure**
```
lib/
├── common/           # Shared utilities and extensions
├── common_widget/    # Reusable UI components
├── models/          # Data models
├── services/        # Business logic and APIs
└── view/           # UI screens and widgets
    ├── chef/       # Chef-specific screens
    ├── driver/     # Driver-specific screens
    ├── login/      # Authentication screens
    ├── more/       # Settings and additional features
    └── wallet/     # Wallet and payment features
```

### **Key Technologies**
- **State Management:** Provider/SetState
- **Navigation:** Flutter Navigator 2.0
- **Networking:** HTTP with custom service layer
- **Storage:** SharedPreferences
- **Maps:** Google Maps integration
- **Payments:** Multi-provider wallet system

## 💳 Wallet System

FoodEx features a comprehensive wallet system with:
- **MAD Currency Support** (Moroccan Dirham)
- **Multiple Payment Methods** (Credit Card, PayPal, Cash)
- **Transaction History** with detailed analytics
- **Secure Payment Processing**
- **Real-time Balance Updates**

## 🎨 Design System

### **Color Palette**
- **Primary:** Modern orange tones inspired by Moroccan sunsets
- **Secondary:** Warm earth tones and accent colors
- **Typography:** Metropolis font family for modern readability

### **UI Components**
- Beautiful gradient backgrounds
- Moroccan-inspired card designs
- Smooth animations and transitions
- Responsive layouts for all screen sizes

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Integration tests
flutter drive --target=test_driver/app.dart
```

## 📱 Platform Support

| Platform | Status | Build Size | Notes |
|----------|--------|------------|-------|
| **Android** | ✅ Ready | ~25MB | Material Design |
| **iOS** | ✅ Ready | ~30MB | Cupertino Design |
| **Web** | ✅ PWA Ready | ~2MB | Progressive Web App |
| **macOS** | ✅ Native | ~65MB | Desktop optimized |
| **Windows** | ✅ Native | ~45MB | Windows 10+ |
| **Linux** | ✅ Native | ~35MB | Ubuntu/Debian tested |

## 🚀 Deployment

### **Web Deployment**
```bash
flutter build web --release
# Deploy to your hosting provider
```

### **Mobile App Stores**
```bash
# Android Play Store
flutter build appbundle --release

# iOS App Store  
flutter build ios --release
```

### **Desktop Distribution**
```bash
# macOS App Store
flutter build macos --release

# Windows Microsoft Store
flutter build windows --release

# Linux Snap Store
flutter build linux --release
```

## 🤝 Contributing

We welcome contributions! Please see our [Contributing Guidelines](CONTRIBUTING.md) for details.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Author

**MOUBI9A**
- GitHub: [@MOUBI9A](https://github.com/MOUBI9A)
- Email: moubi9a@foodex.ma

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for design inspiration
- Moroccan culinary culture for app concept
- Open source community for contributions

---

<div align="center">

**🍽️ Built with ❤️ for the food community**

[⭐ Star this repo](https://github.com/MOUBI9A/foodex) • [🐛 Report Bug](https://github.com/MOUBI9A/foodex/issues) • [✨ Request Feature](https://github.com/MOUBI9A/foodex/issues)

</div>
