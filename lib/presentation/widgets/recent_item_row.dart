import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'package:food_delivery/core/theme/design_tokens_v2.dart';
import 'package:food_delivery/presentation/widgets/modern_card.dart';

import '../../core/theme/color_extension.dart';

class RecentItemRow extends StatelessWidget {
  final Map rObj;
  final VoidCallback onTap;
  const RecentItemRow({super.key, required this.rObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: SpacingV2.sm),
      child: ModernCard(
        padding: EdgeInsets.all(SpacingV2.sm),
        elevationLevel: 2,
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Item image with shadow
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusV2.md),
                boxShadow: [
                  BoxShadow(
                    color: TColorV2.primary.withValues(alpha: 0.15),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(RadiusV2.md),
                child: Image.asset(
                  rObj["image"].toString(),
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: SpacingV2.md),
            // Item details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    rObj["name"],
                    style: TextStyle(
                      color: TColorV2.textPrimary,
                      fontSize: TypographyScaleV2.md,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: SpacingV2.xxs),
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: SizingV2.iconSm,
                        color: TColorV2.textSecondary,
                      ),
                      SizedBox(width: SpacingV2.xxs),
                      Expanded(
                        child: Text(
                          "${rObj["type"]} • ${rObj["food_type"]}",
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
                  SizedBox(height: SpacingV2.xs),
                  Row(
                    children: [
                      // Rating badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: SpacingV2.xs,
                          vertical: SpacingV2.xxs,
                        ),
                        decoration: BoxDecoration(
                          color: TColorV2.secondary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(RadiusV2.xs),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              size: SizingV2.iconSm,
                              color: TColorV2.secondary,
                            ),
                            SizedBox(width: SpacingV2.xxs),
                            Text(
                              rObj["rate"],
                              style: TextStyle(
                                color: TColorV2.secondary,
                                fontSize: TypographyScaleV2.xs,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SpacingV2.xs),
                      Text(
                        "(${rObj["rating"]} reviews)",
                        style: TextStyle(
                          color: TColorV2.textSecondary,
                          fontSize: TypographyScaleV2.xs,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Add to cart icon
            Icon(
              Icons.add_shopping_cart,
              color: TColorV2.primary,
              size: SizingV2.iconMd,
            ),
          ],
        ),
      ),
    );
  }
}
