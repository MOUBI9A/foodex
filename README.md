# 🍽️ FoodEx - Community-Driven Food Marketplace

**Developed by MOUBI9A** | **Multi-Platform Support**

![FoodEx Logo](https://img.shields.io/badge/FoodEx-Community%20Food%20Marketplace-orange?style=for-the-badge&logo=restaurant)
![Platform Support](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20Windows%20%7C%20macOS%20%7C%20Linux-blue?style=for-the-badge)
![Flutter](https://img.shields.io/badge/Flutter-3.24+-blue?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.4+-blue?style=for-the-badge&logo=dart)

A revolutionary cross-platform food delivery application that connects food lovers with passionate home chefs in their local community. FoodEx features a beautiful Moroccan-inspired design, comprehensive wallet-based payment system, and supports **all major platforms**.

## 🚀 **Platform Support**

FoodEx runs everywhere your users are:

### 📱 **Mobile Platforms**
- **Android** (API 21+) - Phones, Tablets, Android TV
- **iOS** (12.0+) - iPhone, iPad, Apple TV

### 🌐 **Web Platforms**
- **Progressive Web App** - Works offline, installable
- **All Modern Browsers** - Chrome, Firefox, Safari, Edge
- **Mobile Web** - Responsive design for mobile browsers

### 💻 **Desktop Platforms**
- **macOS** (10.14+) - Intel & Apple Silicon support
- **Windows** (Windows 10+) - Native Windows app
- **Linux** - Ubuntu, Fedora, Arch, and derivatives

### ⚡ **Quick Platform Commands**
```bash
# Mobile
flutter run -d android          # Android device/emulator
flutter run -d ios             # iOS device/simulator

# Web
flutter run -d chrome          # Web browser
flutter run -d web-server      # Local web server

# Desktop  
flutter run -d macos           # macOS app
flutter run -d windows         # Windows app
flutter run -d linux           # Linux app

# Build all platforms
./build_all_platforms.sh all   # Automated multi-platform build
```

## 🌟 Features

### 🎯 **Multi-User Experience**
- **Customer Interface**: Browse and order delicious meals from local home chefs
- **Home Chef Interface**: Share your culinary passion and earn money
- **Courier Interface**: Deliver meals and build your earnings

### 💰 **Integrated Wallet System**
- **Secure Digital Wallet** with MAD (Moroccan Dirham) support
- **Multiple Top-up Methods**: Credit Card, Debit Card, Bank Transfer, Cash
- **Real-time Transaction History** with detailed tracking
- **Balance Management** with instant updates
- **Payment Processing** for seamless order transactions

### 🎨 **Moroccan-Inspired Design**
- **Warm Color Palette**: Rich oranges, greens, and beige tones
- **Beautiful Gradients** and card-based UI
- **Cultural Elements** reflecting Moroccan design aesthetics
- **Responsive Layout** optimized for mobile devices

### 🍛 **Food Categories**
- Traditional Moroccan dishes (Tagine, Couscous, Pastilla)
- International cuisine options
- Desserts and beverages
- Special dietary accommodations

## 📱 Screenshots

The app features a stunning user interface with:
- **User Type Selector**: Choose between Customer, Home Chef, or Courier
- **Wallet Management**: Top-up, view balance, and transaction history
- **Order Tracking**: Real-time status updates from preparation to delivery
- **Beautiful Cards**: Moroccan-inspired design elements throughout

## 🚀 Getting Started

### Prerequisites

Before running FoodEx, ensure you have the following installed:

- **Flutter SDK** (3.0 or higher)
- **Dart SDK** (3.0 or higher)
- **Xcode** (for iOS development)
- **Android Studio** (for Android development)
- **VS Code** or **Android Studio** with Flutter plugins

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MOUBI9A/foodex-app.git
   cd foodex-app
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### iOS Setup
```bash
cd ios
pod install
cd ..
flutter run
```

#### Android Setup
```bash
flutter run
```

## 🏗️ Project Structure

```
lib/
├── common/
│   ├── color_extension.dart      # Moroccan-inspired color palette
│   ├── extension.dart            # Utility extensions
│   ├── globs.dart               # Global constants
│   └── service_call.dart        # API service layer
├── common_widget/
│   ├── round_button.dart        # Reusable button components
│   ├── round_textfield.dart     # Input field components
│   └── tab_button.dart          # Navigation components
├── models/
│   ├── user_models.dart         # User, Wallet, Transaction models
│   ├── dish_models.dart         # Dish, Chef models
│   └── order_models.dart        # Order, Courier models
├── services/
│   └── wallet_service.dart      # Wallet management service
├── view/
│   ├── wallet/
│   │   └── wallet_view.dart     # Wallet interface
│   ├── main_tabview/
│   │   └── main_tabview.dart    # Customer main interface
│   ├── chef/
│   │   └── chef_main_tabview.dart # Chef interface
│   ├── driver/
│   │   └── driver_main_tabview.dart # Courier interface
│   └── user_type_selector_view.dart # User type selection
└── main.dart                    # Application entry point
```

## 🔧 Key Components

### Wallet System
- **WalletService**: Manages all wallet operations
- **Transaction Tracking**: Complete history with color-coded types
- **Payment Methods**: Multiple options for flexibility
- **Real-time Updates**: Instant balance and transaction updates

### User Management
- **Multi-role Support**: Customer, Chef, Courier
- **Profile Management**: User information and preferences
- **Authentication**: Secure user authentication system

### Order Management
- **Order Lifecycle**: From placement to delivery
- **Real-time Tracking**: Live status updates
- **Payment Integration**: Seamless wallet-based payments

## 🎨 Design System

### Color Palette
```dart
Primary: #E67E22 (Warm Moroccan Orange)
Secondary: #27AE60 (Moroccan Green)
Accent: #F5E6B8 (Warm Beige)
Text: #2C3E50 (Deep Blue-Grey)
Background: #FAF8F6 (Warm White)
```

### Typography
- **Metropolis Font Family**: Modern and clean
- **Multiple Weights**: Regular, Medium, SemiBold, Bold, ExtraBold
- **Responsive Sizing**: Optimized for mobile screens

## 📱 How to Use the App

### For Customers:
1. **Select "Customer"** on the welcome screen
2. **Browse home chefs** in your area
3. **Add funds** to your wallet via the "More" tab
4. **Place orders** and track delivery in real-time
5. **Rate and review** your experience

### For Home Chefs:
1. **Select "Home Chef"** on the welcome screen
2. **Set up your kitchen profile** and specialties
3. **Add your dishes** with photos and descriptions
4. **Manage orders** and update preparation status
5. **Earn money** directly to your wallet

### For Couriers:
1. **Select "Courier"** on the welcome screen
2. **Set your availability** and vehicle information
3. **Accept delivery requests** in your area
4. **Navigate to pickup and delivery locations**
5. **Earn delivery fees** in your wallet

## 🛠️ Technologies Used

- **Flutter**: Cross-platform mobile development
- **Dart**: Programming language
- **Material Design**: UI components
- **Shared Preferences**: Local data storage
- **HTTP**: API communication
- **Google Maps**: Location services
- **Image Picker**: Photo management

## 🔮 Future Enhancements

- **Real-time Chat**: Communication between users
- **Push Notifications**: Order updates and promotions
- **Advanced Analytics**: Insights for chefs and customers
- **Social Features**: Community reviews and recommendations
- **AI Integration**: Personalized food recommendations
- **Multi-language Support**: Arabic and French localization

## 🤝 Contributing

We welcome contributions to FoodEx! Please follow these steps:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👨‍💻 Developer

**MOUBI9A**
- GitHub: [@MOUBI9A](https://github.com/MOUBI9A)
- Project: FoodEx - Community-Driven Food Marketplace

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Moroccan culture for design inspiration
- Community of home chefs for the concept validation
- Open source contributors who make projects like this possible

---

**⭐ If you found this project helpful, please give it a star on GitHub!**

Made with ❤️ by **MOUBI9A** in Morocco 🇲🇦
