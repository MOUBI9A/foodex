// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'FoodEx';

  @override
  String get loginHeroTitle => 'Sign in to FoodEx';

  @override
  String get loginHeroSubtitle =>
      'Fresh meals from local home chefs, delivered to your door.';

  @override
  String get roleCustomer => 'Customer';

  @override
  String get roleCustomerCaption => 'Discover home-chef meals';

  @override
  String get roleChef => 'Chef';

  @override
  String get roleChefCaption => 'Manage orders & menus';

  @override
  String get roleDriver => 'Driver';

  @override
  String get roleDriverCaption => 'Track deliveries';

  @override
  String loginWelcomeBack(String role) {
    return 'Welcome back, $role';
  }

  @override
  String get loginFormSubtitle =>
      'Sign in to continue ordering and tracking meals.';

  @override
  String get emailLabel => 'Email address';

  @override
  String get emailHint => 'chef@foodex.com';

  @override
  String get errorEmailRequired => 'Enter your email address';

  @override
  String get errorEmailInvalid => 'Enter a valid email';

  @override
  String get passwordLabel => 'Password';

  @override
  String get passwordHint => '••••••••';

  @override
  String get errorPasswordLength => 'Password must be at least 6 characters';

  @override
  String get rememberMe => 'Remember me';

  @override
  String get forgotPassword => 'Forgot password?';

  @override
  String get actionLogin => 'Login';

  @override
  String get orContinueWith => 'or continue with';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get continueWithFacebook => 'Continue with Facebook';

  @override
  String get loginFooterPrompt => 'New to FoodEx?';

  @override
  String get actionCreateAccount => 'Create an account';

  @override
  String get signupTitle => 'Create a FoodEx account';

  @override
  String get signupSubtitle =>
      'Fill in your information to start ordering or selling meals.';

  @override
  String get fullNameLabel => 'Full name';

  @override
  String get fullNameHint => 'e.g. Sara Amrani';

  @override
  String get errorNameRequired => 'Please enter your name';

  @override
  String get mobileLabel => 'Mobile number';

  @override
  String get mobileHint => '+212 6 00 00 00 00';

  @override
  String get errorMobileRequired => 'Enter your phone number';

  @override
  String get errorMobileLength => 'Phone number looks too short';

  @override
  String get addressLabel => 'Primary address';

  @override
  String get addressHint => 'Apartment, street, city';

  @override
  String get errorAddressRequired => 'Enter your delivery address';

  @override
  String get confirmPasswordLabel => 'Confirm password';

  @override
  String get confirmPasswordHint => 'Repeat password';

  @override
  String get errorConfirmPasswordRequired => 'Confirm your password';

  @override
  String get errorPasswordMismatch => 'Passwords do not match';

  @override
  String get termsAgreementPrefix => 'I agree to the ';

  @override
  String get termsPolicyLink => 'Terms & Privacy Policy';

  @override
  String get errorAcceptTerms => 'Please accept the Terms & Privacy Policy';

  @override
  String get signupAlreadyPrompt => 'Already have an account?';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuSubtitle => 'Browse categories curated by local chefs';

  @override
  String get menuSearchHint => 'Search food, chefs or vibes';

  @override
  String get menuFilterAll => 'All';

  @override
  String get menuFilterMeals => 'Meals';

  @override
  String get menuFilterFamily => 'Family';

  @override
  String get menuFilterQuick => 'Quick bites';

  @override
  String get menuFilterBeverages => 'Beverages';

  @override
  String get menuFilterDesserts => 'Desserts';

  @override
  String get menuFilterPromotions => 'Promotions';

  @override
  String menuResultCurated(int count, String filter) {
    return '$count curated $filter menus';
  }

  @override
  String get menuResultDefault => 'Hand-picked & refreshed daily';

  @override
  String menuCategoriesCount(int count) {
    return '$count categories';
  }

  @override
  String get menuEmptyTitle => 'No menus match your filters';

  @override
  String get menuEmptyBody =>
      'Try a different vibe or reset your search to browse everything again.';

  @override
  String get menuResetFilters => 'Reset filters';

  @override
  String get menuChefPick => 'Chef pick';

  @override
  String menuItemsCount(int count) {
    return '$count items';
  }

  @override
  String get menuItemsSearchHint => 'Search food';

  @override
  String get menuItemsEmptyTitle => 'No items match your search';

  @override
  String get menuItemsEmptyBody =>
      'Try another flavor, ingredient or chef name.';

  @override
  String get deliverToLabel => 'Delivering to';

  @override
  String get changeLocation => 'Change';

  @override
  String get deliveryLocationTitle => 'Delivery location';

  @override
  String get useCurrentLocation => 'Use my current location';

  @override
  String get useCurrentSubtitle => 'Ask GPS and auto-detect address';

  @override
  String get chooseOnMap => 'Choose on map';

  @override
  String get chooseOnMapSubtitle => 'Drop a pin to select the spot';

  @override
  String get deliverHere => 'Deliver here';

  @override
  String get deliveryLocationSheetDescription =>
      'Select how you\'d like us to deliver';
}
