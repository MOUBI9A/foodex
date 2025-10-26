// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'فود إكس';

  @override
  String get loginHeroTitle => 'سجّل الدخول إلى فود إكس';

  @override
  String get loginHeroSubtitle => 'وجبات منزلية طازجة تصل إلى بابك.';

  @override
  String get roleCustomer => 'عميل';

  @override
  String get roleCustomerCaption => 'اكتشف وجبات الطهاة المحليين';

  @override
  String get roleChef => 'طاهٍ';

  @override
  String get roleChefCaption => 'أدر الطلبات وقوائم الطعام';

  @override
  String get roleDriver => 'سائق توصيل';

  @override
  String get roleDriverCaption => 'تتبع رحلات التوصيل';

  @override
  String loginWelcomeBack(String role) {
    return 'مرحباً بعودتك يا $role';
  }

  @override
  String get loginFormSubtitle => 'سجّل الدخول لمتابعة الطلبات وتتبع الشحنات.';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get emailHint => 'chef@foodex.com';

  @override
  String get errorEmailRequired => 'أدخل بريدك الإلكتروني';

  @override
  String get errorEmailInvalid => 'البريد الإلكتروني غير صالح';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get passwordHint => '••••••••';

  @override
  String get errorPasswordLength =>
      'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get actionLogin => 'تسجيل الدخول';

  @override
  String get orContinueWith => 'أو المتابعة عبر';

  @override
  String get continueWithGoogle => 'المتابعة عبر جوجل';

  @override
  String get continueWithFacebook => 'المتابعة عبر فيسبوك';

  @override
  String get loginFooterPrompt => 'جديد في فود إكس؟';

  @override
  String get actionCreateAccount => 'إنشاء حساب';

  @override
  String get signupTitle => 'إنشاء حساب فود إكس';

  @override
  String get signupSubtitle => 'املأ بياناتك لبدء الطلب أو بيع وجباتك.';

  @override
  String get fullNameLabel => 'الاسم الكامل';

  @override
  String get fullNameHint => 'مثال: سارة العمراني';

  @override
  String get errorNameRequired => 'الرجاء إدخال الاسم';

  @override
  String get mobileLabel => 'رقم الهاتف';

  @override
  String get mobileHint => '+212 6 00 00 00 00';

  @override
  String get errorMobileRequired => 'أدخل رقم هاتفك';

  @override
  String get errorMobileLength => 'رقم الهاتف قصير جداً';

  @override
  String get addressLabel => 'العنوان الرئيسي';

  @override
  String get addressHint => 'شقة، شارع، مدينة';

  @override
  String get errorAddressRequired => 'أدخل عنوان التوصيل';

  @override
  String get confirmPasswordLabel => 'تأكيد كلمة المرور';

  @override
  String get confirmPasswordHint => 'أعد كتابة كلمة المرور';

  @override
  String get errorConfirmPasswordRequired => 'أكّد كلمة المرور';

  @override
  String get errorPasswordMismatch => 'كلمتا المرور غير متطابقتين';

  @override
  String get termsAgreementPrefix => 'أوافق على ';

  @override
  String get termsPolicyLink => 'الشروط وسياسة الخصوصية';

  @override
  String get errorAcceptTerms => 'يرجى قبول الشروط وسياسة الخصوصية';

  @override
  String get signupAlreadyPrompt => 'لديك حساب بالفعل؟';

  @override
  String get menuTitle => 'القائمة';

  @override
  String get menuSubtitle => 'استكشف الفئات المختارة من طهاتنا المحليين';

  @override
  String get menuSearchHint => 'ابحث عن طبق أو طاهٍ أو مزاج';

  @override
  String get menuFilterAll => 'الكل';

  @override
  String get menuFilterMeals => 'وجبات';

  @override
  String get menuFilterFamily => 'عائلي';

  @override
  String get menuFilterQuick => 'سناكس';

  @override
  String get menuFilterBeverages => 'مشروبات';

  @override
  String get menuFilterDesserts => 'حلويات';

  @override
  String get menuFilterPromotions => 'عروض';

  @override
  String menuResultCurated(int count, String filter) {
    return '$count قوائم $filter مختارة';
  }

  @override
  String get menuResultDefault => 'اختيارات متجددة يومياً';

  @override
  String menuCategoriesCount(int count) {
    return '$count فئات';
  }

  @override
  String get menuEmptyTitle => 'لا توجد قوائم مطابقة للمرشحات';

  @override
  String get menuEmptyBody =>
      'جرّب مزاجاً مختلفاً أو أعد التعيين للعرض من جديد.';

  @override
  String get menuResetFilters => 'إعادة التعيين';

  @override
  String get menuChefPick => 'اختيار الطاهي';

  @override
  String menuItemsCount(int count) {
    return '$count أصناف';
  }

  @override
  String get menuItemsSearchHint => 'ابحث عن وجبة';

  @override
  String get menuItemsEmptyTitle => 'لا توجد أصناف مطابقة';

  @override
  String get menuItemsEmptyBody => 'جرّب نكهة أو مكوناً أو طاهياً آخر.';

  @override
  String get deliverToLabel => 'التوصيل إلى';

  @override
  String get changeLocation => 'تغيير';

  @override
  String get deliveryLocationTitle => 'موقع التوصيل';

  @override
  String get useCurrentLocation => 'استخدام موقعي الحالي';

  @override
  String get useCurrentSubtitle => 'الحصول على الإحداثيات والعنوان تلقائيًا';

  @override
  String get chooseOnMap => 'اختيار من الخريطة';

  @override
  String get chooseOnMapSubtitle => 'ضع دبوسًا لتحديد المكان';

  @override
  String get deliverHere => 'التوصيل هنا';

  @override
  String get deliveryLocationSheetDescription =>
      'اختر طريقة تحديد موقع التوصيل';
}
