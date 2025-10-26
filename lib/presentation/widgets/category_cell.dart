import 'package:flutter/material.dart';

import '../../core/theme/color_extension.dart';
import 'modern_card.dart';

class CategoryCell extends StatelessWidget {
  final Map cObj;
  final VoidCallback onTap;
  const CategoryCell({super.key, required this.cObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final bool isFeatured = cObj["featured"] == true;
    final double width = isFeatured ? 180 : 140;
    final double height = isFeatured ? 190 : 160;
    final int itemCount = cObj["count"] as int? ?? 0;

    return ModernCard(
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      padding: EdgeInsets.zero,
      borderRadius: 24,
      elevationLevel: isFeatured ? 4 : 2,
      color: Colors.transparent,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: LinearGradient(
            colors: [
              TColor.primary.withOpacity(isFeatured ? 0.95 : 0.8),
              TColor.primary.withOpacity(isFeatured ? 0.75 : 0.6),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(24),
                child: ColorFiltered(
                  colorFilter: ColorFilter.mode(
                    Colors.black.withOpacity(0.3),
                    BlendMode.darken,
                  ),
                  child: Image.asset(
                    cObj["image"].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9F1C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Maison',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    cObj["name"],
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isFeatured ? 18 : 16,
                      fontWeight: FontWeight.w800,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$itemCount dishes',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.85),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
