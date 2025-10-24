/// Application Configuration
/// Manages environment-specific settings and constants
class AppConfig {
  // App Information
  static const String appName = 'FoodEx';
  static const String appVersion = '1.0.0';
  static const String buildNumber = '1';

  // Environment
  static const Environment environment = Environment.development;

  // API Configuration
  static String get baseUrl {
    switch (environment) {
      case Environment.development:
        return 'https://dev-api.foodex.com/v1';
      case Environment.staging:
        return 'https://staging-api.foodex.com/v1';
      case Environment.production:
        return 'https://api.foodex.com/v1';
    }
  }

  // API Endpoints
  static const String authEndpoint = '/auth';
  static const String usersEndpoint = '/users';
  static const String restaurantsEndpoint = '/restaurants';
  static const String ordersEndpoint = '/orders';
  static const String menusEndpoint = '/menus';
  static const String walletsEndpoint = '/wallets';
  static const String transactionsEndpoint = '/transactions';
  static const String notificationsEndpoint = '/notifications';
  static const String reviewsEndpoint = '/reviews';

  // API Timeouts (in seconds)
  static const int connectionTimeout = 30;
  static const int receiveTimeout = 30;
  static const int sendTimeout = 30;

  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;

  // Google Maps
  static String get googleMapsApiKey {
    switch (environment) {
      case Environment.development:
        return 'YOUR_DEV_GOOGLE_MAPS_KEY';
      case Environment.staging:
        return 'YOUR_STAGING_GOOGLE_MAPS_KEY';
      case Environment.production:
        return 'YOUR_PROD_GOOGLE_MAPS_KEY';
    }
  }

  // Firebase
  static String get firebaseProjectId {
    switch (environment) {
      case Environment.development:
        return 'foodex-dev';
      case Environment.staging:
        return 'foodex-staging';
      case Environment.production:
        return 'foodex-prod';
    }
  }

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userDataKey = 'user_data';
  static const String userTypeKey = 'user_type';
  static const String languageKey = 'language';
  static const String themeKey = 'theme';
  static const String onboardingKey = 'onboarding_complete';

  // Features Flags
  static const bool enableAnalytics = true;
  static const bool enableCrashReporting = true;
  static const bool enablePerformanceMonitoring = true;
  static const bool enableLogging = environment != Environment.production;
  static const bool enableDebugLogging = environment != Environment.production;

  // Business Rules
  static const double minimumOrderAmount = 20.0;
  static const double deliveryFeeBase = 5.0;
  static const double serviceFeePercentage = 0.05; // 5%
  static const int maxCartItems = 50;
  static const int orderCancellationTimeMinutes = 10;

  // Wallet
  static const double minTopUpAmount = 10.0;
  static const double maxTopUpAmount = 5000.0;
  static const String defaultCurrency = 'MAD';
  static const String currencySymbol = 'DH';

  // UI Configuration
  static const double defaultPadding = 16.0;
  static const double defaultRadius = 12.0;
  static const double defaultElevation = 2.0;
  static const int animationDurationMs = 300;

  // Image Sizes (for optimization)
  static const int thumbnailSize = 200;
  static const int mediumSize = 600;
  static const int largeSize = 1200;
  static const int imageQuality = 85;

  // Push Notifications
  static const bool enablePushNotifications = true;
  static const String fcmTopicAllUsers = 'all-users';
  static const String fcmTopicCustomers = 'customers';
  static const String fcmTopicChefs = 'chefs';
  static const String fcmTopicDrivers = 'drivers';

  // Rate Limiting
  static const int maxLoginAttempts = 5;
  static const int loginLockoutMinutes = 15;

  // Cache
  static const int cacheDurationMinutes = 15;
  static const int imageCacheDurationDays = 7;

  // Social Login
  static const bool enableGoogleLogin = true;
  static const bool enableFacebookLogin = true;
  static const bool enableAppleLogin = true;

  // Development
  static const bool mockAPIResponses = environment == Environment.development;
  static const bool showPerformanceOverlay = false;
  static const bool showDebugInfo = environment != Environment.production;
}

/// Application Environment
enum Environment {
  development,
  staging,
  production,
}

/// User Types
enum UserType {
  customer,
  chef,
  driver,
}

extension UserTypeExtension on UserType {
  String get value {
    switch (this) {
      case UserType.customer:
        return 'customer';
      case UserType.chef:
        return 'chef';
      case UserType.driver:
        return 'driver';
    }
  }

  String get displayName {
    switch (this) {
      case UserType.customer:
        return 'Customer';
      case UserType.chef:
        return 'Home Chef';
      case UserType.driver:
        return 'Courier';
    }
  }
}
