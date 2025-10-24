import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'package:food_delivery/core/theme/design_tokens_v2.dart';
import 'package:food_delivery/presentation/widgets/modern_card.dart';

import '../../core/theme/color_extension.dart';

class PopularRestaurantRow extends StatelessWidget {
  final Map pObj;
  final VoidCallback onTap;
  const PopularRestaurantRow({super.key, required this.pObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    // Determine badge based on data (you can customize this logic)
    String? badge = _getBadge(pObj);
    Color? badgeColor = _getBadgeColor(badge);
    
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: SpacingV2.sm,
        horizontal: SpacingV2.lg,
      ),
      child: ModernCard(
        padding: EdgeInsets.zero,
        elevationLevel: 3,
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image with badge overlay
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(RadiusV2.card),
                  ),
                  child: Image.asset(
                    pObj["image"].toString(),
                    width: double.maxFinite,
                    height: 180,
                    fit: BoxFit.cover,
                  ),
                ),
                // Gradient overlay for better text readability
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    height: 80,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.4),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),
                // Badge
                if (badge != null)
                  Positioned(
                    top: SpacingV2.md,
                    right: SpacingV2.md,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: SpacingV2.sm,
                        vertical: SpacingV2.xs,
                      ),
                      decoration: BoxDecoration(
                        color: badgeColor,
                        borderRadius: BorderRadius.circular(RadiusV2.full),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Text(
                        badge,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: TypographyScaleV2.xs,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                // Delivery time badge
                Positioned(
                  top: SpacingV2.md,
                  left: SpacingV2.md,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: SpacingV2.sm,
                      vertical: SpacingV2.xs,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(RadiusV2.full),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: SizingV2.iconSm,
                          color: TColorV2.textSecondary,
                        ),
                        SizedBox(width: SpacingV2.xxs),
                        Text(
                          "20-30 min",
                          style: TextStyle(
                            color: TColorV2.textPrimary,
                            fontSize: TypographyScaleV2.xs,
                            fontWeight: FontWeight.w600,
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
              padding: EdgeInsets.all(SpacingV2.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pObj["name"],
                    style: TextStyle(
                      color: TColorV2.textPrimary,
                      fontSize: TypographyScaleV2.xl,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: SpacingV2.xs),
                  Row(
                    children: [
                      // Rating
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
                              pObj["rate"],
                              style: TextStyle(
                                color: TColorV2.secondary,
                                fontSize: TypographyScaleV2.sm,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: SpacingV2.xs),
                      Text(
                        "(${pObj["rating"]} reviews)",
                        style: TextStyle(
                          color: TColorV2.textSecondary,
                          fontSize: TypographyScaleV2.sm,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: SpacingV2.xs),
                  Row(
                    children: [
                      Icon(
                        Icons.restaurant,
                        size: SizingV2.iconSm,
                        color: TColorV2.textSecondary,
                      ),
                      SizedBox(width: SpacingV2.xxs),
                      Text(
                        pObj["type"],
                        style: TextStyle(
                          color: TColorV2.textSecondary,
                          fontSize: TypographyScaleV2.sm,
                        ),
                      ),
                      Text(
                        " • ",
                        style: TextStyle(
                          color: TColorV2.textSecondary,
                          fontSize: TypographyScaleV2.sm,
                        ),
                      ),
                      Expanded(
                        child: Text(
                          pObj["food_type"],
                          style: TextStyle(
                            color: TColorV2.textSecondary,
                            fontSize: TypographyScaleV2.sm,
                          ),
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

  String? _getBadge(Map pObj) {
    // You can customize this logic based on your data
    final rate = double.tryParse(pObj["rate"]?.toString() ?? "0") ?? 0;
    if (rate >= 4.8) return "⭐ Top Rated";
    if (pObj["name"].toString().toLowerCase().contains("minute")) return "🚀 Fast";
    return null;
  }

  Color? _getBadgeColor(String? badge) {
    if (badge == null) return null;
    if (badge.contains("Top Rated")) return TColorV2.secondary;
    if (badge.contains("Fast")) return TColorV2.primary;
    return TColorV2.info;
  }
}
