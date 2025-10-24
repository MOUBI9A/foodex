import 'package:flutter/material.dart';
import '../../core/theme/color_system_v2.dart';
import '../../core/theme/design_tokens_v2.dart';

/// Shimmer Loading Effect
///
/// Features:
/// - Smooth gradient animation
/// - Customizable base and highlight colors
/// - Predefined shapes (card, button, avatar, text)
/// - Custom child support
class ShimmerLoading extends StatefulWidget {
  /// Child widget to apply shimmer effect to
  final Widget? child;

  /// Base color for shimmer
  final Color? baseColor;

  /// Highlight color for shimmer
  final Color? highlightColor;

  /// Shimmer animation period
  final Duration period;

  /// Enable shimmer effect
  final bool enabled;

  const ShimmerLoading({
    super.key,
    this.child,
    this.baseColor,
    this.highlightColor,
    this.period = const Duration(milliseconds: 1500),
    this.enabled = true,
  });

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.period,
      vsync: this,
    );

    if (widget.enabled) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(ShimmerLoading oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.enabled) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) {
      return widget.child ?? const SizedBox.shrink();
    }

    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: [
                _controller.value - 0.3,
                _controller.value,
                _controller.value + 0.3,
              ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
              colors: [
                widget.baseColor ?? TColorV2.neutral200,
                widget.highlightColor ?? TColorV2.neutral100,
                widget.baseColor ?? TColorV2.neutral200,
              ],
            ).createShader(bounds);
          },
          child: widget.child ??
              Container(
                color: Colors.white,
              ),
        );
      },
    );
  }
}

/// Predefined shimmer shapes for common loading states
class ShimmerShapes {
  /// Card shimmer
  static Widget card({
    double? width,
    double? height,
    double? borderRadius,
  }) {
    return ShimmerLoading(
      child: Container(
        width: width ?? double.infinity,
        height: height ?? 120,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(
            borderRadius ?? RadiusV2.card,
          ),
        ),
      ),
    );
  }

  /// Button shimmer
  static Widget button({
    double? width,
    double? height,
  }) {
    return ShimmerLoading(
      child: Container(
        width: width ?? 200,
        height: height ?? SizingV2.buttonMd,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(RadiusV2.button),
        ),
      ),
    );
  }

  /// Avatar/Circle shimmer
  static Widget avatar({
    double? size,
  }) {
    final avatarSize = size ?? SizingV2.avatarMd;
    return ShimmerLoading(
      child: Container(
        width: avatarSize,
        height: avatarSize,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  /// Text line shimmer
  static Widget text({
    double? width,
    double? height,
  }) {
    return ShimmerLoading(
      child: Container(
        width: width ?? 200,
        height: height ?? TypographyScaleV2.md,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(RadiusV2.xs),
        ),
      ),
    );
  }

  /// Image shimmer
  static Widget image({
    double? width,
    double? height,
    double? aspectRatio,
  }) {
    return ShimmerLoading(
      child: AspectRatio(
        aspectRatio: aspectRatio ?? 16 / 9,
        child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(RadiusV2.md),
          ),
        ),
      ),
    );
  }
}

/// List Item Shimmer - for list loading states
class ListItemShimmer extends StatelessWidget {
  final bool showAvatar;
  final bool showImage;
  final int lineCount;
  final EdgeInsets? padding;

  const ListItemShimmer({
    super.key,
    this.showAvatar = false,
    this.showImage = false,
    this.lineCount = 2,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding ?? EdgeInsets.all(SpacingV2.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showAvatar)
            Padding(
              padding: EdgeInsets.only(right: SpacingV2.md),
              child: ShimmerShapes.avatar(),
            ),
          if (showImage)
            Padding(
              padding: EdgeInsets.only(right: SpacingV2.md),
              child: ShimmerShapes.image(
                width: 80,
                height: 80,
                aspectRatio: 1,
              ),
            ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ShimmerShapes.text(width: double.infinity),
                SizedBox(height: SpacingV2.sm),
                ...List.generate(
                  lineCount - 1,
                  (index) => Padding(
                    padding: EdgeInsets.only(bottom: SpacingV2.sm),
                    child: ShimmerShapes.text(
                      width: (lineCount - index - 1) * 50.0 + 100,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Card Shimmer - for card loading states
class CardShimmer extends StatelessWidget {
  final bool showImage;
  final int lineCount;
  final EdgeInsets? padding;

  const CardShimmer({
    super.key,
    this.showImage = true,
    this.lineCount = 3,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding ?? EdgeInsets.all(SpacingV2.md),
      decoration: BoxDecoration(
        color: TColorV2.surface,
        borderRadius: BorderRadius.circular(RadiusV2.card),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (showImage) ...[
            ShimmerShapes.image(
              width: double.infinity,
              aspectRatio: 16 / 9,
            ),
            SizedBox(height: SpacingV2.md),
          ],
          ShimmerShapes.text(width: double.infinity),
          SizedBox(height: SpacingV2.sm),
          ...List.generate(
            lineCount - 1,
            (index) => Padding(
              padding: EdgeInsets.only(bottom: SpacingV2.sm),
              child: ShimmerShapes.text(
                width: (lineCount - index - 1) * 60.0 + 120,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Grid Shimmer - for grid loading states
class GridShimmer extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double spacing;
  final double childAspectRatio;

  const GridShimmer({
    super.key,
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.spacing = 16.0,
    this.childAspectRatio = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return CardShimmer(
          showImage: true,
          lineCount: 2,
          padding: EdgeInsets.all(SpacingV2.sm),
        );
      },
    );
  }
}
