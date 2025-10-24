import 'package:flutter/material.dart';
import '../../core/theme/color_system_v2.dart';
import '../../core/theme/design_tokens_v2.dart';
import '../../core/theme/shadows_v2.dart';
import '../../core/theme/animations_v2.dart';

/// Modern Button Widget with Professional Design
///
/// Features:
/// - Multiple variants (primary, secondary, ghost, danger)
/// - Multiple sizes (small, medium, large)
/// - Loading state with spinner
/// - Disabled state
/// - Press animation with scale
/// - Ripple effect animation
/// - Gradient backgrounds
/// - Icon support (leading/trailing)
/// - Shine effect on hover
/// - Haptic feedback ready
class ModernButton extends StatefulWidget {
  /// Button text
  final String text;

  /// Callback when button is pressed
  final VoidCallback? onPressed;

  /// Button visual variant
  final ButtonVariant variant;

  /// Button size
  final ButtonSize size;

  /// Loading state - shows spinner and disables button
  final bool isLoading;

  /// Leading icon (before text)
  final IconData? leadingIcon;

  /// Trailing icon (after text)
  final IconData? trailingIcon;

  /// Full width button
  final bool fullWidth;

  /// Custom gradient (overrides variant gradient)
  final Gradient? customGradient;

  /// Enable ripple effect
  final bool enableRipple;

  /// Enable shine effect
  final bool enableShine;

  const ModernButton({
    super.key,
    required this.text,
    this.onPressed,
    this.variant = ButtonVariant.primary,
    this.size = ButtonSize.medium,
    this.isLoading = false,
    this.leadingIcon,
    this.trailingIcon,
    this.fullWidth = false,
    this.customGradient,
    this.enableRipple = true,
    this.enableShine = true,
  });

  @override
  State<ModernButton> createState() => _ModernButtonState();
}

class _ModernButtonState extends State<ModernButton>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _rippleController;
  late AnimationController _shineController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rippleAnimation;
  late Animation<double> _shineAnimation;
  bool _isPressed = false;
  Offset? _tapPosition;

  @override
  void initState() {
    super.initState();

    // Scale animation controller
    _scaleController = AnimationController(
      duration: AnimationsV2.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.95).animate(
      CurvedAnimation(parent: _scaleController, curve: AnimationsV2.emphasized),
    );

    // Ripple effect controller
    _rippleController = AnimationController(
      duration: AnimationsV2.ripple,
      vsync: this,
    );
    _rippleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _rippleController, curve: Curves.easeOut),
    );

    // Shine effect controller
    _shineController = AnimationController(
      duration: AnimationsV2.veryDramatic,
      vsync: this,
    );
    _shineAnimation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _shineController, curve: Curves.easeInOut),
    );

    // Periodic shine effect
    if (widget.enableShine) {
      Future.delayed(Duration(seconds: 3), () {
        if (mounted) {
          _startPeriodicShine();
        }
      });
    }
  }

  void _startPeriodicShine() {
    _shineController.repeat(
      period: Duration(seconds: 5),
    );
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _rippleController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onPressed != null && !widget.isLoading) {
      setState(() {
        _isPressed = true;
        _tapPosition = details.localPosition;
      });
      _scaleController.forward();
      if (widget.enableRipple) {
        _rippleController.forward(from: 0.0);
      }
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _scaleController.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _scaleController.reverse();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = widget.onPressed == null || widget.isLoading;
    final variant = widget.variant;
    final size = widget.size;

    return ScaleTransition(
      scale: _scaleAnimation,
      child: GestureDetector(
        onTapDown: _handleTapDown,
        onTapUp: _handleTapUp,
        onTapCancel: _handleTapCancel,
        onTap: isDisabled ? null : widget.onPressed,
        child: Stack(
          children: [
            // Main button container
            AnimatedContainer(
              duration: AnimationsV2.fast,
              curve: AnimationsV2.emphasized,
              height: size.height,
              width: widget.fullWidth ? double.infinity : null,
              padding: size.padding,
              decoration: BoxDecoration(
                gradient: _getGradient(variant, isDisabled),
                color: _getBackgroundColor(variant, isDisabled),
                border: _getBorder(variant, isDisabled),
                borderRadius: BorderRadius.circular(RadiusV2.button),
                boxShadow: _getShadow(variant, isDisabled),
              ),
              child: Row(
                mainAxisSize:
                    widget.fullWidth ? MainAxisSize.max : MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (widget.isLoading)
                    SizedBox(
                      width: size.iconSize,
                      height: size.iconSize,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation(
                          _getContentColor(variant, isDisabled),
                        ),
                      ),
                    )
                  else ...[
                    if (widget.leadingIcon != null) ...[
                      Icon(
                        widget.leadingIcon,
                        size: size.iconSize,
                        color: _getContentColor(variant, isDisabled),
                      ),
                      SizedBox(width: SpacingV2.sm),
                    ],
                    Flexible(
                      child: Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: size.fontSize,
                          fontWeight: FontWeight.w600,
                          color: _getContentColor(variant, isDisabled),
                          letterSpacing: 0.5,
                        ),
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (widget.trailingIcon != null) ...[
                      SizedBox(width: SpacingV2.sm),
                      Icon(
                        widget.trailingIcon,
                        size: size.iconSize,
                        color: _getContentColor(variant, isDisabled),
                      ),
                    ],
                  ],
                ],
              ),
            ),

            // Ripple effect overlay
            if (widget.enableRipple && !isDisabled)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusV2.button),
                  child: AnimatedBuilder(
                    animation: _rippleAnimation,
                    builder: (context, child) {
                      if (_tapPosition == null || _rippleAnimation.value == 0) {
                        return const SizedBox.shrink();
                      }
                      return CustomPaint(
                        painter: _RipplePainter(
                          center: _tapPosition!,
                          progress: _rippleAnimation.value,
                          color: Colors.white.withValues(alpha: 0.3),
                        ),
                      );
                    },
                  ),
                ),
              ),

            // Shine effect overlay
            if (widget.enableShine &&
                !isDisabled &&
                variant == ButtonVariant.primary)
              Positioned.fill(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusV2.button),
                  child: AnimatedBuilder(
                    animation: _shineAnimation,
                    builder: (context, child) {
                      return CustomPaint(
                        painter: _ShinePainter(
                          progress: _shineAnimation.value,
                        ),
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Gradient? _getGradient(ButtonVariant variant, bool isDisabled) {
    if (widget.customGradient != null) {
      return isDisabled ? null : widget.customGradient;
    }

    if (isDisabled) return null;

    switch (variant) {
      case ButtonVariant.primary:
        return _isPressed
            ? LinearGradient(
                colors: [TColorV2.primaryDark, TColorV2.primaryDark],
              )
            : TColorV2.primaryGradient;
      case ButtonVariant.secondary:
        return null;
      case ButtonVariant.ghost:
        return null;
      case ButtonVariant.danger:
        return LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            TColorV2.error,
            TColorV2.lighten(TColorV2.error, 0.1),
          ],
        );
    }
  }

  Color? _getBackgroundColor(ButtonVariant variant, bool isDisabled) {
    if (widget.customGradient != null) return null;

    if (isDisabled) {
      return TColorV2.neutral200;
    }

    switch (variant) {
      case ButtonVariant.primary:
        return null; // Uses gradient
      case ButtonVariant.secondary:
        return _isPressed ? TColorV2.neutral100 : TColorV2.surface;
      case ButtonVariant.ghost:
        return _isPressed ? TColorV2.neutral100 : Colors.transparent;
      case ButtonVariant.danger:
        return null; // Uses gradient
    }
  }

  Border? _getBorder(ButtonVariant variant, bool isDisabled) {
    if (isDisabled) {
      return Border.all(color: TColorV2.neutral300, width: 1.5);
    }

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.danger:
        return null;
      case ButtonVariant.secondary:
        return Border.all(color: TColorV2.primary, width: 2);
      case ButtonVariant.ghost:
        return Border.all(color: Colors.transparent);
    }
  }

  List<BoxShadow> _getShadow(ButtonVariant variant, bool isDisabled) {
    if (isDisabled || _isPressed) return [];

    switch (variant) {
      case ButtonVariant.primary:
        return ShadowsV2.primaryShadow(0.3);
      case ButtonVariant.danger:
        return ShadowsV2.errorShadow(0.3);
      case ButtonVariant.secondary:
      case ButtonVariant.ghost:
        return [];
    }
  }

  Color _getContentColor(ButtonVariant variant, bool isDisabled) {
    if (isDisabled) {
      return TColorV2.neutral500;
    }

    switch (variant) {
      case ButtonVariant.primary:
      case ButtonVariant.danger:
        return TColorV2.textInverse;
      case ButtonVariant.secondary:
        return TColorV2.primary;
      case ButtonVariant.ghost:
        return TColorV2.textPrimary;
    }
  }
}

/// Button visual variants
enum ButtonVariant {
  /// Filled button with gradient
  primary,

  /// Outlined button
  secondary,

  /// Text-only button
  ghost,

  /// Error/destructive button
  danger,
}

/// Button sizes
enum ButtonSize {
  /// Small button (36px height)
  small(
    height: SizingV2.buttonSm,
    fontSize: TypographyScaleV2.md,
    iconSize: SizingV2.iconSm,
    padding: EdgeInsets.symmetric(horizontal: SpacingV2.md),
  ),

  /// Medium button (44px height)
  medium(
    height: SizingV2.buttonMd,
    fontSize: TypographyScaleV2.lg,
    iconSize: SizingV2.iconMd,
    padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
  ),

  /// Large button (56px height)
  large(
    height: SizingV2.buttonLg,
    fontSize: TypographyScaleV2.xl,
    iconSize: SizingV2.iconMd,
    padding: EdgeInsets.symmetric(horizontal: SpacingV2.xl),
  );

  final double height;
  final double fontSize;
  final double iconSize;
  final EdgeInsets padding;

  const ButtonSize({
    required this.height,
    required this.fontSize,
    required this.iconSize,
    required this.padding,
  });
}

/// Custom painter for ripple effect
class _RipplePainter extends CustomPainter {
  final Offset center;
  final double progress;
  final Color color;

  _RipplePainter({
    required this.center,
    required this.progress,
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (progress == 0) return;

    final maxRadius =
        (size.width > size.height ? size.width : size.height) * 1.5;
    final radius = maxRadius * progress;
    final opacity = (1 - progress) * 0.6;

    final paint = Paint()
      ..color = color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(_RipplePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.center != center;
  }
}

/// Custom painter for shine effect
class _ShinePainter extends CustomPainter {
  final double progress;

  _ShinePainter({required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    if (progress < -0.5 || progress > 1.5) return;

    final paint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.0),
          Colors.white.withValues(alpha: 0.2),
          Colors.white.withValues(alpha: 0.0),
          Colors.transparent,
        ],
        stops: const [0.0, 0.3, 0.5, 0.7, 1.0],
      ).createShader(
        Rect.fromLTWH(
          size.width * progress - 50,
          0,
          100,
          size.height,
        ),
      );

    canvas.drawRect(
      Rect.fromLTWH(
        size.width * progress - 50,
        0,
        100,
        size.height,
      ),
      paint,
    );
  }

  @override
  bool shouldRepaint(_ShinePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
