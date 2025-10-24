import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';

/// Professional Haptic Feedback System
///
/// Provides contextual haptic feedback for better physical interaction.
/// Uses platform-specific haptics on iOS and Android.
class HapticFeedbackHelper {
  /// Light impact - For switches, toggles, small UI elements
  static Future<void> lightImpact() async {
    if (kIsWeb) return;
    try {
      await HapticFeedback.lightImpact();
    } catch (e) {
      debugPrint('Haptic feedback not available: $e');
    }
  }

  /// Medium impact - For buttons, selections
  static Future<void> mediumImpact() async {
    if (kIsWeb) return;
    try {
      await HapticFeedback.mediumImpact();
    } catch (e) {
      debugPrint('Haptic feedback not available: $e');
    }
  }

  /// Heavy impact - For important actions, confirmations
  static Future<void> heavyImpact() async {
    if (kIsWeb) return;
    try {
      await HapticFeedback.heavyImpact();
    } catch (e) {
      debugPrint('Haptic feedback not available: $e');
    }
  }

  /// Selection click - For picker scrolling, list selection
  static Future<void> selectionClick() async {
    if (kIsWeb) return;
    try {
      await HapticFeedback.selectionClick();
    } catch (e) {
      debugPrint('Haptic feedback not available: $e');
    }
  }

  /// Vibrate - For notifications, errors
  static Future<void> vibrate() async {
    if (kIsWeb) return;
    try {
      await HapticFeedback.vibrate();
    } catch (e) {
      debugPrint('Haptic feedback not available: $e');
    }
  }

  /// Success feedback - For successful operations
  static Future<void> success() async {
    await mediumImpact();
    await Future.delayed(const Duration(milliseconds: 50));
    await lightImpact();
  }

  /// Error feedback - For errors and failures
  static Future<void> error() async {
    await heavyImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await mediumImpact();
    await Future.delayed(const Duration(milliseconds: 100));
    await heavyImpact();
  }

  /// Warning feedback - For warnings and cautions
  static Future<void> warning() async {
    await mediumImpact();
    await Future.delayed(const Duration(milliseconds: 80));
    await mediumImpact();
  }

  /// Delete feedback - For destructive actions
  static Future<void> delete() async {
    await heavyImpact();
  }

  /// Add feedback - For adding items
  static Future<void> add() async {
    await lightImpact();
  }

  /// Swipe feedback - For swipe gestures
  static Future<void> swipe() async {
    await selectionClick();
  }

  /// Long press feedback - For long press gestures
  static Future<void> longPress() async {
    await mediumImpact();
  }

  /// Pull to refresh feedback - For pull to refresh
  static Future<void> pullToRefresh() async {
    await mediumImpact();
  }
}
