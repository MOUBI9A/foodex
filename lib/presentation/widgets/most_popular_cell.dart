import 'package:flutter/material.dart';

import '../../core/theme/color_extension.dart';
import '../../core/utils/responsive.dart';

class MostPopularCell extends StatelessWidget {
  final Map mObj;
  final VoidCallback onTap;
  const MostPopularCell({super.key, required this.mObj, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final responsive = context.responsive;
    
    return Container(
      width: responsive.wp(0.64), // 64% of screen width
      margin: EdgeInsets.symmetric(horizontal: responsive.wp(0.027)),
      child: InkWell(
        borderRadius: BorderRadius.circular(22),
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 12,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
                child: Stack(
                  children: [
                    Image.asset(
                      mObj["image"].toString(),
                      width: double.infinity,
                      height: responsive.hp(0.17), // 17% of screen height
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      right: 12,
                      top: 12,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: responsive.wp(0.02),
                          vertical: responsive.hp(0.005),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.9),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star, size: responsive.sp(14), color: Colors.amber),
                            SizedBox(width: responsive.wp(0.01)),
                            Text(
                              mObj["rate"],
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontWeight: FontWeight.w700,
                                fontSize: responsive.sp(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Flexible(
                child: Padding(
                  padding: EdgeInsets.all(responsive.wp(0.043)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        mObj["name"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: responsive.sp(16),
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: responsive.hp(0.006)),
                      Text(
                        mObj["type"],
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: TColor.secondaryText,
                          fontSize: responsive.sp(12),
                        ),
                      ),
                      SizedBox(height: responsive.hp(0.008)),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              mObj["food_type"],
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: TColor.secondaryText,
                                fontSize: responsive.sp(11),
                              ),
                            ),
                          ),
                          TextButton(
                            style: TextButton.styleFrom(
                              foregroundColor: TColor.primary,
                              padding: EdgeInsets.symmetric(
                                horizontal: responsive.wp(0.02),
                                vertical: responsive.hp(0.003),
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: onTap,
                            child: Text(
                              'View',
                              style: TextStyle(fontSize: responsive.sp(12)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
