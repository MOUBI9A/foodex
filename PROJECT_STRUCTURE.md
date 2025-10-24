# Food Delivery App - Project Structure

## 📁 Architecture Overview

This project follows **Clean Architecture** principles with a clear separation of concerns across three main layers:

```
lib/
├── core/                  # Core utilities, config, and shared code
├── domain/                # Business logic and entities (framework-independent)
├── data/                  # Data sources and repository implementations
├── presentation/          # UI, widgets, and state management
└── main.dart             # App entry point
```

## 🏗️ Layer Breakdown

### 1. **Core Layer** (`lib/core/`)

Shared code, utilities, configuration, and infrastructure that all other layers can depend on.

```
core/
├── config/
│   ├── app_config.dart           # Environment configuration (dev, staging, prod)
│   └── constants.dart             # App-wide constants
├── di/
│   └── service_locator.dart      # Dependency Injection (GetIt)
├── errors/
│   └── failures.dart             # Error handling (Failure hierarchy)
├── network/
│   ├── api_client.dart           # HTTP client with retry logic
│   └── my_http_overrides.dart    # Custom HTTP overrides
├── routing/
│   └── app_router.dart           # Navigation (GoRouter with 45+ routes)
├── theme/
│   └── color_extension.dart      # Color theme extensions
└── utils/
    ├── logger.dart               # Logging utility
    └── locator.dart              # Service locator for legacy code
```

**Key Files:**
- **service_locator.dart**: Registers all dependencies (repositories, API client, shared preferences)
- **app_router.dart**: Centralized routing configuration with GoRouter
- **failures.dart**: Standardized error handling with `ServerFailure`, `NetworkFailure`, `CacheFailure`, etc.
- **api_client.dart**: HTTP client with automatic retry, error handling, and logging

---

### 2. **Domain Layer** (`lib/domain/`)

Business logic layer - **completely independent** of frameworks, UI, and data sources.

```
domain/
├── entities/
│   ├── user_entity.dart          # User with UserRole (customer, chef, driver, admin)
│   ├── restaurant_entity.dart    # Restaurant with location, rating, status
│   ├── menu_item_entity.dart     # Menu items with dietary info, customizations
│   └── order_entity.dart         # Orders with status tracking, payment info
└── repositories/
    ├── auth_repository.dart      # Authentication contract (12 methods)
    ├── restaurant_repository.dart # Restaurant & menu contract (13 methods)
    └── order_repository.dart     # Order management contract (13 methods + Stream)
```

#### Entities

**Immutable data models** using `Equatable` for value equality:

| Entity | Key Features |
|--------|--------------|
| **UserEntity** | UserRole enum, email/phone verification, profile image |
| **RestaurantEntity** | GeoLocation (lat/lng), rating, delivery fee, cuisineType, tags |
| **MenuItemEntity** | MenuItemCategory enum, allergens, dietary flags, customizations |
| **OrderEntity** | OrderStatus, PaymentMethod/Status enums, full timeline tracking |

#### Repositories (Interfaces)

| Repository | Methods | Purpose |
|------------|---------|---------|
| **AuthRepository** | 12 | signIn, signUp, sendOTP, verifyOTP, resetPassword, updateProfile |
| **RestaurantRepository** | 13 | getRestaurants, search, getNearbyRestaurants, getMenuItems, toggleFavorite |
| **OrderRepository** | 13 + Stream | createOrder, trackOrder (real-time), cancelOrder, rateOrder, reorder |

---

### 3. **Data Layer** (`lib/data/`) ⏳ _To Be Implemented_

Implements the repository interfaces defined in the domain layer.

```
data/
├── models/
│   ├── user_model.dart           # JSON serialization for UserEntity
│   ├── restaurant_model.dart     # JSON serialization for RestaurantEntity
│   ├── menu_item_model.dart      # JSON serialization for MenuItemEntity
│   └── order_model.dart          # JSON serialization for OrderEntity
├── datasources/
│   ├── auth_remote_datasource.dart
│   ├── auth_local_datasource.dart
│   ├── restaurant_remote_datasource.dart
│   └── order_remote_datasource.dart
└── repositories/
    ├── auth_repository_impl.dart
    ├── restaurant_repository_impl.dart
    └── order_repository_impl.dart
```

**Next Steps:**
1. Create models with `json_serializable` for API serialization
2. Implement remote data sources using `ApiClient`
3. Implement local data sources using `SharedPreferences` / Hive
4. Implement repositories combining remote + local data sources

---

### 4. **Presentation Layer** (`lib/presentation/`)

UI components, pages, widgets, and **state management** (Riverpod).

```
presentation/
├── providers/
│   ├── auth_provider.dart         # AuthState & AuthNotifier (login, signup, OTP)
│   ├── cart_provider.dart         # CartState & CartNotifier (add/remove items, fees)
│   ├── restaurant_provider.dart   # RestaurantState & RestaurantNotifier (search, favorites)
│   └── order_provider.dart        # OrderState & OrderNotifier (create, track, rate)
├── pages/
│   ├── auth/                      # Welcome, Login, SignUp, OTP, ResetPassword
│   ├── onboarding/                # Startup, Onboarding screens
│   ├── main/                      # Home, Menu, Profile, More
│   ├── cart/                      # Cart, EmptyCart, Checkout
│   ├── order/                     # MyOrders, OrderDetail, OrderSuccess
│   ├── search/                    # Search with filters
│   ├── favorites/                 # Favorites management
│   ├── chef/                      # Chef dashboard (ChefHome, ChefOrders, ChefMenu)
│   └── driver/                    # Driver dashboard (DriverHome, DriverOrders)
└── widgets/
    ├── category_cell.dart
    ├── menu_item_row.dart
    ├── round_button.dart
    ├── round_textfield.dart
    └── tab_button.dart
```

#### State Management (Riverpod)

**4 Main Providers:**

| Provider | State | Methods | Features |
|----------|-------|---------|----------|
| **authProvider** | AuthState | signIn, signUp, sendOTP, verifyOTP, resetPassword | Auto-checks auth status, error handling |
| **cartProvider** | CartState | addItem, removeItem, updateQuantity, applyPromoCode | Auto-calculates fees/tax, clears on restaurant switch |
| **restaurantProvider** | RestaurantState | loadRestaurants, search, toggleFavorite, loadMenuItems | Pagination, caching menu items |
| **orderProvider** | OrderState | createOrder, trackOrder (Stream), cancelOrder, rateOrder | Real-time order tracking |

**Additional Providers:**
- **chefOrderProvider**: Chef-specific order management
- **driverOrderProvider**: Driver-specific order assignment

**Convenience Providers** (computed values):
```dart
final currentUserProvider = Provider<UserEntity?>(...);
final cartTotalProvider = Provider<double>(...);
final activeOrdersProvider = Provider<List<OrderEntity>>(...);
final featuredRestaurantsProvider = Provider<List<RestaurantEntity>>(...);
```

---

## 🛠️ Technology Stack

### Core Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| **flutter_riverpod** | 2.6.1 | State management (StateNotifier pattern) |
| **go_router** | 14.8.1 | Navigation with type-safe routing |
| **equatable** | 2.0.7 | Immutable entities with value equality |
| **dartz** | 0.10.1 | Functional programming (Either, Failure) |
| **get_it** | 8.0.2 | Dependency injection (service locator) |
| **shared_preferences** | | Local storage for auth tokens |

### Planned Dependencies

```yaml
# Data serialization
json_serializable: ^6.7.1
build_runner: ^2.4.6

# Local database
hive: ^2.2.3
hive_flutter: ^1.1.0

# Real-time features
firebase_messaging: ^14.7.6  # Push notifications
firebase_core: ^2.24.2
socket_io_client: ^2.0.3+1   # Real-time order tracking

# Analytics & Monitoring
firebase_analytics: ^10.8.0
sentry_flutter: ^7.14.0

# Testing
mockito: ^5.4.4
flutter_test:
  sdk: flutter
```

---

## 📊 Feature Modules

### ✅ Implemented Features

| Feature | Status | Files |
|---------|--------|-------|
| **Authentication** | ✅ Complete | auth_provider.dart, auth pages (8 screens) |
| **Shopping Cart** | ✅ Complete | cart_provider.dart, cart_view.dart, empty_cart_view.dart |
| **Restaurant Browse** | ✅ Complete | restaurant_provider.dart, home_view.dart, menu pages |
| **Order Management** | ✅ Complete | order_provider.dart, order pages (3 screens) |
| **Search & Filters** | ✅ Complete | search_view.dart |
| **Favorites** | ✅ Complete | favorites_view.dart, toggleFavorite method |
| **Navigation** | ✅ Complete | app_router.dart (45+ routes with GoRouter) |
| **Error Handling** | ✅ Complete | failures.dart, Either pattern throughout |

### ⏳ Pending Features

| Feature | Status | Next Steps |
|---------|--------|------------|
| **Real-time Tracking** | ⏳ Planned | Implement WebSocket/Firebase for live order updates |
| **Push Notifications** | ⏳ Planned | Integrate Firebase Cloud Messaging |
| **Analytics** | ⏳ Planned | Add Firebase Analytics events |
| **Offline Support** | ⏳ Planned | Implement local caching with Hive |
| **Payment Integration** | ⏳ Planned | Integrate Stripe/Razorpay |
| **Image Upload** | ⏳ Planned | Implement Firebase Storage for profile/menu images |
| **Testing** | ⏳ Planned | Unit tests, widget tests, integration tests |

---

## 🚀 Getting Started

### 1. Installation

```bash
# Install dependencies
flutter pub get

# Run code generation (when data layer is implemented)
flutter pub run build_runner build --delete-conflicting-outputs
```

### 2. Run the App

```bash
# Debug mode
flutter run

# Release mode
flutter run --release

# Specific device
flutter run -d <device_id>
```

### 3. Environment Configuration

Update `lib/core/config/app_config.dart`:

```dart
AppConfig.dev      // Development environment
AppConfig.staging  // Staging environment
AppConfig.prod     // Production environment
```

---

## 📝 Development Guidelines

### State Management Pattern

**Use StateNotifier for complex state:**

```dart
class MyNotifier extends StateNotifier<MyState> {
  final MyRepository _repository;

  MyNotifier(this._repository) : super(MyState.initial()) {
    _init();
  }

  Future<void> someAction() async {
    state = state.copyWith(isLoading: true);
    
    final result = await _repository.someMethod();
    
    result.fold(
      (failure) => state = state.copyWith(
        isLoading: false,
        error: failure.message,
      ),
      (data) => state = state.copyWith(
        isLoading: false,
        data: data,
      ),
    );
  }
}
```

### Error Handling Pattern

**Always use Either for operations that can fail:**

```dart
Future<Either<Failure, SomeData>> someMethod() async {
  try {
    final result = await apiClient.get('/endpoint');
    return Right(result);
  } on NetworkException {
    return Left(NetworkFailure('No internet connection'));
  } catch (e) {
    return Left(ServerFailure(e.toString()));
  }
}
```

### Repository Implementation Pattern

```dart
class SomeRepositoryImpl implements SomeRepository {
  final SomeRemoteDataSource _remoteDataSource;
  final SomeLocalDataSource _localDataSource;

  SomeRepositoryImpl({
    required SomeRemoteDataSource remoteDataSource,
    required SomeLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, Data>> getData() async {
    try {
      // Try remote first
      final remoteData = await _remoteDataSource.getData();
      
      // Cache locally
      await _localDataSource.cacheData(remoteData);
      
      return Right(remoteData);
    } on NetworkException {
      // Fallback to cache
      try {
        final cachedData = await _localDataSource.getCachedData();
        return Right(cachedData);
      } catch (e) {
        return Left(CacheFailure('No cached data available'));
      }
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
```

---

## 🧪 Testing Strategy

### Unit Tests
- Test domain entities
- Test repository implementations
- Test business logic in providers

### Widget Tests
- Test individual widgets
- Test page layouts
- Test user interactions

### Integration Tests
- Test complete user flows
- Test navigation
- Test API integration

---

## 📦 Build & Deployment

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle
flutter build appbundle --release
```

### iOS

```bash
# Build for iOS
flutter build ios --release

# Build IPA (requires Xcode)
flutter build ipa --release
```

---

## 🎯 Roadmap

### Phase 1: Foundation ✅
- [x] Clean Architecture setup
- [x] Domain entities (User, Restaurant, MenuItem, Order)
- [x] Repository interfaces
- [x] State management with Riverpod
- [x] Navigation with GoRouter
- [x] Error handling system

### Phase 2: Data Layer ⏳
- [ ] JSON models with serialization
- [ ] Remote data sources
- [ ] Local data sources
- [ ] Repository implementations
- [ ] Dependency injection wiring

### Phase 3: Advanced Features ⏳
- [ ] Real-time order tracking (WebSocket/Firebase)
- [ ] Push notifications (FCM)
- [ ] Payment integration
- [ ] Image upload & optimization
- [ ] Offline support
- [ ] Analytics & crash reporting

### Phase 4: Testing & Optimization ⏳
- [ ] Unit tests (80%+ coverage)
- [ ] Widget tests
- [ ] Integration tests
- [ ] Performance optimization
- [ ] Code documentation

### Phase 5: Production ⏳
- [ ] Beta testing
- [ ] Bug fixes
- [ ] App Store submission
- [ ] Production monitoring

---

## 🤝 Contributing

1. Follow Clean Architecture principles
2. Use `Either<Failure, T>` for error handling
3. Write tests for new features
4. Document complex logic
5. Follow Dart/Flutter style guide

---

## 📄 License

This project is licensed under the MIT License.

---

**Last Updated:** January 2025
**Flutter Version:** 3.32.5
**Architecture:** Clean Architecture + Riverpod
