import 'package:flutter/material.dart';

/// A lightweight reusable card with smooth shadows and optional hover lift.
///
/// elevationLevel: 0-6 (defaults to 1)
class ModernCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final double borderRadius;
  final int elevationLevel;
  final VoidCallback? onTap;

  const ModernCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius = 20,
    this.elevationLevel = 1,
    this.onTap,
  });

  @override
  State<ModernCard> createState() => _ModernCardState();
}

class _ModernCardState extends State<ModernCard> {
  bool _hovering = false;

  List<BoxShadow> _shadowForLevel(int level, Color base) {
    final clamped = level.clamp(0, 6);
    if (clamped == 0) return const [];
    final double blur = 4 + clamped * 4.0;
    final double spread = (clamped <= 2) ? 0 : 0.5;
    final double y = 1 + clamped * 1.2;
    return [
      BoxShadow(
  color: Colors.black.withValues(alpha: 0.06 + clamped * 0.02),
        blurRadius: blur,
        spreadRadius: spread,
        offset: Offset(0, y),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).cardColor;
    final borderRadius = BorderRadius.circular(widget.borderRadius);

    Widget content = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      curve: Curves.easeOut,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: borderRadius,
        boxShadow: _shadowForLevel(widget.elevationLevel, color),
      ),
      transform: _hovering
          ? (Matrix4.identity()..translate(0.0, -1.5))
          : Matrix4.identity(),
      child: widget.child,
    );

    if (widget.onTap != null) {
      content = Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: borderRadius,
          onTap: widget.onTap,
          child: content,
        ),
      );
    }

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: content,
    );
  }
}
