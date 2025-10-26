import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';

class EditProfileView extends StatelessWidget {
  const EditProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Coming soon',
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 22,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Profile editing will allow you to change your photo, name, and contact details.',
              style: TextStyle(color: TColor.secondaryText, fontSize: 15),
            ),
          ],
        ),
      ),
    );
  }
}
