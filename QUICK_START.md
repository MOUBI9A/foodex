# FoodEx - Quick Start Guide for Professional Architecture

## 🎯 Current Status

✅ **Phase 1 Complete** - Professional Infrastructure  
The application now has a solid foundation with:
- Clean Architecture structure
- Professional API client with retry logic
- Comprehensive error handling system
- Type-safe routing with GoRouter
- Environment-based configuration
- Professional logging system

## 📋 What's Next - Immediate Tasks

### Task 1: Create Domain Entities (30 minutes)

Run code generation for Freezed models:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

The following entities are needed in `lib/domain/entities/`:
- `user.dart` - User model with authentication data
- `restaurant.dart` - Restaurant model with menu items
- `menu_item.dart` - Food items model
- `order.dart` - Order model with status tracking
- `cart_item.dart` - Shopping cart items
- `address.dart` - Delivery addresses
- `payment_method.dart` - Payment methods
- `wallet.dart` - Wallet balance and history
- `transaction.dart` - Transaction history

### Task 2: Implement Repositories (45 minutes)

Create repository interfaces in `lib/domain/repositories/`:
- `i_auth_repository.dart`
- `i_restaurant_repository.dart`
- `i_order_repository.dart`
- `i_cart_repository.dart`
- `i_user_repository.dart`
- `i_wallet_repository.dart`

Implement repositories in `lib/data/repositories/`:
- `auth_repository.dart`
- `restaurant_repository.dart`
- `order_repository.dart`
- `cart_repository.dart`
- `user_repository.dart`
- `wallet_repository.dart`

### Task 3: Setup Dependency Injection (15 minutes)

Create `lib/core/di/service_locator.dart` to register:
- API Client
- Repositories
- Use Cases
- SharedPreferences

### Task 4: Create Riverpod Providers (45 minutes)

Create providers in `lib/presentation/providers/`:
- `auth_provider.dart` - Authentication state
- `user_provider.dart` - User profile
- `restaurants_provider.dart` - Restaurant list
- `cart_provider.dart` - Shopping cart
- `orders_provider.dart` - Order history
- `wallet_provider.dart` - Wallet balance

Run code generation:
```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

### Task 5: Update Main App (15 minutes)

Update `lib/main.dart`:
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/routing/app_router.dart';
import 'core/di/service_locator.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize service locator
  await setupServiceLocator();
  
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'FoodEx',
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        useMaterial3: true,
      ),
    );
  }
}
```

## 🧪 Testing the Setup

After implementing the above:

1. **Run the app:**
   ```bash
   flutter run
   ```

2. **Check for compilation errors:**
   ```bash
   flutter analyze
   ```

3. **Generate code (if using Freezed/Riverpod generators):**
   ```bash
   flutter pub run build_runner watch --delete-conflicting-outputs
   ```

## 📚 Code Examples

### Example: User Entity with Freezed
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class User with _$User {
  const factory User({
    required String id,
    required String name,
    required String email,
    String? phone,
    String? photoUrl,
    @Default(UserType.customer) UserType type,
    @Default(false) bool isEmailVerified,
  }) = _User;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

enum UserType {
  customer,
  driver,
  chef,
}
```

### Example: Auth Repository Interface
```dart
import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user.dart';

abstract class IAuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, User>> register(String email, String password, String name);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, User?>> getCurrentUser();
  Future<Either<Failure, void>> resetPassword(String email);
}
```

### Example: Auth Repository Implementation
```dart
import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/errors/failures.dart';
import '../../core/network/api_client.dart';
import '../../core/config/app_config.dart';
import '../../core/utils/logger.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';

class AuthRepository implements IAuthRepository {
  final ApiClient _apiClient;
  final SharedPreferences _prefs;
  final _logger = Logger('AuthRepository');
  
  AuthRepository(this._apiClient, this._prefs);
  
  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        endpoint: '${AppConfig.authEndpoint}/login',
        body: {'email': email, 'password': password},
        fromJson: (json) => json,
      );
      
      final user = User.fromJson(response['user']);
      final token = response['token'] as String;
      
      await _prefs.setString(AppConfig.userTokenKey, token);
      _apiClient.setAuthToken(token);
      
      _logger.info('Login successful for $email');
      return Right(user);
      
    } on NetworkException catch (e) {
      _logger.error('Network error during login', error: e);
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      _logger.error('Server error during login', error: e);
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e, stack) {
      _logger.error('Unexpected error during login', error: e, stackTrace: stack);
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, User>> register(String email, String password, String name) async {
    try {
      final response = await _apiClient.post<Map<String, dynamic>>(
        endpoint: '${AppConfig.authEndpoint}/register',
        body: {'email': email, 'password': password, 'name': name},
        fromJson: (json) => json,
      );
      
      final user = User.fromJson(response['user']);
      final token = response['token'] as String;
      
      await _prefs.setString(AppConfig.userTokenKey, token);
      _apiClient.setAuthToken(token);
      
      _logger.info('Registration successful for $email');
      return Right(user);
      
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e, stack) {
      _logger.error('Unexpected error during registration', error: e, stackTrace: stack);
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await _apiClient.post<Map<String, dynamic>>(
        endpoint: '${AppConfig.authEndpoint}/logout',
        fromJson: (json) => json,
      );
      
      await _prefs.remove(AppConfig.userTokenKey);
      _apiClient.clearAuthToken();
      
      _logger.info('Logout successful');
      return const Right(null);
      
    } catch (e, stack) {
      _logger.error('Error during logout', error: e, stackTrace: stack);
      // Even if API call fails, clear local data
      await _prefs.remove(AppConfig.userTokenKey);
      _apiClient.clearAuthToken();
      return const Right(null);
    }
  }
  
  @override
  Future<Either<Failure, User?>> getCurrentUser() async {
    try {
      final token = _prefs.getString(AppConfig.userTokenKey);
      if (token == null) {
        return const Right(null);
      }
      
      _apiClient.setAuthToken(token);
      
      final user = await _apiClient.get<User>(
        endpoint: '${AppConfig.usersEndpoint}/me',
        fromJson: User.fromJson,
      );
      
      return Right(user);
      
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      if (e.statusCode == 401) {
        await _prefs.remove(AppConfig.userTokenKey);
        return const Right(null);
      }
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e, stack) {
      _logger.error('Error getting current user', error: e, stackTrace: stack);
      return Left(UnknownFailure(e.toString()));
    }
  }
  
  @override
  Future<Either<Failure, void>> resetPassword(String email) async {
    try {
      await _apiClient.post<Map<String, dynamic>>(
        endpoint: '${AppConfig.authEndpoint}/reset-password',
        body: {'email': email},
        fromJson: (json) => json,
      );
      
      _logger.info('Password reset email sent to $email');
      return const Right(null);
      
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message, statusCode: e.statusCode));
    } catch (e, stack) {
      _logger.error('Error sending password reset', error: e, stackTrace: stack);
      return Left(UnknownFailure(e.toString()));
    }
  }
}
```

### Example: Auth Provider with Riverpod
```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/i_auth_repository.dart';
import '../../core/di/service_locator.dart';

part 'auth_provider.freezed.dart';

@freezed
class AuthState with _$AuthState {
  const factory AuthState.initial() = _Initial;
  const factory AuthState.loading() = _Loading;
  const factory AuthState.authenticated(User user) = _Authenticated;
  const factory AuthState.unauthenticated() = _Unauthenticated;
  const factory AuthState.error(String message) = _Error;
}

final authRepositoryProvider = Provider<IAuthRepository>((ref) => sl<IAuthRepository>());

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.watch(authRepositoryProvider));
});

class AuthNotifier extends StateNotifier<AuthState> {
  final IAuthRepository _authRepository;
  
  AuthNotifier(this._authRepository) : super(const AuthState.initial()) {
    checkAuthStatus();
  }
  
  Future<void> checkAuthStatus() async {
    state = const AuthState.loading();
    final result = await _authRepository.getCurrentUser();
    state = result.fold(
      (failure) => const AuthState.unauthenticated(),
      (user) => user != null
          ? AuthState.authenticated(user)
          : const AuthState.unauthenticated(),
    );
  }
  
  Future<void> login(String email, String password) async {
    state = const AuthState.loading();
    final result = await _authRepository.login(email, password);
    state = result.fold(
      (failure) => AuthState.error(failure.message),
      (user) => AuthState.authenticated(user),
    );
  }
  
  Future<void> register(String email, String password, String name) async {
    state = const AuthState.loading();
    final result = await _authRepository.register(email, password, name);
    state = result.fold(
      (failure) => AuthState.error(failure.message),
      (user) => AuthState.authenticated(user),
    );
  }
  
  Future<void> logout() async {
    await _authRepository.logout();
    state = const AuthState.unauthenticated();
  }
}
```

### Example: Using Provider in UI
```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/providers/auth_provider.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  void _login() {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();
    
    ref.read(authProvider.notifier).login(email, password);
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    
    // Listen to auth state changes
    ref.listen<AuthState>(authProvider, (previous, next) {
      next.when(
        initial: () {},
        loading: () {},
        authenticated: (user) {
          // Navigate to home
          context.go('/main');
        },
        unauthenticated: () {},
        error: (message) {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message)),
          );
        },
      );
    });
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 24),
              authState.maybeWhen(
                loading: () => const CircularProgressIndicator(),
                orElse: () => ElevatedButton(
                  onPressed: _login,
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

## 🎨 UI Migration Strategy

The existing UI files can be gradually migrated:

1. **Keep existing UI** - No need to rewrite everything
2. **Replace state management** - Change from setState to Riverpod
3. **Update navigation** - Use `context.go()` instead of `Navigator.push()`
4. **Add error handling** - Show user-friendly error messages
5. **Update API calls** - Use repositories instead of direct HTTP

## 📖 Resources

- [Riverpod Documentation](https://riverpod.dev)
- [GoRouter Documentation](https://pub.dev/packages/go_router)
- [Freezed Documentation](https://pub.dev/packages/freezed)
- [Dartz Documentation](https://pub.dev/packages/dartz)
- [Clean Architecture Guide](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)

## ⚠️ Important Notes

1. **API URLs** - Update `app_config.dart` with real API endpoints
2. **Firebase** - Configure Firebase for each platform if using
3. **Google Maps** - Add API keys for maps functionality
4. **Code Generation** - Run build_runner when adding Freezed models
5. **Testing** - Write tests after implementing core features

## 🐛 Common Issues

**Issue:** "Target of URI doesn't exist" for go_router  
**Solution:** Run `flutter pub get` again

**Issue:** Generated files not found (*.freezed.dart, *.g.dart)  
**Solution:** Run `flutter pub run build_runner build --delete-conflicting-outputs`

**Issue:** "Undefined class 'Either'"  
**Solution:** Import `import 'package:dartz/dartz.dart';`

**Issue:** Provider not found  
**Solution:** Wrap app with `ProviderScope` in main.dart

---

**Ready to continue? Start with Task 1: Create Domain Entities!** 🚀
