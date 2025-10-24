import 'package:flutter/material.dart';
import 'package:food_delivery/features/admin/common/theme/admin_theme.dart';

/// Reusable Metric Card Widget
///
/// Displays a single KPI metric with icon, label, value, and growth indicator.
/// Features smooth animations and hover effects.
class MetricCard extends StatefulWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color iconColor;
  final double? growthPercentage;
  final bool isLoading;

  const MetricCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.iconColor = AdminTheme.primaryOrange,
    this.growthPercentage,
    this.isLoading = false,
  });

  @override
  State<MetricCard> createState() => _MetricCardState();
}

class _MetricCardState extends State<MetricCard>
    with SingleTickerProviderStateMixin {
  bool _isHovered = false;
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _numberAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    // Parse value and create number animation
    final targetValue = _parseValue(widget.value);
    _numberAnimation = Tween<double>(begin: 0, end: targetValue).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Parse numeric value from string (handles currency symbols and commas)
  double _parseValue(String value) {
    final cleanedValue = value.replaceAll(RegExp(r'[^0-9.]'), '');
    return double.tryParse(cleanedValue) ?? 0;
  }

  /// Format the animated number back to display format
  String _formatValue(double animatedValue) {
    final originalValue = widget.value;

    if (originalValue.contains('\$')) {
      return '\$${animatedValue.toStringAsFixed(0)}';
    } else if (originalValue.contains('%')) {
      return '${animatedValue.toStringAsFixed(1)}%';
    } else {
      return animatedValue.toInt().toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.scale(
            scale: _isHovered ? 1.02 : 1.0,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(20),
                boxShadow:
                    _isHovered ? AdminTheme.hoverShadow : AdminTheme.cardShadow,
              ),
              child: ScaleTransition(
                scale: _scaleAnimation,
                child: child,
              ),
            ),
          );
        },
        child: Padding(
          padding: const EdgeInsets.all(24),
          child:
              widget.isLoading ? _buildLoadingState() : _buildContent(isDark),
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AdminTheme.gray300,
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        const SizedBox(height: 16),
        Container(
          width: 100,
          height: 16,
          decoration: BoxDecoration(
            color: AdminTheme.gray300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          width: 150,
          height: 32,
          decoration: BoxDecoration(
            color: AdminTheme.gray300,
            borderRadius: BorderRadius.circular(4),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(bool isDark) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Icon
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: widget.iconColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            widget.icon,
            size: 24,
            color: widget.iconColor,
          ),
        ),
        const SizedBox(height: 16),

        // Label
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isDark ? AdminTheme.gray400 : AdminTheme.gray600,
          ),
        ),
        const SizedBox(height: 8),

        // Animated Value
        AnimatedBuilder(
          animation: _numberAnimation,
          builder: (context, child) {
            return Text(
              _formatValue(_numberAnimation.value),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w700,
              ),
            );
          },
        ),

        // Growth Indicator (if provided)
        if (widget.growthPercentage != null) ...[
          const SizedBox(height: 12),
          _buildGrowthIndicator(widget.growthPercentage!),
        ],
      ],
    );
  }

  Widget _buildGrowthIndicator(double growth) {
    final isPositive = growth >= 0;
    final color = isPositive ? AdminTheme.successGreen : AdminTheme.errorRed;
    final icon = isPositive ? Icons.trending_up : Icons.trending_down;

    return Row(
      children: [
        Icon(
          icon,
          size: 16,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          '${growth.abs().toStringAsFixed(1)}%',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          'vs last week',
          style: TextStyle(
            fontSize: 12,
            color: Theme.of(context).brightness == Brightness.dark
                ? AdminTheme.gray400
                : AdminTheme.gray600,
          ),
        ),
      ],
    );
  }
}
