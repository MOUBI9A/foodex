import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/animations_v2.dart';

/// Professional Page Transitions
///
/// Custom page route transitions for smooth navigation

/// Fade Page Transition
class FadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;

  FadePageRoute({
    required this.page,
    this.duration = AnimationsV2.normal,
    this.curve = AnimationsV2.emphasizedDecelerate,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: curve,
              ),
              child: child,
            );
          },
        );
}

/// Scale and Fade Page Transition
class ScaleFadePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;

  ScaleFadePageRoute({
    required this.page,
    this.duration = AnimationsV2.normal,
    this.curve = AnimationsV2.emphasizedDecelerate,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return ScaleTransition(
              scale:
                  Tween<double>(begin: 0.8, end: 1.0).animate(curvedAnimation),
              child: FadeTransition(
                opacity: curvedAnimation,
                child: child,
              ),
            );
          },
        );
}

/// Slide Page Transition (from right)
class SlidePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;
  final Offset begin;

  SlidePageRoute({
    required this.page,
    this.duration = AnimationsV2.normal,
    this.curve = AnimationsV2.emphasizedDecelerate,
    this.begin = const Offset(1.0, 0.0), // Slide from right
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: begin,
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: curve,
              )),
              child: child,
            );
          },
        );
}

/// Rotation Page Transition
class RotationPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;

  RotationPageRoute({
    required this.page,
    this.duration = AnimationsV2.slow,
    this.curve = AnimationsV2.emphasized,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return RotationTransition(
              turns: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                  CurvedAnimation(
                    parent: animation,
                    curve: curve,
                  ),
                ),
                child: child,
              ),
            );
          },
        );
}

/// Shared Axis Page Transition (Material Design)
class SharedAxisPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;
  final SharedAxisTransitionType transitionType;

  SharedAxisPageRoute({
    required this.page,
    this.duration = AnimationsV2.normal,
    this.curve = AnimationsV2.emphasizedDecelerate,
    this.transitionType = SharedAxisTransitionType.horizontal,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            final curvedSecondaryAnimation = CurvedAnimation(
              parent: secondaryAnimation,
              curve: curve,
            );

            Offset getBeginOffset() {
              switch (transitionType) {
                case SharedAxisTransitionType.horizontal:
                  return const Offset(0.3, 0.0);
                case SharedAxisTransitionType.vertical:
                  return const Offset(0.0, 0.3);
                case SharedAxisTransitionType.scaled:
                  return Offset.zero;
              }
            }

            Offset getExitOffset() {
              switch (transitionType) {
                case SharedAxisTransitionType.horizontal:
                  return const Offset(-0.3, 0.0);
                case SharedAxisTransitionType.vertical:
                  return const Offset(0.0, -0.3);
                case SharedAxisTransitionType.scaled:
                  return Offset.zero;
              }
            }

            return Stack(
              children: [
                // Exit animation (old page)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: getExitOffset(),
                  ).animate(curvedSecondaryAnimation),
                  child: FadeTransition(
                    opacity: Tween<double>(begin: 1.0, end: 0.0)
                        .animate(curvedSecondaryAnimation),
                    child: Container(), // Old page fades out
                  ),
                ),
                // Enter animation (new page)
                SlideTransition(
                  position: Tween<Offset>(
                    begin: getBeginOffset(),
                    end: Offset.zero,
                  ).animate(curvedAnimation),
                  child: FadeTransition(
                    opacity: curvedAnimation,
                    child: child,
                  ),
                ),
              ],
            );
          },
        );
}

enum SharedAxisTransitionType {
  horizontal,
  vertical,
  scaled,
}

/// Fade Through Page Transition (Material Design)
class FadeThroughPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;

  FadeThroughPageRoute({
    required this.page,
    this.duration = AnimationsV2.normal,
    this.curve = AnimationsV2.emphasized,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Interval(0.4, 1.0, curve: curve),
                ),
              ),
              child: FadeTransition(
                opacity: Tween<double>(begin: 1.0, end: 0.0).animate(
                  CurvedAnimation(
                    parent: secondaryAnimation,
                    curve: Interval(0.0, 0.6, curve: curve),
                  ),
                ),
                child: child,
              ),
            );
          },
        );
}

/// Zoom Page Transition
class ZoomPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;

  ZoomPageRoute({
    required this.page,
    this.duration = AnimationsV2.normal,
    this.curve = AnimationsV2.overshoot,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: curve,
                ),
              ),
              child: child,
            );
          },
        );
}

/// Flip Page Transition
class FlipPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;
  final Axis direction;

  FlipPageRoute({
    required this.page,
    this.duration = AnimationsV2.slow,
    this.curve = AnimationsV2.emphasized,
    this.direction = Axis.horizontal,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return AnimatedBuilder(
              animation: curvedAnimation,
              builder: (context, child) {
                final angle = curvedAnimation.value * 3.14159; // π radians
                return Transform(
                  transform: direction == Axis.horizontal
                      ? (Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateY(angle))
                      : (Matrix4.identity()
                        ..setEntry(3, 2, 0.001)
                        ..rotateX(angle)),
                  alignment: Alignment.center,
                  child: child,
                );
              },
              child: child,
            );
          },
        );
}

/// Custom Door Transition (opens like a door)
class DoorPageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;

  DoorPageRoute({
    required this.page,
    this.duration = AnimationsV2.slow,
    this.curve = AnimationsV2.emphasized,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return AnimatedBuilder(
              animation: curvedAnimation,
              builder: (context, child) {
                final angle =
                    (1 - curvedAnimation.value) * 1.5708; // 90 degrees
                return Transform(
                  transform: Matrix4.identity()
                    ..setEntry(3, 2, 0.001)
                    ..rotateY(angle),
                  alignment: Alignment.centerLeft,
                  child: child,
                );
              },
              child: child,
            );
          },
        );
}

/// Bounce Page Transition
class BouncePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;

  BouncePageRoute({
    required this.page,
    this.duration = AnimationsV2.mediumSlow,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: AnimationsV2.bouncy,
                ),
              ),
              child: child,
            );
          },
        );
}

/// Slide and Scale Page Transition
class SlideScalePageRoute<T> extends PageRouteBuilder<T> {
  final Widget page;
  final Duration duration;
  final Curve curve;

  SlideScalePageRoute({
    required this.page,
    this.duration = AnimationsV2.normal,
    this.curve = AnimationsV2.emphasizedDecelerate,
  }) : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: duration,
          reverseTransitionDuration: duration,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curvedAnimation = CurvedAnimation(
              parent: animation,
              curve: curve,
            );

            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(curvedAnimation),
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.8, end: 1.0)
                    .animate(curvedAnimation),
                child: child,
              ),
            );
          },
        );
}

/// Extension for easy navigation with custom transitions
extension NavigationExtensions on BuildContext {
  /// Navigate with fade transition
  Future<T?> pushFade<T>(Widget page) {
    return Navigator.of(this).push<T>(FadePageRoute(page: page));
  }

  /// Navigate with slide transition
  Future<T?> pushSlide<T>(Widget page, {Offset? begin}) {
    return Navigator.of(this).push<T>(
      SlidePageRoute(page: page, begin: begin ?? const Offset(1.0, 0.0)),
    );
  }

  /// Navigate with zoom transition
  Future<T?> pushZoom<T>(Widget page) {
    return Navigator.of(this).push<T>(ZoomPageRoute(page: page));
  }

  /// Navigate with scale fade transition
  Future<T?> pushScaleFade<T>(Widget page) {
    return Navigator.of(this).push<T>(ScaleFadePageRoute(page: page));
  }

  /// Navigate with bounce transition
  Future<T?> pushBounce<T>(Widget page) {
    return Navigator.of(this).push<T>(BouncePageRoute(page: page));
  }

  /// Navigate with shared axis transition
  Future<T?> pushSharedAxis<T>(
    Widget page, {
    SharedAxisTransitionType type = SharedAxisTransitionType.horizontal,
  }) {
    return Navigator.of(this).push<T>(
      SharedAxisPageRoute(page: page, transitionType: type),
    );
  }
}
