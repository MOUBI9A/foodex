import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
    Locale('fr')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'FoodEx'**
  String get appTitle;

  /// No description provided for @loginHeroTitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to FoodEx'**
  String get loginHeroTitle;

  /// No description provided for @loginHeroSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fresh meals from local home chefs, delivered to your door.'**
  String get loginHeroSubtitle;

  /// No description provided for @roleCustomer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get roleCustomer;

  /// No description provided for @roleCustomerCaption.
  ///
  /// In en, this message translates to:
  /// **'Discover home-chef meals'**
  String get roleCustomerCaption;

  /// No description provided for @roleChef.
  ///
  /// In en, this message translates to:
  /// **'Chef'**
  String get roleChef;

  /// No description provided for @roleChefCaption.
  ///
  /// In en, this message translates to:
  /// **'Manage orders & menus'**
  String get roleChefCaption;

  /// No description provided for @roleDriver.
  ///
  /// In en, this message translates to:
  /// **'Driver'**
  String get roleDriver;

  /// No description provided for @roleDriverCaption.
  ///
  /// In en, this message translates to:
  /// **'Track deliveries'**
  String get roleDriverCaption;

  /// No description provided for @loginWelcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back, {role}'**
  String loginWelcomeBack(String role);

  /// No description provided for @loginFormSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue ordering and tracking meals.'**
  String get loginFormSubtitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get emailLabel;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'chef@foodex.com'**
  String get emailHint;

  /// No description provided for @errorEmailRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get errorEmailRequired;

  /// No description provided for @errorEmailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get errorEmailInvalid;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @passwordHint.
  ///
  /// In en, this message translates to:
  /// **'••••••••'**
  String get passwordHint;

  /// No description provided for @errorPasswordLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get errorPasswordLength;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot password?'**
  String get forgotPassword;

  /// No description provided for @actionLogin.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get actionLogin;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'or continue with'**
  String get orContinueWith;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @continueWithFacebook.
  ///
  /// In en, this message translates to:
  /// **'Continue with Facebook'**
  String get continueWithFacebook;

  /// No description provided for @loginFooterPrompt.
  ///
  /// In en, this message translates to:
  /// **'New to FoodEx?'**
  String get loginFooterPrompt;

  /// No description provided for @actionCreateAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an account'**
  String get actionCreateAccount;

  /// No description provided for @signupTitle.
  ///
  /// In en, this message translates to:
  /// **'Create a FoodEx account'**
  String get signupTitle;

  /// No description provided for @signupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fill in your information to start ordering or selling meals.'**
  String get signupSubtitle;

  /// No description provided for @fullNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Full name'**
  String get fullNameLabel;

  /// No description provided for @fullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Sara Amrani'**
  String get fullNameHint;

  /// No description provided for @errorNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get errorNameRequired;

  /// No description provided for @mobileLabel.
  ///
  /// In en, this message translates to:
  /// **'Mobile number'**
  String get mobileLabel;

  /// No description provided for @mobileHint.
  ///
  /// In en, this message translates to:
  /// **'+212 6 00 00 00 00'**
  String get mobileHint;

  /// No description provided for @errorMobileRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your phone number'**
  String get errorMobileRequired;

  /// No description provided for @errorMobileLength.
  ///
  /// In en, this message translates to:
  /// **'Phone number looks too short'**
  String get errorMobileLength;

  /// No description provided for @addressLabel.
  ///
  /// In en, this message translates to:
  /// **'Primary address'**
  String get addressLabel;

  /// No description provided for @addressHint.
  ///
  /// In en, this message translates to:
  /// **'Apartment, street, city'**
  String get addressHint;

  /// No description provided for @errorAddressRequired.
  ///
  /// In en, this message translates to:
  /// **'Enter your delivery address'**
  String get errorAddressRequired;

  /// No description provided for @confirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm password'**
  String get confirmPasswordLabel;

  /// No description provided for @confirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Repeat password'**
  String get confirmPasswordHint;

  /// No description provided for @errorConfirmPasswordRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get errorConfirmPasswordRequired;

  /// No description provided for @errorPasswordMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get errorPasswordMismatch;

  /// No description provided for @termsAgreementPrefix.
  ///
  /// In en, this message translates to:
  /// **'I agree to the '**
  String get termsAgreementPrefix;

  /// No description provided for @termsPolicyLink.
  ///
  /// In en, this message translates to:
  /// **'Terms & Privacy Policy'**
  String get termsPolicyLink;

  /// No description provided for @errorAcceptTerms.
  ///
  /// In en, this message translates to:
  /// **'Please accept the Terms & Privacy Policy'**
  String get errorAcceptTerms;

  /// No description provided for @signupAlreadyPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get signupAlreadyPrompt;

  /// No description provided for @menuTitle.
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menuTitle;

  /// No description provided for @menuSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Browse categories curated by local chefs'**
  String get menuSubtitle;

  /// No description provided for @menuSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search food, chefs or vibes'**
  String get menuSearchHint;

  /// No description provided for @menuFilterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get menuFilterAll;

  /// No description provided for @menuFilterMeals.
  ///
  /// In en, this message translates to:
  /// **'Meals'**
  String get menuFilterMeals;

  /// No description provided for @menuFilterFamily.
  ///
  /// In en, this message translates to:
  /// **'Family'**
  String get menuFilterFamily;

  /// No description provided for @menuFilterQuick.
  ///
  /// In en, this message translates to:
  /// **'Quick bites'**
  String get menuFilterQuick;

  /// No description provided for @menuFilterBeverages.
  ///
  /// In en, this message translates to:
  /// **'Beverages'**
  String get menuFilterBeverages;

  /// No description provided for @menuFilterDesserts.
  ///
  /// In en, this message translates to:
  /// **'Desserts'**
  String get menuFilterDesserts;

  /// No description provided for @menuFilterPromotions.
  ///
  /// In en, this message translates to:
  /// **'Promotions'**
  String get menuFilterPromotions;

  /// No description provided for @menuResultCurated.
  ///
  /// In en, this message translates to:
  /// **'{count} curated {filter} menus'**
  String menuResultCurated(int count, String filter);

  /// No description provided for @menuResultDefault.
  ///
  /// In en, this message translates to:
  /// **'Hand-picked & refreshed daily'**
  String get menuResultDefault;

  /// No description provided for @menuCategoriesCount.
  ///
  /// In en, this message translates to:
  /// **'{count} categories'**
  String menuCategoriesCount(int count);

  /// No description provided for @menuEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No menus match your filters'**
  String get menuEmptyTitle;

  /// No description provided for @menuEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try a different vibe or reset your search to browse everything again.'**
  String get menuEmptyBody;

  /// No description provided for @menuResetFilters.
  ///
  /// In en, this message translates to:
  /// **'Reset filters'**
  String get menuResetFilters;

  /// No description provided for @menuChefPick.
  ///
  /// In en, this message translates to:
  /// **'Chef pick'**
  String get menuChefPick;

  /// No description provided for @menuItemsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} items'**
  String menuItemsCount(int count);

  /// No description provided for @menuItemsSearchHint.
  ///
  /// In en, this message translates to:
  /// **'Search food'**
  String get menuItemsSearchHint;

  /// No description provided for @menuItemsEmptyTitle.
  ///
  /// In en, this message translates to:
  /// **'No items match your search'**
  String get menuItemsEmptyTitle;

  /// No description provided for @menuItemsEmptyBody.
  ///
  /// In en, this message translates to:
  /// **'Try another flavor, ingredient or chef name.'**
  String get menuItemsEmptyBody;

  /// No description provided for @deliverToLabel.
  ///
  /// In en, this message translates to:
  /// **'Delivering to'**
  String get deliverToLabel;

  /// No description provided for @changeLocation.
  ///
  /// In en, this message translates to:
  /// **'Change'**
  String get changeLocation;

  /// No description provided for @deliveryLocationTitle.
  ///
  /// In en, this message translates to:
  /// **'Delivery location'**
  String get deliveryLocationTitle;

  /// No description provided for @useCurrentLocation.
  ///
  /// In en, this message translates to:
  /// **'Use my current location'**
  String get useCurrentLocation;

  /// No description provided for @useCurrentSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ask GPS and auto-detect address'**
  String get useCurrentSubtitle;

  /// No description provided for @chooseOnMap.
  ///
  /// In en, this message translates to:
  /// **'Choose on map'**
  String get chooseOnMap;

  /// No description provided for @chooseOnMapSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Drop a pin to select the spot'**
  String get chooseOnMapSubtitle;

  /// No description provided for @deliverHere.
  ///
  /// In en, this message translates to:
  /// **'Deliver here'**
  String get deliverHere;

  /// No description provided for @deliveryLocationSheetDescription.
  ///
  /// In en, this message translates to:
  /// **'Select how you\'d like us to deliver'**
  String get deliveryLocationSheetDescription;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
