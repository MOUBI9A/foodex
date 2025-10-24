import 'package:flutter/material.dart';
import '../../core/theme/color_system_v2.dart';
import '../../core/theme/design_tokens_v2.dart';
import '../../core/theme/shadows_v2.dart';
import '../../core/theme/animations_v2.dart';

/// Modern Card Widget with Professional Design
///
/// Features:
/// - Hover elevation effect (web/desktop)
/// - Press animation with scale
/// - Customizable padding and radius
/// - Optional border
/// - Smooth shadow transitions
/// - Gradient overlay support
class ModernCard extends StatefulWidget {
  /// Card content
  final Widget child;

  /// Callback when card is tapped
  final VoidCallback? onTap;

  /// Card padding
  final EdgeInsets? padding;

  /// Card background color
  final Color? backgroundColor;

  /// Card border radius
  final double? borderRadius;

  /// Card border
  final Border? border;

  /// Enable hover effect
  final bool enableHoverEffect;

  /// Card margin
  final EdgeInsets? margin;

  /// Gradient overlay (optional)
  final Gradient? gradient;

  /// Custom shadow elevation level (1-6)
  final int? elevationLevel;

  const ModernCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderRadius,
    this.border,
    this.enableHoverEffect = true,
    this.margin,
    this.gradient,
    this.elevationLevel,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  bool _isHovered = false;
  bool _isPressed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: AnimationsV2.fast,
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 1.0, end: 0.98).animate(
      CurvedAnimation(parent: _controller, curve: AnimationsV2.emphasized),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _handleTapDown(TapDownDetails details) {
    if (widget.onTap != null) {
      setState(() => _isPressed = true);
      _controller.forward();
    }
  }

  void _handleTapUp(TapUpDetails details) {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
      _controller.reverse();
    }
  }

  List<BoxShadow> _getShadow() {
    if (_isPressed) {
      return ShadowsV2.level1;
    }
    if (_isHovered && widget.enableHoverEffect) {
      return ShadowsV2.cardHover;
    }

    // Use custom elevation level if provided
    if (widget.elevationLevel != null) {
      switch (widget.elevationLevel!) {
        case 1:
          return ShadowsV2.level1;
        case 2:
          return ShadowsV2.level2;
        case 3:
          return ShadowsV2.level3;
        case 4:
          return ShadowsV2.level4;
        case 5:
          return ShadowsV2.level5;
        case 6:
          return ShadowsV2.level6;
        default:
          return ShadowsV2.card;
      }
    }

    return ShadowsV2.card;
  }

  @override
  Widget build(BuildContext context) {
    final card = ScaleTransition(
      scale: _scaleAnimation,
      child: MouseRegion(
        onEnter: (_) =>
            widget.enableHoverEffect ? setState(() => _isHovered = true) : null,
        onExit: (_) => widget.enableHoverEffect
            ? setState(() => _isHovered = false)
            : null,
        child: GestureDetector(
          onTapDown: _handleTapDown,
          onTapUp: _handleTapUp,
          onTapCancel: _handleTapCancel,
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: AnimationsV2.normal,
            curve: AnimationsV2.emphasized,
            padding: widget.padding ?? EdgeInsets.all(SpacingV2.lg),
            decoration: BoxDecoration(
              color: widget.backgroundColor ?? TColorV2.surface,
              gradient: widget.gradient,
              border: widget.border,
              borderRadius: BorderRadius.circular(
                widget.borderRadius ?? RadiusV2.card,
              ),
              boxShadow: _getShadow(),
            ),
            child: widget.child,
          ),
        ),
      ),
    );

    if (widget.margin != null) {
      return Padding(
        padding: widget.margin!,
        child: card,
      );
    }

    return card;
  }
}

/// Featured Card - Card with image header
class FeaturedCard extends StatelessWidget {
  final String? imageUrl;
  final Widget? imageWidget;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsets? padding;
  final List<Widget>? actions;

  const FeaturedCard({
    super.key,
    this.imageUrl,
    this.imageWidget,
    required this.title,
    this.subtitle,
    this.trailing,
    this.onTap,
    this.padding,
    this.actions,
  }) : assert(
          imageUrl != null || imageWidget != null,
          'Either imageUrl or imageWidget must be provided',
        );

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      padding: EdgeInsets.zero,
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image header
          ClipRRect(
            borderRadius: BorderRadius.vertical(
              top: Radius.circular(RadiusV2.card),
            ),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: imageWidget ??
                  Image.network(
                    imageUrl!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: TColorV2.neutral100,
                        child: Icon(
                          Icons.image_not_supported,
                          size: SizingV2.iconXl,
                          color: TColorV2.neutral400,
                        ),
                      );
                    },
                  ),
            ),
          ),

          // Content
          Padding(
            padding: padding ?? EdgeInsets.all(SpacingV2.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: TypographyScaleV2.lg,
                              fontWeight: FontWeight.w600,
                              color: TColorV2.textPrimary,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          if (subtitle != null) ...[
                            SizedBox(height: SpacingV2.xs),
                            Text(
                              subtitle!,
                              style: TextStyle(
                                fontSize: TypographyScaleV2.sm,
                                color: TColorV2.textSecondary,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ],
                      ),
                    ),
                    if (trailing != null) ...[
                      SizedBox(width: SpacingV2.md),
                      trailing!,
                    ],
                  ],
                ),
                if (actions != null && actions!.isNotEmpty) ...[
                  SizedBox(height: SpacingV2.md),
                  Row(
                    children: actions!,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Info Card - Card with icon and title
class InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String? subtitle;
  final Color? iconColor;
  final Color? backgroundColor;
  final VoidCallback? onTap;

  const InfoCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.iconColor,
    this.backgroundColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ModernCard(
      onTap: onTap,
      backgroundColor: backgroundColor,
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(SpacingV2.md),
            decoration: BoxDecoration(
              color: (iconColor ?? TColorV2.primary).withOpacity(OpacityV2.sm),
              borderRadius: BorderRadius.circular(RadiusV2.md),
            ),
            child: Icon(
              icon,
              size: SizingV2.iconMd,
              color: iconColor ?? TColorV2.primary,
            ),
          ),
          SizedBox(width: SpacingV2.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: TypographyScaleV2.md,
                    fontWeight: FontWeight.w600,
                    color: TColorV2.textPrimary,
                  ),
                ),
                if (subtitle != null) ...[
                  SizedBox(height: SpacingV2.xxs),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      fontSize: TypographyScaleV2.sm,
                      color: TColorV2.textSecondary,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (onTap != null) ...[
            SizedBox(width: SpacingV2.sm),
            Icon(
              Icons.chevron_right,
              size: SizingV2.iconMd,
              color: TColorV2.neutral400,
            ),
          ],
        ],
      ),
    );
  }
}
