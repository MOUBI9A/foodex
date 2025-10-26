import 'package:flutter/material.dart';

import '../../core/theme/color_extension.dart';

class ViewAllTitleRow extends StatelessWidget {
  final String title;
  final VoidCallback onView;
  const ViewAllTitleRow({super.key, required this.title, required this.onView });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
              color: TColor.primaryText,
              fontSize: 20,
              fontWeight: FontWeight.w800),
        ),
        TextButton.icon(
          onPressed: onView,
          icon: Icon(Icons.arrow_forward_ios, size: 14, color: TColor.primary),
          label: Text(
            "View all",
            style: TextStyle(
                color: TColor.primary,
                fontSize: 13,
                fontWeight: FontWeight.w600),
          ),
        )
      ],
    );
  }
}
