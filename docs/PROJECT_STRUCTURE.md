# FoodEx Project Structure

## 📁 Directory Structure

```
food_delivery_meal-main/
├── 📁 lib/                          # Main Flutter application code
│   ├── 📁 core/                     # Core functionality and utilities
│   │   ├── 📁 constants/            # App constants and configuration
│   │   ├── 📁 network/              # Network layer and API configuration
│   │   ├── 📁 themes/               # App themes and styling
│   │   └── 📁 utils/                # Utility functions and extensions
│   │       ├── color_extension.dart # Color utilities and extensions
│   │       ├── extension.dart       # General Dart extensions
│   │       ├── globs.dart          # Global variables and constants
│   │       ├── locator.dart        # Service locator setup
│   │       ├── logger.dart         # Logging utilities
│   │       ├── my_http_overrides.dart # HTTP overrides for development
│   │       └── service_call.dart   # API service call utilities
│   │
│   ├── 📁 data/                     # Data layer
│   │   ├── 📁 datasources/          # Local and remote data sources
│   │   ├── 📁 repositories/         # Repository implementations
│   │   │   └── wallet_service.dart  # Wallet service repository
│   │   ├── dish_models.dart         # Dish data models
│   │   ├── order_models.dart        # Order data models
│   │   └── user_models.dart         # User data models
│   │
│   ├── 📁 business_logic/           # Business logic layer
│   │   └── 📁 providers/            # State management providers
│   │
│   ├── 📁 presentation/             # Presentation layer
│   │   ├── 📁 pages/                # Application pages/screens
│   │   │   ├── 📁 chef/             # Chef interface pages
│   │   │   │   ├── chef_earnings_view.dart
│   │   │   │   ├── chef_home_view.dart
│   │   │   │   ├── chef_main_tabview.dart
│   │   │   │   ├── chef_menu_view.dart
│   │   │   │   ├── chef_orders_view.dart
│   │   │   │   └── chef_profile_view.dart
│   │   │   ├── 📁 driver/           # Driver interface pages
│   │   │   │   ├── driver_earnings_view.dart
│   │   │   │   ├── driver_home_view.dart
│   │   │   │   ├── driver_main_tabview.dart
│   │   │   │   ├── driver_orders_view.dart
│   │   │   │   └── driver_profile_view.dart
│   │   │   ├── 📁 home/             # Home and main pages
│   │   │   │   └── home_view.dart
│   │   │   ├── 📁 login/            # Authentication pages
│   │   │   │   ├── login_view.dart
│   │   │   │   ├── new_password_view.dart
│   │   │   │   ├── otp_view.dart
│   │   │   │   ├── rest_password_view.dart
│   │   │   │   ├── sing_up_view.dart
│   │   │   │   └── welcome_view.dart
│   │   │   ├── 📁 main_tabview/     # Main tab navigation
│   │   │   │   └── main_tabview.dart
│   │   │   ├── 📁 menu/             # Menu and food item pages
│   │   │   │   ├── item_details_view.dart
│   │   │   │   ├── menu_items_view.dart
│   │   │   │   └── menu_view.dart
│   │   │   ├── 📁 more/             # Additional features pages
│   │   │   │   ├── about_us_view.dart
│   │   │   │   ├── add_card_view.dart
│   │   │   │   ├── change_address_view.dart
│   │   │   │   ├── checkout_message_view.dart
│   │   │   │   ├── checkout_view.dart
│   │   │   │   ├── inbox_view.dart
│   │   │   │   ├── more_view.dart
│   │   │   │   ├── my_order_view.dart
│   │   │   │   ├── notification_view.dart
│   │   │   │   └── payment_details_view.dart
│   │   │   ├── 📁 offer/            # Offers and promotions
│   │   │   │   └── offer_view.dart
│   │   │   ├── 📁 on_boarding/      # Onboarding screens
│   │   │   │   ├── on_boarding_view.dart
│   │   │   │   └── startup_view.dart
│   │   │   ├── 📁 profile/          # User profile pages
│   │   │   │   └── profile_view.dart
│   │   │   ├── 📁 wallet/           # Wallet and payment pages
│   │   │   │   └── wallet_view.dart
│   │   │   └── user_type_selector_view.dart # User type selection
│   │   │
│   │   └── 📁 widgets/              # Reusable UI components
│   │       ├── category_cell.dart   # Category display widget
│   │       ├── menu_item_row.dart   # Menu item list widget
│   │       ├── most_popular_cell.dart # Popular items widget
│   │       ├── popular_resutaurant_row.dart # Restaurant list widget
│   │       ├── recent_item_row.dart # Recent items widget
│   │       ├── round_button.dart    # Custom rounded button
│   │       ├── round_icon_button.dart # Rounded icon button
│   │       ├── round_textfield.dart # Custom text field
│   │       ├── tab_button.dart      # Custom tab button
│   │       └── view_all_title_row.dart # Section title widget
│   │
│   └── main.dart                    # Application entry point
│
├── 📁 assets/                       # Static assets
│   ├── 📁 fonts/                    # Font files
│   │   ├── Metropolis-Bold.otf
│   │   ├── Metropolis-ExtraBold.otf
│   │   ├── Metropolis-Medium.otf
│   │   ├── Metropolis-Regular.otf
│   │   └── Metropolis-SemiBold.otf
│   ├── 📁 icons/                    # Icon assets
│   └── 📁 images/                   # Image assets
│       ├── app_logo.png
│       ├── splash_bg.png
│       └── ... (other images)
│
├── 📁 docs/                         # Project documentation
│   ├── DEPLOYMENT.md                # Deployment instructions
│   ├── FEATURES_DOCUMENTATION.md   # Feature documentation
│   ├── FINAL_DOCUMENTATION.md      # Project completion docs
│   └── PROJECT_STRUCTURE.md        # This file
│
├── 📁 android/                      # Android platform code
├── 📁 ios/                          # iOS platform code
├── 📁 web/                          # Web platform code
├── 📁 linux/                        # Linux platform code
├── 📁 macos/                        # macOS platform code
├── 📁 windows/                      # Windows platform code
├── 📁 test/                         # Test files
│
├── pubspec.yaml                     # Project dependencies
├── analysis_options.yaml           # Dart analysis options
├── README.md                        # Project overview
└── .gitignore                       # Git ignore rules
```

## 🏗️ Architecture Pattern

This project follows a **Clean Architecture** pattern with clear separation of concerns:

### 1. **Core Layer** (`lib/core/`)
- Contains utilities, constants, and shared functionality
- No dependencies on other layers
- Reusable across the entire application

### 2. **Data Layer** (`lib/data/`)
- Handles data management and external data sources
- Contains models, repositories, and data sources
- Implements interfaces defined in the business logic layer

### 3. **Business Logic Layer** (`lib/business_logic/`)
- Contains providers and state management
- Handles application business rules
- Independent of UI and data implementation details

### 4. **Presentation Layer** (`lib/presentation/`)
- Contains UI components and pages
- Depends on business logic layer for state management
- Organized by feature areas (chef, driver, customer)

## 📱 Feature Organization

The app is organized by user roles and features:

- **👨‍🍳 Chef Interface**: Order management, menu creation, earnings tracking
- **🚗 Driver Interface**: Delivery management, earnings, order tracking
- **👤 Customer Interface**: Food ordering, payment, profile management
- **🔐 Authentication**: Login, signup, password management
- **💳 Payment**: Wallet, card management, checkout
- **📱 Core Features**: Navigation, onboarding, notifications

## 🎨 UI Components

Reusable widgets are centralized in `presentation/widgets/`:
- Form components (buttons, text fields)
- Display components (cards, lists, rows)
- Navigation components (tabs, buttons)

## 📝 Best Practices

1. **Naming Conventions**: Clear, descriptive file and class names
2. **Separation of Concerns**: Each layer has a specific responsibility
3. **Reusability**: Common widgets and utilities are shared
4. **Scalability**: Easy to add new features and maintain existing ones
5. **Testing**: Organized structure supports unit and integration testing

## 🚀 Getting Started

1. Clone the repository
2. Run `flutter pub get` to install dependencies
3. Check platform-specific setup in respective folders
4. Run `flutter run` to start the application

For detailed setup instructions, see the main README.md file.
