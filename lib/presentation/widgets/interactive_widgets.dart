import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/animations_v2.dart';
import 'package:food_delivery/core/utils/haptic_feedback.dart';

/// Interactive Widget with Enhanced Physical Feedback
///
/// Provides visual and haptic feedback for better user interaction.
/// Features:
/// - Scale animation on press
/// - Haptic feedback
/// - Color overlay on press
/// - Customizable interaction effects
class InteractiveWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final VoidCallback? onLongPress;
  final double pressScale;
  final Duration animationDuration;
  final bool enableHaptic;
  final bool enableScaleEffect;
  final bool enableColorOverlay;
  final Color? pressColor;
  final BorderRadius? borderRadius;

  const InteractiveWidget({
    super.key,
    required this.child,
    this.onTap,
    this.onLongPress,
    this.pressScale = 0.95,
    this.animationDuration = AnimationsV2.fast,
    this.enableHaptic = true,
    this.enableScaleEffect = true,
    this.enableColorOverlay = true,
    this.pressColor,
    this.borderRadius,
  });

  @override
  State<InteractiveWidget> createState() => _InteractiveWidgetState();
}

class _InteractiveWidgetState extends State<InteractiveWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.animationDuration,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: widget.pressScale,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AnimationsV2.emphasized,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null || widget.onLongPress != null) {
      setState(() => _isPressed = true);
      if (widget.enableScaleEffect) {
        _controller.forward();
      }
      if (widget.enableHaptic) {
        HapticFeedbackHelper.lightImpact();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      if (widget.enableScaleEffect) {
        _controller.reverse();
      }
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      if (widget.enableScaleEffect) {
        _controller.reverse();
      }
    }
  }

  void _handleTap() {
    if (widget.enableHaptic) {
      HapticFeedbackHelper.mediumImpact();
    }
    widget.onTap?.call();
  }

  void _handleLongPress() {
    if (widget.enableHaptic) {
      HapticFeedbackHelper.longPress();
    }
    widget.onLongPress?.call();
  }

  @override
  Widget build(BuildContext context) {
    Widget child = widget.child;

    // Add color overlay if enabled
    if (widget.enableColorOverlay && _isPressed) {
      child = Stack(
        children: [
          child,
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color:
                    (widget.pressColor ?? Colors.black).withValues(alpha: 0.1),
                borderRadius: widget.borderRadius,
              ),
            ),
          ),
        ],
      );
    }

    // Wrap with scale animation if enabled
    if (widget.enableScaleEffect) {
      child = ScaleTransition(
        scale: _scaleAnimation,
        child: child,
      );
    }

    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      onTap: widget.onTap != null ? _handleTap : null,
      onLongPress: widget.onLongPress != null ? _handleLongPress : null,
      behavior: HitTestBehavior.opaque,
      child: child,
    );
  }
}

/// Bouncy Button Widget
///
/// A button that bounces when pressed with haptic feedback
class BouncyButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final Duration duration;
  final double bounceScale;
  final bool enableHaptic;

  const BouncyButton({
    super.key,
    required this.child,
    this.onPressed,
    this.duration = AnimationsV2.fast,
    this.bounceScale = 1.1,
    this.enableHaptic = true,
  });

  @override
  State<BouncyButton> createState() => _BouncyButtonState();
}

class _BouncyButtonState extends State<BouncyButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.0, end: widget.bounceScale)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: widget.bounceScale, end: 1.0)
            .chain(CurveTween(curve: Curves.easeIn)),
        weight: 50,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _handleTap() async {
    if (widget.onPressed != null) {
      if (widget.enableHaptic) {
        await HapticFeedbackHelper.mediumImpact();
      }
      await _controller.forward();
      _controller.reset();
      widget.onPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: widget.child,
      ),
    );
  }
}

/// Pressable Card Widget
///
/// A card that responds to press with depth effect
class PressableCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPressed;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Color? backgroundColor;
  final bool enableHaptic;
  final double elevation;
  final double pressedElevation;

  const PressableCard({
    super.key,
    required this.child,
    this.onPressed,
    this.padding,
    this.borderRadius,
    this.backgroundColor,
    this.enableHaptic = true,
    this.elevation = 4.0,
    this.pressedElevation = 1.0,
  });

  @override
  State<PressableCard> createState() => _PressableCardState();
}

class _PressableCardState extends State<PressableCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _elevationAnimation;
  late Animation<double> _scaleAnimation;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationsV2.fast,
      vsync: this,
    );
    _elevationAnimation = Tween<double>(
      begin: widget.elevation,
      end: widget.pressedElevation,
    ).animate(_controller);
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.98,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AnimationsV2.emphasized,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null) {
      setState(() => _isPressed = true);
      _controller.forward();
      if (widget.enableHaptic) {
        HapticFeedbackHelper.lightImpact();
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
      if (widget.enableHaptic) {
        HapticFeedbackHelper.mediumImpact();
      }
      widget.onPressed?.call();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTapDown,
      onTapUp: _handleTapUp,
      onTapCancel: _handleTapCancel,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _scaleAnimation.value,
            child: Material(
              elevation: _elevationAnimation.value,
              borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
              color: widget.backgroundColor ?? Colors.white,
              child: Container(
                padding: widget.padding,
                child: widget.child,
              ),
            ),
          );
        },
      ),
    );
  }
}

/// Swipeable Item Widget
///
/// Item that can be swiped with haptic feedback
class SwipeableItem extends StatefulWidget {
  final Widget child;
  final VoidCallback? onSwipeLeft;
  final VoidCallback? onSwipeRight;
  final double swipeThreshold;
  final bool enableHaptic;

  const SwipeableItem({
    super.key,
    required this.child,
    this.onSwipeLeft,
    this.onSwipeRight,
    this.swipeThreshold = 0.4,
    this.enableHaptic = true,
  });

  @override
  State<SwipeableItem> createState() => _SwipeableItemState();
}

class _SwipeableItemState extends State<SwipeableItem>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  double _dragExtent = 0;
  bool _hapticTriggered = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationsV2.fast,
      vsync: this,
    );
    _offsetAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: Offset.zero,
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleDragUpdate(DragUpdateDetails details) {
    setState(() {
      _dragExtent += details.primaryDelta ?? 0;

      // Trigger haptic when crossing threshold
      final threshold = context.size!.width * widget.swipeThreshold;
      if (!_hapticTriggered && _dragExtent.abs() > threshold) {
        if (widget.enableHaptic) {
          HapticFeedbackHelper.selectionClick();
        }
        _hapticTriggered = true;
      }
    });
  }

  void _handleDragEnd(DragEndDetails details) {
    final threshold = context.size!.width * widget.swipeThreshold;

    if (_dragExtent > threshold && widget.onSwipeRight != null) {
      if (widget.enableHaptic) {
        HapticFeedbackHelper.success();
      }
      widget.onSwipeRight?.call();
    } else if (_dragExtent < -threshold && widget.onSwipeLeft != null) {
      if (widget.enableHaptic) {
        HapticFeedbackHelper.success();
      }
      widget.onSwipeLeft?.call();
    }

    setState(() {
      _dragExtent = 0;
      _hapticTriggered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: _handleDragUpdate,
      onHorizontalDragEnd: _handleDragEnd,
      child: Transform.translate(
        offset: Offset(_dragExtent, 0),
        child: widget.child,
      ),
    );
  }
}
