import 'package:flutter/material.dart';
import 'package:food_delivery/presentation/pages/more/about_us_view.dart';
import 'package:food_delivery/core/network/service_call.dart';
import 'package:food_delivery/presentation/pages/login/login_view.dart';
import 'package:food_delivery/presentation/pages/profile/support_faq_view.dart';

import 'package:food_delivery/core/theme/color_extension.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> moreArr = [
      {
        "name": "About Us",
        "image": "assets/images/more_info.png",
        "subtitle": "Learn more about FoodEx",
        "onTap": () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUsView()),
            ),
      },
      {
        "name": "Help / Support",
        "image": "assets/images/more_inbox.png",
        "subtitle": "FAQs and customer care",
        "onTap": () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const SupportFaqView()),
            ),
      },
      {
        "name": "Legal & Policies",
        "image": "assets/images/more_info.png",
        "subtitle": "Terms, privacy, community rules",
        "onTap": () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AboutUsView()),
            ),
      },
      {
        "name": "Logout",
        "image": "assets/images/more_info.png",
        "subtitle": "Return to login",
        "isDanger": true,
        "onTap": () {
          ServiceCall.logout();
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (_) => const LoginView()),
            (route) => false,
          );
        },
      },
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 46),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "More",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "Looking for account settings? Visit the Profile tab.",
                      style:
                          TextStyle(color: TColor.secondaryText, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              ListView.builder(
                padding: EdgeInsets.zero,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: moreArr.length,
                itemBuilder: (context, index) {
                  final item = moreArr[index];
                  final bool isDanger = item['isDanger'] as bool? ?? false;
                  return InkWell(
                    onTap: item['onTap'] as void Function()?,
                    child: Container(
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 20),
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
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: TColor.textfield,
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Image.asset(item['image'] as String),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['name'] as String,
                                  style: TextStyle(
                                    color: isDanger
                                        ? TColor.error
                                        : TColor.primaryText,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  item['subtitle'] as String,
                                  style: TextStyle(color: TColor.secondaryText),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.chevron_right),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 120),
            ],
          ),
        ),
      ),
    );
  }
}
