import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'package:food_delivery/core/theme/design_tokens_v2.dart';
import 'package:food_delivery/presentation/widgets/modern_card.dart';

import '../../core/theme/color_extension.dart';

class MostPopularCell extends StatelessWidget {
  final Map mObj;
  final VoidCallback onTap;
  const MostPopularCell({super.key, required this.mObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(right: SpacingV2.md),
      width: 240,
      child: ModernCard(
        padding: EdgeInsets.zero,
        elevationLevel: 3,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with gradient overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(RadiusV2.card),
                  ),
                  child: Image.asset(
                    mObj["image"].toString(),
                    width: 240,
                    height: 140,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.5),
                        ],
                      ),
                    ),
                  ),
                ),
                // Rating badge at top right
                Positioned(
                  top: SpacingV2.sm,
                  right: SpacingV2.sm,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SpacingV2.xs,
                      vertical: SpacingV2.xxs,
                    ),
                    decoration: BoxDecoration(
                      color: TColorV2.secondary,
                      borderRadius: BorderRadius.circular(RadiusV2.full),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 6,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star,
                          size: SizingV2.iconSm,
                          color: Colors.white,
                        ),
                        SizedBox(width: SpacingV2.xxs),
                        Text(
                          mObj["rate"],
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: TypographyScaleV2.xs,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            // Restaurant details
            Padding(
              padding: EdgeInsets.all(SpacingV2.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    mObj["name"],
                    style: TextStyle(
                      color: TColorV2.textPrimary,
                      fontSize: TypographyScaleV2.md,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: SpacingV2.xxs),
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant_menu,
                        size: SizingV2.iconSm,
                        color: TColorV2.textSecondary,
                      ),
                      SizedBox(width: SpacingV2.xxs),
                      Expanded(
                        child: Text(
                          "${mObj["type"]} • ${mObj["food_type"]}",
                          style: TextStyle(
                            color: TColorV2.textSecondary,
                            fontSize: TypographyScaleV2.xs,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
