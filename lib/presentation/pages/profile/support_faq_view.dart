import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';

class SupportFaqView extends StatelessWidget {
  const SupportFaqView({super.key});

  @override
  Widget build(BuildContext context) {
    final faqs = [
      {
        'question': 'How do I report a delivery issue?',
        'answer': 'Open live tracking, tap “Need help”, or email support@foodex.com.'
      },
      {
        'question': 'Can I save multiple addresses?',
        'answer': 'Yes, open the profile header and add additional delivery spots.'
      },
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Help & Support')),
      body: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount: faqs.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final faq = faqs[index];
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color: TColor.cardShadow,
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faq['question']!,
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  faq['answer']!,
                  style: TextStyle(color: TColor.secondaryText),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
