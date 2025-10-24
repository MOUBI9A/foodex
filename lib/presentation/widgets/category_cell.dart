import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'package:food_delivery/core/theme/design_tokens_v2.dart';

import '../../core/theme/color_extension.dart';

class CategoryCell extends StatelessWidget {
  final Map cObj;
  final VoidCallback onTap;
  const CategoryCell({super.key, required this.cObj, required this.onTap });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: SpacingV2.xs),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(RadiusV2.lg),
        child: Container(
          width: 90,
          child: Column(
            children: [
              Container(
                width: 85,
                height: 85,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(RadiusV2.lg),
                  boxShadow: [
                    BoxShadow(
                      color: TColorV2.primary.withValues(alpha: 0.15),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(RadiusV2.lg),
                  child: Image.asset(
                    cObj["image"].toString(),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(height: SpacingV2.xs),
              Text(
                cObj["name"],
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: TColorV2.textPrimary,
                  fontSize: TypographyScaleV2.sm,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}