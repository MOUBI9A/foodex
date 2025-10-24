/// FoodEx Enhanced Design Tokens V2
///
/// Systematic spacing, sizing, and layout constants
/// following 8-point grid system for consistency.

class SpacingV2 {
  // === BASE UNIT (8px) ===
  static const double unit = 8.0;

  // === SPACING SCALE ===
  /// 2px - Minimal spacing
  static const double xxxs = 2.0;

  /// 4px - Very small spacing
  static const double xxs = 4.0;

  /// 8px - Small spacing
  static const double xs = 8.0;

  /// 12px - Medium-small spacing
  static const double sm = 12.0;

  /// 16px - Standard spacing
  static const double md = 16.0;

  /// 24px - Large spacing
  static const double lg = 24.0;

  /// 32px - Extra large spacing
  static const double xl = 32.0;

  /// 48px - Double extra large spacing
  static const double xxl = 48.0;

  /// 64px - Triple extra large spacing
  static const double xxxl = 64.0;

  // === COMPONENT-SPECIFIC SPACING ===
  /// Standard padding for buttons
  static const double buttonPadding = md; // 16px

  /// Standard padding for cards
  static const double cardPadding = lg; // 24px

  /// Spacing between major sections
  static const double sectionSpacing = xl; // 32px

  /// Standard screen padding
  static const double screenPadding = lg; // 24px

  /// Spacing between icon and text
  static const double iconToText = sm; // 12px

  /// Spacing between list items
  static const double listItemSpacing = md; // 16px

  /// Spacing between form fields
  static const double formFieldSpacing = lg; // 24px

  /// Spacing for bottom navigation
  static const double bottomNavPadding = xs; // 8px
}

class RadiusV2 {
  // === BORDER RADIUS SCALE ===
  /// 0px - No rounding
  static const double none = 0.0;

  /// 4px - Subtle corners
  static const double xs = 4.0;

  /// 8px - Small elements (chips, tags)
  static const double sm = 8.0;

  /// 12px - Standard buttons and inputs
  static const double md = 12.0;

  /// 16px - Cards and containers
  static const double lg = 16.0;

  /// 20px - Large cards
  static const double xl = 20.0;

  /// 28px - Rounded buttons (pill shape)
  static const double xxl = 28.0;

  /// 9999px - Full circle/pill
  static const double full = 9999.0;

  // === COMPONENT-SPECIFIC RADIUS ===
  /// Border radius for buttons (pill shape)
  static const double button = xxl; // 28px

  /// Border radius for cards
  static const double card = lg; // 16px

  /// Border radius for input fields
  static const double input = md; // 12px

  /// Border radius for dialogs
  static const double dialog = xl; // 20px

  /// Border radius for bottom sheets
  static const double bottomSheet = xl; // 20px

  /// Border radius for chips/tags
  static const double chip = sm; // 8px

  /// Border radius for avatars (full circle)
  static const double avatar = full;
}

class SizingV2 {
  // === ICON SIZES ===
  /// 16px - Small icons
  static const double iconXs = 16.0;

  /// 20px - Standard icons
  static const double iconSm = 20.0;

  /// 24px - Medium icons
  static const double iconMd = 24.0;

  /// 32px - Large icons
  static const double iconLg = 32.0;

  /// 48px - Extra large icons
  static const double iconXl = 48.0;

  // === BUTTON HEIGHTS ===
  /// 36px - Small button
  static const double buttonSm = 36.0;

  /// 44px - Medium button (iOS minimum touch target)
  static const double buttonMd = 44.0;

  /// 56px - Large button (standard)
  static const double buttonLg = 56.0;

  // === INPUT HEIGHTS ===
  /// 40px - Small input
  static const double inputSm = 40.0;

  /// 48px - Medium input (Android minimum)
  static const double inputMd = 48.0;

  /// 56px - Large input
  static const double inputLg = 56.0;

  // === AVATAR SIZES ===
  /// 24px - Tiny avatar
  static const double avatarXs = 24.0;

  /// 32px - Small avatar
  static const double avatarSm = 32.0;

  /// 48px - Medium avatar
  static const double avatarMd = 48.0;

  /// 64px - Large avatar
  static const double avatarLg = 64.0;

  /// 96px - Extra large avatar
  static const double avatarXl = 96.0;

  // === MINIMUM TOUCH TARGETS ===
  /// 44px - iOS minimum touch target
  static const double minTouchIOS = 44.0;

  /// 48px - Android minimum touch target
  static const double minTouchAndroid = 48.0;

  // === CARD DIMENSIONS ===
  /// Standard card height
  static const double cardHeight = 120.0;

  /// Large card height
  static const double cardHeightLg = 180.0;

  /// Banner height
  static const double bannerHeight = 200.0;
}

class ElevationV2 {
  // === ELEVATION LEVELS ===
  /// 0dp - No elevation
  static const double level0 = 0.0;

  /// 1dp - Subtle elevation
  static const double level1 = 1.0;

  /// 2dp - Cards resting
  static const double level2 = 2.0;

  /// 4dp - Cards raised
  static const double level3 = 4.0;

  /// 8dp - Dropdowns, pickers
  static const double level4 = 8.0;

  /// 16dp - Navigation drawer
  static const double level5 = 16.0;

  /// 24dp - Dialog, modal
  static const double level6 = 24.0;
}

class OpacityV2 {
  // === OPACITY SCALE ===
  /// 0% - Fully transparent
  static const double transparent = 0.0;

  /// 5% - Barely visible
  static const double xxs = 0.05;

  /// 10% - Very subtle
  static const double xs = 0.10;

  /// 20% - Subtle
  static const double sm = 0.20;

  /// 40% - Medium
  static const double md = 0.40;

  /// 60% - High
  static const double lg = 0.60;

  /// 80% - Very high
  static const double xl = 0.80;

  /// 100% - Fully opaque
  static const double opaque = 1.0;

  // === COMMON USES ===
  /// Disabled state
  static const double disabled = md; // 40%

  /// Overlay backgrounds
  static const double overlay = lg; // 60%

  /// Hover state
  static const double hover = xs; // 10%

  /// Pressed state
  static const double pressed = sm; // 20%
}

class TypographyScaleV2 {
  // === FONT SIZES ===
  /// 10px - Overline, captions
  static const double xs = 10.0;

  /// 12px - Small text, labels
  static const double sm = 12.0;

  /// 14px - Body text
  static const double md = 14.0;

  /// 16px - Large body, buttons
  static const double lg = 16.0;

  /// 18px - Subheadings
  static const double xl = 18.0;

  /// 20px - Headings
  static const double xxl = 20.0;

  /// 24px - Large headings
  static const double xxxl = 24.0;

  /// 28px - Display text
  static const double display1 = 28.0;

  /// 32px - Large display
  static const double display2 = 32.0;

  /// 40px - Extra large display
  static const double display3 = 40.0;

  // === LINE HEIGHTS ===
  /// 1.2 - Tight line height
  static const double lineHeightTight = 1.2;

  /// 1.4 - Normal line height
  static const double lineHeightNormal = 1.4;

  /// 1.6 - Relaxed line height
  static const double lineHeightRelaxed = 1.6;

  /// 2.0 - Loose line height
  static const double lineHeightLoose = 2.0;

  // === LETTER SPACING ===
  /// -0.5px - Tight letter spacing
  static const double letterSpacingTight = -0.5;

  /// 0px - Normal letter spacing
  static const double letterSpacingNormal = 0.0;

  /// 0.5px - Wide letter spacing
  static const double letterSpacingWide = 0.5;

  /// 1.5px - Extra wide (for uppercase)
  static const double letterSpacingExtraWide = 1.5;
}
