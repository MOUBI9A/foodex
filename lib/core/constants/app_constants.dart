/// App-wide constants and configuration values
class AppConstants {
  // App Information
  static const String appName = 'FoodEx';
  static const String appVersion = '1.0.0';
  static const String appDescription = 'Community Food Marketplace';

  // API Configuration
  static const String baseUrl = 'https://api.foodex.com';
  static const String apiVersion = 'v1';
  static const Duration requestTimeout = Duration(seconds: 30);

  // Storage Keys
  static const String userTokenKey = 'user_token';
  static const String userTypeKey = 'user_type';
  static const String onboardingKey = 'onboarding_completed';
  static const String walletBalanceKey = 'wallet_balance';

  // UI Constants
  static const double defaultPadding = 16.0;
  static const double smallPadding = 8.0;
  static const double largePadding = 24.0;
  static const double borderRadius = 12.0;
  static const double buttonHeight = 56.0;

  // Animation Durations
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);

  // User Types
  static const String userTypeCustomer = 'customer';
  static const String userTypeChef = 'chef';
  static const String userTypeDriver = 'driver';

  // Order Status
  static const String orderStatusPending = 'pending';
  static const String orderStatusConfirmed = 'confirmed';
  static const String orderStatusPreparing = 'preparing';
  static const String orderStatusReady = 'ready';
  static const String orderStatusPickedUp = 'picked_up';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';

  // Payment Methods
  static const String paymentWallet = 'wallet';
  static const String paymentCard = 'card';
  static const String paymentCash = 'cash';
  static const String paymentPaypal = 'paypal';

  // Currency
  static const String currency = 'MAD';
  static const String currencySymbol = 'DH';

  // Map Configuration
  static const double defaultLatitude = 33.5731; // Casablanca, Morocco
  static const double defaultLongitude = -7.5898;
  static const double mapZoom = 14.0;

  // Image Paths
  static const String imageBasePath = 'assets/images/';
  static const String iconBasePath = 'assets/icons/';
  static const String fontBasePath = 'assets/fonts/';

  // Font Family
  static const String fontFamily = 'Metropolis';
}
