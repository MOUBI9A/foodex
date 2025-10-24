import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/animations_v2.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'dart:math' as math;

/// Fade In Animation Widget
///
/// Fades in a child widget with customizable duration and curve
class FadeInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final bool autoPlay;

  const FadeInAnimation({
    super.key,
    required this.child,
    this.duration = AnimationsV2.normal,
    this.delay = Duration.zero,
    this.curve = AnimationsV2.emphasizedDecelerate,
    this.autoPlay = true,
  });

  @override
  State<FadeInAnimation> createState() => _FadeInAnimationState();
}

class _FadeInAnimationState extends State<FadeInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    if (widget.autoPlay) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _animation,
      child: widget.child,
    );
  }
}

/// Scale In Animation Widget
///
/// Scales in a child widget with customizable duration and curve
class ScaleInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double begin;
  final double end;
  final bool autoPlay;

  const ScaleInAnimation({
    super.key,
    required this.child,
    this.duration = AnimationsV2.fast,
    this.delay = Duration.zero,
    this.curve = AnimationsV2.overshoot,
    this.begin = 0.0,
    this.end = 1.0,
    this.autoPlay = true,
  });

  @override
  State<ScaleInAnimation> createState() => _ScaleInAnimationState();
}

class _ScaleInAnimationState extends State<ScaleInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    if (widget.autoPlay) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// Slide In Animation Widget
///
/// Slides in a child widget from a specified direction
class SlideInAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final Offset begin;
  final Offset end;
  final bool autoPlay;

  const SlideInAnimation({
    super.key,
    required this.child,
    this.duration = AnimationsV2.normal,
    this.delay = Duration.zero,
    this.curve = AnimationsV2.emphasizedDecelerate,
    this.begin = const Offset(0.0, 1.0), // Slide from bottom
    this.end = Offset.zero,
    this.autoPlay = true,
  });

  @override
  State<SlideInAnimation> createState() => _SlideInAnimationState();
}

class _SlideInAnimationState extends State<SlideInAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<Offset>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    if (widget.autoPlay) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          _controller.forward();
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: widget.child,
    );
  }
}

/// Rotate Animation Widget
///
/// Rotates a child widget with customizable duration and curve
class RotateAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final Curve curve;
  final double begin;
  final double end;
  final bool autoPlay;
  final bool repeat;

  const RotateAnimation({
    super.key,
    required this.child,
    this.duration = AnimationsV2.rotation,
    this.delay = Duration.zero,
    this.curve = Curves.linear,
    this.begin = 0.0,
    this.end = 1.0,
    this.autoPlay = true,
    this.repeat = false,
  });

  @override
  State<RotateAnimation> createState() => _RotateAnimationState();
}

class _RotateAnimationState extends State<RotateAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: widget.begin, end: widget.end).animate(
      CurvedAnimation(
        parent: _controller,
        curve: widget.curve,
      ),
    );

    if (widget.autoPlay) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          if (widget.repeat) {
            _controller.repeat();
          } else {
            _controller.forward();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}

/// Bounce Animation Widget
///
/// Bounces a child widget with customizable intensity
class BounceAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final Duration delay;
  final bool autoPlay;
  final bool repeat;

  const BounceAnimation({
    super.key,
    required this.child,
    this.duration = AnimationsV2.mediumSlow,
    this.delay = Duration.zero,
    this.autoPlay = true,
    this.repeat = false,
  });

  @override
  State<BounceAnimation> createState() => _BounceAnimationState();
}

class _BounceAnimationState extends State<BounceAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: AnimationsV2.bouncy,
      ),
    );

    if (widget.autoPlay) {
      Future.delayed(widget.delay, () {
        if (mounted) {
          if (widget.repeat) {
            _controller.repeat(reverse: true);
          } else {
            _controller.forward();
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// Pulse Animation Widget
///
/// Pulses a child widget with scale effect
class PulseAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double minScale;
  final double maxScale;
  final bool autoPlay;

  const PulseAnimation({
    super.key,
    required this.child,
    this.duration = AnimationsV2.dramatic,
    this.minScale = 1.0,
    this.maxScale = 1.1,
    this.autoPlay = true,
  });

  @override
  State<PulseAnimation> createState() => _PulseAnimationState();
}

class _PulseAnimationState extends State<PulseAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation =
        Tween<double>(begin: widget.minScale, end: widget.maxScale).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    if (widget.autoPlay) {
      _controller.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _animation,
      child: widget.child,
    );
  }
}

/// Shake Animation Widget
///
/// Shakes a child widget horizontally
class ShakeAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;
  final int count;
  final bool autoPlay;

  const ShakeAnimation({
    super.key,
    required this.child,
    this.duration = AnimationsV2.mediumSlow,
    this.offset = 10.0,
    this.count = 3,
    this.autoPlay = true,
  });

  @override
  State<ShakeAnimation> createState() => _ShakeAnimationState();
}

class _ShakeAnimationState extends State<ShakeAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = TweenSequence<double>([
      for (int i = 0; i < widget.count; i++) ...[
        TweenSequenceItem(
          tween: Tween<double>(begin: 0.0, end: widget.offset),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: widget.offset, end: -widget.offset),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: -widget.offset, end: widget.offset),
          weight: 25,
        ),
        TweenSequenceItem(
          tween: Tween<double>(begin: widget.offset, end: 0.0),
          weight: 25,
        ),
      ]
    ]).animate(_controller);

    if (widget.autoPlay) {
      _controller.forward();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(_animation.value, 0),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Staggered List Animation
///
/// Animates list items with staggered delay
class StaggeredListAnimation extends StatelessWidget {
  final List<Widget> children;
  final Duration duration;
  final Duration staggerDelay;
  final Curve curve;
  final Axis direction;

  const StaggeredListAnimation({
    super.key,
    required this.children,
    this.duration = AnimationsV2.normal,
    this.staggerDelay = AnimationsV2.staggerMedium,
    this.curve = AnimationsV2.emphasizedDecelerate,
    this.direction = Axis.vertical,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = 0; i < children.length; i++)
          SlideInAnimation(
            delay: Duration(milliseconds: staggerDelay.inMilliseconds * i),
            duration: duration,
            curve: curve,
            begin: direction == Axis.vertical
                ? const Offset(0.0, 0.3)
                : const Offset(0.3, 0.0),
            child: FadeInAnimation(
              delay: Duration(milliseconds: staggerDelay.inMilliseconds * i),
              duration: duration,
              curve: curve,
              child: children[i],
            ),
          ),
      ],
    );
  }
}

/// Ripple Effect Widget
///
/// Creates a ripple effect on tap
class RippleEffect extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color color;
  final Duration duration;

  const RippleEffect({
    super.key,
    required this.child,
    this.onTap,
    this.color = TColorV2.primary,
    this.duration = AnimationsV2.ripple,
  });

  @override
  State<RippleEffect> createState() => _RippleEffectState();
}

class _RippleEffectState extends State<RippleEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTap() {
    _controller.forward(from: 0.0);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return CustomPaint(
            painter: _RipplePainter(
              progress: _animation.value,
              color: widget.color,
            ),
            child: child,
          );
        },
        child: widget.child,
      ),
    );
  }
}

class _RipplePainter extends CustomPainter {
  final double progress;
  final Color color;

  _RipplePainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius =
        math.sqrt(size.width * size.width + size.height * size.height);
    final radius = maxRadius * progress;

    final paint = Paint()
      ..color = color.withValues(alpha: (1 - progress) * 0.3)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

/// Glowing Effect Widget
///
/// Adds a glowing effect to a child widget
class GlowingEffect extends StatefulWidget {
  final Widget child;
  final Color color;
  final Duration duration;
  final double minIntensity;
  final double maxIntensity;

  const GlowingEffect({
    super.key,
    required this.child,
    this.color = TColorV2.primary,
    this.duration = AnimationsV2.veryDramatic,
    this.minIntensity = 0.3,
    this.maxIntensity = 0.8,
  });

  @override
  State<GlowingEffect> createState() => _GlowingEffectState();
}

class _GlowingEffectState extends State<GlowingEffect>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation =
        Tween<double>(begin: widget.minIntensity, end: widget.maxIntensity)
            .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: _animation.value),
                blurRadius: 20.0,
                spreadRadius: 5.0,
              ),
            ],
          ),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}

/// Floating Animation Widget
///
/// Creates a floating up and down effect
class FloatingAnimation extends StatefulWidget {
  final Widget child;
  final Duration duration;
  final double offset;

  const FloatingAnimation({
    super.key,
    required this.child,
    this.duration = AnimationsV2.ultraDramatic,
    this.offset = 10.0,
  });

  @override
  State<FloatingAnimation> createState() => _FloatingAnimationState();
}

class _FloatingAnimationState extends State<FloatingAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _animation = Tween<double>(begin: -widget.offset, end: widget.offset)
        .animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _controller.repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _animation.value),
          child: child,
        );
      },
      child: widget.child,
    );
  }
}
