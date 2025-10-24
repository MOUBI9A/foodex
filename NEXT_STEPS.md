# 🎯 Next Steps - Implementation Roadmap

## Current Status: ✅ Clean Architecture Foundation Complete

Your food delivery app now has a **world-class architecture**. Here's what to do next to complete the implementation.

---

## 🚀 Phase 2: Data Layer Implementation (PRIORITY)

### Step 1: Add Code Generation Dependencies

```bash
flutter pub add json_annotation
flutter pub add --dev build_runner json_serializable
```

### Step 2: Create JSON Models

Create these files with `@JsonSerializable()` annotation:

#### `/lib/data/models/user_model.dart`

```dart
import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/user_entity.dart';

part 'user_model.g.dart';

@JsonSerializable()
class UserModel extends UserEntity {
  const UserModel({
    required super.id,
    required super.email,
    required super.name,
    required super.phone,
    required super.role,
    super.profileImage,
    super.isEmailVerified,
    super.isPhoneVerified,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);

  factory UserModel.fromEntity(UserEntity entity) {
    return UserModel(
      id: entity.id,
      email: entity.email,
      name: entity.name,
      phone: entity.phone,
      role: entity.role,
      profileImage: entity.profileImage,
      isEmailVerified: entity.isEmailVerified,
      isPhoneVerified: entity.isPhoneVerified,
      createdAt: entity.createdAt,
      updatedAt: entity.updatedAt,
    );
  }
}
```

**Similar models needed:**
- `restaurant_model.dart`
- `menu_item_model.dart`
- `order_model.dart`

### Step 3: Generate JSON Serialization Code

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This will generate `*.g.dart` files with fromJson/toJson methods.

---

### Step 4: Implement Data Sources

#### Remote Data Sources (API Calls)

**`/lib/data/datasources/auth_remote_datasource.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_client.dart';
import '../../core/config/app_config.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> signIn({required String email, required String password});
  Future<UserModel> signUp({required String email, required String password, required String name});
  Future<void> sendOTP({required String phone});
  // ... other methods
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _apiClient;

  AuthRemoteDataSourceImpl({required ApiClient apiClient}) : _apiClient = apiClient;

  @override
  Future<UserModel> signIn({required String email, required String password}) async {
    final response = await _apiClient.post(
      '${AppConfig.baseUrl}${AppConfig.authEndpoint}/login',
      body: {'email': email, 'password': password},
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return UserModel.fromJson(json['data']);
    } else {
      throw ServerFailure('Login failed');
    }
  }

  // Implement other methods...
}
```

#### Local Data Sources (Caching)

**`/lib/data/datasources/auth_local_datasource.dart`**

```dart
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

abstract class AuthLocalDataSource {
  Future<void> cacheAuthToken(String token);
  Future<String?> getCachedAuthToken();
  Future<void> cacheUser(UserModel user);
  Future<UserModel?> getCachedUser();
  Future<void> clearCache();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences _prefs;

  static const String _keyAuthToken = 'auth_token';
  static const String _keyUser = 'cached_user';

  AuthLocalDataSourceImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<void> cacheAuthToken(String token) async {
    await _prefs.setString(_keyAuthToken, token);
  }

  @override
  Future<String?> getCachedAuthToken() async {
    return _prefs.getString(_keyAuthToken);
  }

  @override
  Future<void> cacheUser(UserModel user) async {
    await _prefs.setString(_keyUser, jsonEncode(user.toJson()));
  }

  @override
  Future<UserModel?> getCachedUser() async {
    final jsonString = _prefs.getString(_keyUser);
    if (jsonString != null) {
      return UserModel.fromJson(jsonDecode(jsonString));
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    await _prefs.remove(_keyAuthToken);
    await _prefs.remove(_keyUser);
  }
}
```

---

### Step 5: Implement Repositories

**`/lib/data/repositories/auth_repository_impl.dart`**

```dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../datasources/auth_local_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;
  final AuthLocalDataSource _localDataSource;

  AuthRepositoryImpl({
    required AuthRemoteDataSource remoteDataSource,
    required AuthLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  }) async {
    try {
      // Call API
      final user = await _remoteDataSource.signIn(
        email: email,
        password: password,
      );

      // Cache user
      await _localDataSource.cacheUser(user);

      // Cache token (if returned by API)
      // await _localDataSource.cacheAuthToken(token);

      return Right(user);
    } on NetworkException {
      return Left(NetworkFailure('No internet connection'));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(UnknownFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity?>> getCurrentUser() async {
    try {
      // Try to get cached user
      final cachedUser = await _localDataSource.getCachedUser();
      
      if (cachedUser != null) {
        return Right(cachedUser);
      }

      // If no cache, try to fetch from API (requires valid token)
      // final user = await _remoteDataSource.getCurrentUser();
      // return Right(user);

      return const Right(null);
    } catch (e) {
      return Left(CacheFailure('Failed to get user'));
    }
  }

  // Implement other methods...
}
```

**Similar implementations needed:**
- `restaurant_repository_impl.dart`
- `order_repository_impl.dart`

---

### Step 6: Update Service Locator

**Update `/lib/core/di/service_locator.dart`:**

```dart
// Uncomment and implement:

// Data sources
serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
  () => AuthRemoteDataSourceImpl(apiClient: serviceLocator()),
);

serviceLocator.registerLazySingleton<AuthLocalDataSource>(
  () => AuthLocalDataSourceImpl(sharedPreferences: serviceLocator()),
);

// Repositories
serviceLocator.registerLazySingleton<AuthRepository>(
  () => AuthRepositoryImpl(
    remoteDataSource: serviceLocator(),
    localDataSource: serviceLocator(),
  ),
);

// Same for RestaurantRepository and OrderRepository
```

---

### Step 7: Update Providers to Use Real Repositories

**Update `/lib/presentation/providers/auth_provider.dart`:**

```dart
// Replace the placeholder provider:
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return serviceLocator<AuthRepository>();  // Use GetIt
});
```

**Do the same for:**
- `restaurant_provider.dart`
- `order_provider.dart`

---

## 📱 Phase 3: Advanced Features

### 1. Real-time Order Tracking

**Option A: Firebase Realtime Database**

```bash
flutter pub add firebase_core firebase_database
```

**Option B: WebSocket**

```bash
flutter pub add web_socket_channel
```

**Implementation in OrderRepository:**

```dart
@override
Stream<OrderEntity> trackOrder(String orderId) {
  // WebSocket approach
  final channel = WebSocketChannel.connect(
    Uri.parse('wss://api.fooddelivery.com/orders/$orderId/track'),
  );

  return channel.stream.map((data) {
    final json = jsonDecode(data);
    return OrderModel.fromJson(json);
  });
}
```

---

### 2. Push Notifications

```bash
flutter pub add firebase_messaging
```

**Setup:**

1. Add Firebase to your project
2. Configure FCM in Firebase Console
3. Implement notification handling:

```dart
class NotificationService {
  final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  Future<void> initialize() async {
    // Request permission (iOS)
    await _messaging.requestPermission();

    // Get FCM token
    final token = await _messaging.getToken();
    print('FCM Token: $token');

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notification: ${message.notification?.title}');
      // Show local notification
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }
}
```

---

### 3. Payment Integration

**Stripe:**

```bash
flutter pub add flutter_stripe
```

**Implementation:**

```dart
class PaymentService {
  Future<PaymentIntent> createPaymentIntent({
    required double amount,
    required String currency,
  }) async {
    final response = await apiClient.post(
      '/payments/create-intent',
      body: {
        'amount': (amount * 100).toInt(), // Convert to cents
        'currency': currency,
      },
    );

    return PaymentIntent.fromJson(jsonDecode(response.body));
  }

  Future<void> processPayment({
    required String paymentIntentId,
    required String cardNumber,
    required String expiryDate,
    required String cvv,
  }) async {
    // Process with Stripe SDK
    await Stripe.instance.confirmPayment(
      paymentIntentClientSecret: paymentIntentId,
      // ... card details
    );
  }
}
```

---

### 4. Offline Support

```bash
flutter pub add hive hive_flutter
flutter pub add --dev hive_generator
```

**Setup:**

```dart
// Initialize Hive
await Hive.initFlutter();

// Register adapters
Hive.registerAdapter(RestaurantModelAdapter());
Hive.registerAdapter(MenuItemModelAdapter());

// Open boxes
final restaurantsBox = await Hive.openBox<RestaurantModel>('restaurants');
final menuItemsBox = await Hive.openBox<MenuItemModel>('menu_items');
```

**Usage in Repository:**

```dart
@override
Future<Either<Failure, List<RestaurantEntity>>> getRestaurants() async {
  try {
    // Try network first
    final restaurants = await _remoteDataSource.getRestaurants();
    
    // Cache in Hive
    await _localDataSource.cacheRestaurants(restaurants);
    
    return Right(restaurants);
  } on NetworkException {
    // Fallback to cached data
    final cachedRestaurants = await _localDataSource.getCachedRestaurants();
    return Right(cachedRestaurants);
  }
}
```

---

### 5. Analytics

```bash
flutter pub add firebase_analytics
```

**Implementation:**

```dart
class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  Future<void> logEvent(String name, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(
      name: name,
      parameters: parameters,
    );
  }

  // Pre-defined events
  Future<void> logOrderPlaced(String orderId, double amount) async {
    await _analytics.logEvent(
      name: 'order_placed',
      parameters: {
        'order_id': orderId,
        'value': amount,
        'currency': 'USD',
      },
    );
  }

  Future<void> logRestaurantViewed(String restaurantId) async {
    await _analytics.logEvent(
      name: 'restaurant_viewed',
      parameters: {'restaurant_id': restaurantId},
    );
  }
}
```

---

## 🧪 Phase 4: Testing

### Unit Tests

**Create `/test/domain/entities/user_entity_test.dart`:**

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/domain/entities/user_entity.dart';

void main() {
  group('UserEntity', () {
    test('should be equal when all properties match', () {
      final user1 = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        // ... other properties
      );

      final user2 = UserEntity(
        id: '1',
        email: 'test@example.com',
        name: 'Test User',
        // ... same properties
      );

      expect(user1, equals(user2));
    });
  });
}
```

### Widget Tests

```dart
testWidgets('Login button should call signIn', (tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: LoginPage(),
      ),
    ),
  );

  // Find widgets
  final emailField = find.byType(TextField).first;
  final passwordField = find.byType(TextField).last;
  final loginButton = find.byType(ElevatedButton);

  // Enter text
  await tester.enterText(emailField, 'test@example.com');
  await tester.enterText(passwordField, 'password123');

  // Tap button
  await tester.tap(loginButton);
  await tester.pump();

  // Verify
  // ... assertions
});
```

---

## 📊 Recommended Feature Priority

| Priority | Feature | Effort | Impact |
|----------|---------|--------|--------|
| **P0** | Data Layer (API integration) | High | Critical |
| **P0** | Authentication flow | Medium | Critical |
| **P1** | Restaurant browsing & ordering | High | High |
| **P1** | Real-time order tracking | Medium | High |
| **P2** | Push notifications | Low | High |
| **P2** | Payment integration | Medium | High |
| **P3** | Offline support | Medium | Medium |
| **P3** | Analytics | Low | Medium |
| **P4** | Advanced search filters | Low | Low |

---

## 🎯 Immediate Action Items

1. **Today:** Implement Data Layer (JSON models, data sources, repositories)
2. **This Week:** Connect providers to real repositories and test auth flow
3. **Next Week:** Implement restaurant browsing and ordering
4. **Week 3:** Add real-time tracking and push notifications
5. **Week 4:** Payment integration and testing
6. **Week 5:** Offline support and polish
7. **Week 6:** Beta testing and bug fixes

---

## 📚 Resources

- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
- [Riverpod Documentation](https://riverpod.dev)
- [JSON Serialization](https://docs.flutter.dev/development/data-and-backend/json)
- [Firebase for Flutter](https://firebase.google.com/docs/flutter/setup)
- [Testing Flutter Apps](https://docs.flutter.dev/testing)

---

**You're 70% done! The hard part (architecture) is complete. Now it's just connecting the pieces! 🚀**
