// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'FoodEx';

  @override
  String get loginHeroTitle => 'Connectez-vous à FoodEx';

  @override
  String get loginHeroSubtitle =>
      'Des repas faits maison livrés directement chez vous.';

  @override
  String get roleCustomer => 'Client';

  @override
  String get roleCustomerCaption => 'Découvrez les repas des chefs locaux';

  @override
  String get roleChef => 'Chef';

  @override
  String get roleChefCaption => 'Gérez commandes et menus';

  @override
  String get roleDriver => 'Livreur';

  @override
  String get roleDriverCaption => 'Suivez vos livraisons';

  @override
  String loginWelcomeBack(String role) {
    return 'Bon retour parmi nous, $role';
  }

  @override
  String get loginFormSubtitle =>
      'Connectez-vous pour continuer à commander et suivre vos repas.';

  @override
  String get emailLabel => 'Adresse e-mail';

  @override
  String get emailHint => 'chef@foodex.com';

  @override
  String get errorEmailRequired => 'Saisissez votre adresse e-mail';

  @override
  String get errorEmailInvalid => 'Entrez un e-mail valide';

  @override
  String get passwordLabel => 'Mot de passe';

  @override
  String get passwordHint => '••••••••';

  @override
  String get errorPasswordLength =>
      'Le mot de passe doit contenir au moins 6 caractères';

  @override
  String get rememberMe => 'Se souvenir de moi';

  @override
  String get forgotPassword => 'Mot de passe oublié ?';

  @override
  String get actionLogin => 'Se connecter';

  @override
  String get orContinueWith => 'ou continuer avec';

  @override
  String get continueWithGoogle => 'Continuer avec Google';

  @override
  String get continueWithFacebook => 'Continuer avec Facebook';

  @override
  String get loginFooterPrompt => 'Nouveau sur FoodEx ?';

  @override
  String get actionCreateAccount => 'Créer un compte';

  @override
  String get signupTitle => 'Créer un compte FoodEx';

  @override
  String get signupSubtitle =>
      'Renseignez vos informations pour commander ou vendre vos plats.';

  @override
  String get fullNameLabel => 'Nom complet';

  @override
  String get fullNameHint => 'ex. Sara Amrani';

  @override
  String get errorNameRequired => 'Veuillez saisir votre nom';

  @override
  String get mobileLabel => 'Numéro de téléphone';

  @override
  String get mobileHint => '+212 6 00 00 00 00';

  @override
  String get errorMobileRequired => 'Entrez votre numéro de téléphone';

  @override
  String get errorMobileLength => 'Le numéro semble trop court';

  @override
  String get addressLabel => 'Adresse principale';

  @override
  String get addressHint => 'Appartement, rue, ville';

  @override
  String get errorAddressRequired => 'Entrez votre adresse de livraison';

  @override
  String get confirmPasswordLabel => 'Confirmez le mot de passe';

  @override
  String get confirmPasswordHint => 'Répétez le mot de passe';

  @override
  String get errorConfirmPasswordRequired => 'Confirmez votre mot de passe';

  @override
  String get errorPasswordMismatch => 'Les mots de passe ne correspondent pas';

  @override
  String get termsAgreementPrefix => 'J\'accepte ';

  @override
  String get termsPolicyLink =>
      'les Conditions et la Politique de confidentialité';

  @override
  String get errorAcceptTerms =>
      'Veuillez accepter les Conditions et la Politique de confidentialité';

  @override
  String get signupAlreadyPrompt => 'Vous avez déjà un compte ?';

  @override
  String get menuTitle => 'Menu';

  @override
  String get menuSubtitle =>
      'Parcourez les catégories créées par nos chefs locaux';

  @override
  String get menuSearchHint => 'Rechercher un plat, un chef ou une ambiance';

  @override
  String get menuFilterAll => 'Tous';

  @override
  String get menuFilterMeals => 'Plats';

  @override
  String get menuFilterFamily => 'Familial';

  @override
  String get menuFilterQuick => 'Snacks';

  @override
  String get menuFilterBeverages => 'Boissons';

  @override
  String get menuFilterDesserts => 'Desserts';

  @override
  String get menuFilterPromotions => 'Promotions';

  @override
  String menuResultCurated(int count, String filter) {
    return '$count menus $filter recommandés';
  }

  @override
  String get menuResultDefault => 'Sélection mise à jour chaque jour';

  @override
  String menuCategoriesCount(int count) {
    return '$count catégories';
  }

  @override
  String get menuEmptyTitle => 'Aucun menu ne correspond à vos filtres';

  @override
  String get menuEmptyBody =>
      'Essayez une autre ambiance ou réinitialisez votre recherche.';

  @override
  String get menuResetFilters => 'Réinitialiser';

  @override
  String get menuChefPick => 'Choix du chef';

  @override
  String menuItemsCount(int count) {
    return '$count articles';
  }

  @override
  String get menuItemsSearchHint => 'Rechercher un plat';

  @override
  String get menuItemsEmptyTitle => 'Aucun résultat pour votre recherche';

  @override
  String get menuItemsEmptyBody => 'Essayez un autre ingrédient, goût ou chef.';

  @override
  String get deliverToLabel => 'Livraison à';

  @override
  String get changeLocation => 'Changer';

  @override
  String get deliveryLocationTitle => 'Adresse de livraison';

  @override
  String get useCurrentLocation => 'Utiliser ma position actuelle';

  @override
  String get useCurrentSubtitle => 'Demander le GPS et détecter l\'adresse';

  @override
  String get chooseOnMap => 'Choisir sur la carte';

  @override
  String get chooseOnMapSubtitle =>
      'Placez un repère pour sélectionner l\'endroit';

  @override
  String get deliverHere => 'Livrer ici';

  @override
  String get deliveryLocationSheetDescription =>
      'Sélectionnez comment nous livrer';
}
