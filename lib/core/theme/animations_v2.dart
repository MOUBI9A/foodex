import 'package:flutter/material.dart';
import 'dart:math' as math;

/// FoodEx Animation System V2
///
/// Professional animation durations, curves, and utilities
/// following Material Design 3 motion principles.
class AnimationsV2 {
  // === DURATION STANDARDS ===
  /// 100ms - Instant feedback
  static const Duration instant = Duration(milliseconds: 100);

  /// 200ms - Fast transitions
  static const Duration fast = Duration(milliseconds: 200);

  /// 250ms - Quick transitions
  static const Duration quick = Duration(milliseconds: 250);

  /// 300ms - Normal transitions (default)
  static const Duration normal = Duration(milliseconds: 300);

  /// 400ms - Slow transitions
  static const Duration slow = Duration(milliseconds: 400);

  /// 500ms - Medium slow transitions
  static const Duration mediumSlow = Duration(milliseconds: 500);

  /// 600ms - Very slow transitions
  static const Duration slower = Duration(milliseconds: 600);

  /// 800ms - Extended transitions
  static const Duration extended = Duration(milliseconds: 800);

  /// 1000ms - Dramatic transitions
  static const Duration dramatic = Duration(milliseconds: 1000);

  /// 1500ms - Very dramatic transitions
  static const Duration veryDramatic = Duration(milliseconds: 1500);

  /// 2000ms - Ultra dramatic transitions
  static const Duration ultraDramatic = Duration(milliseconds: 2000);

  // === MATERIAL DESIGN 3 CURVES ===
  /// Emphasized curve - Most expressive
  static const Curve emphasized = Cubic(0.4, 0.0, 0.2, 1.0);

  /// Emphasized decelerate - Enter animations
  static const Curve emphasizedDecelerate = Cubic(0.05, 0.7, 0.1, 1.0);

  /// Emphasized accelerate - Exit animations
  static const Curve emphasizedAccelerate = Cubic(0.3, 0.0, 0.8, 0.15);

  // === STANDARD CURVES ===
  /// Standard decelerate - Subtle enter
  static const Curve standardDecelerate = Curves.easeOut;

  /// Standard accelerate - Subtle exit
  static const Curve standardAccelerate = Curves.easeIn;

  /// Standard curve - Balanced
  static const Curve standard = Curves.easeInOut;

  // === PLAYFUL CURVES (Use Sparingly) ===
  /// Bouncy curve - Playful interactions
  static const Curve bouncy = Curves.elasticOut;

  /// Spring curve - Natural bounce
  static const Curve spring = Cubic(0.5, 1.5, 0.5, 1.0);

  /// Smooth spring - Gentle bounce
  static const Curve smoothSpring = Cubic(0.4, 1.2, 0.6, 1.0);

  /// Overshoot - Slight overshoot effect
  static const Curve overshoot = Cubic(0.175, 0.885, 0.32, 1.275);

  /// Back curve - Pull back then forward
  static const Curve back = Cubic(0.6, -0.28, 0.735, 0.045);

  // === COMPONENT-SPECIFIC DURATIONS ===
  /// Button press animation
  static const Duration buttonPress = fast; // 200ms

  /// Card hover animation
  static const Duration cardHover = quick; // 250ms

  /// Dialog appear animation
  static const Duration dialog = normal; // 300ms

  /// Bottom sheet slide animation
  static const Duration bottomSheet = slow; // 400ms

  /// Page transition animation
  static const Duration pageTransition = normal; // 300ms

  /// Snackbar animation
  static const Duration snackbar = fast; // 200ms

  /// Shimmer loading animation
  static const Duration shimmer = dramatic; // 1000ms

  /// Ripple effect animation
  static const Duration ripple = mediumSlow; // 500ms

  /// Fade animation
  static const Duration fade = normal; // 300ms

  /// Scale animation
  static const Duration scale = fast; // 200ms

  /// Slide animation
  static const Duration slide = normal; // 300ms

  /// Rotation animation
  static const Duration rotation = slow; // 400ms

  // === HERO ANIMATION ===
  /// Hero transition duration
  static const Duration hero = normal; // 300ms

  // === STAGGER DELAYS ===
  /// Small stagger delay
  static const Duration staggerSmall = Duration(milliseconds: 50);

  /// Medium stagger delay
  static const Duration staggerMedium = Duration(milliseconds: 100);

  /// Large stagger delay
  static const Duration staggerLarge = Duration(milliseconds: 150);

  // === HELPER METHODS ===

  /// Create a delayed animation
  static Future<void> delay(Duration duration) {
    return Future.delayed(duration);
  }

  /// Create a staggered animation delay
  static Duration staggerDelay(int index, {Duration baseDelay = fast}) {
    return Duration(milliseconds: baseDelay.inMilliseconds * index);
  }

  /// Get interpolated value between two values
  static double interpolate(double start, double end, double progress) {
    return start + (end - start) * progress;
  }

  /// Get wave animation value
  static double wave(double progress, {int waves = 1}) {
    return (1 - math.cos(progress * waves * math.pi)) / 2;
  }
}

/// Animation Controller Extensions
extension AnimationControllerX on AnimationController {
  /// Animate forward with custom curve
  TickerFuture forwardWithCurve(Curve curve) {
    return forward();
  }

  /// Animate reverse with custom curve
  TickerFuture reverseWithCurve(Curve curve) {
    return reverse();
  }

  /// Toggle animation direction
  TickerFuture toggle() {
    if (status == AnimationStatus.completed) {
      return reverse();
    } else {
      return forward();
    }
  }

  /// Pulse animation (forward then reverse)
  Future<void> pulse() async {
    await forward();
    await reverse();
  }

  /// Loop animation
  void loop() {
    addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        reverse();
      } else if (status == AnimationStatus.dismissed) {
        forward();
      }
    });
    forward();
  }
}

/// Tween Extensions
extension TweenX<T> on Tween<T> {
  /// Animate tween with curve
  Animation<T> animateWithCurve(
    Animation<double> parent,
    Curve curve,
  ) {
    return animate(CurvedAnimation(
      parent: parent,
      curve: curve,
    ));
  }
}
