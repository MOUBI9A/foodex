import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/presentation/pages/main_tabview/main_tabview.dart';
import 'package:food_delivery/presentation/pages/driver/driver_main_tabview.dart';
import 'package:food_delivery/presentation/pages/chef/chef_main_tabview.dart';
import 'package:food_delivery/data/repositories/wallet_service.dart';

class UserTypeSelectorView extends StatelessWidget {
  const UserTypeSelectorView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              TColor.primary,
              TColor.primary.withValues(alpha: 0.8),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(30, 50, 30, 30),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // App Logo/Title with Moroccan-inspired design
                  Container(
                    width: 140,
                    height: 140,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: TColor.cardShadow,
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 50,
                          color: TColor.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "FoodEx",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "FoodEx",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    "Community-driven food marketplace\nConnect with local home chefs",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Customer Button
                  _buildUserTypeButton(
                    context,
                    "Customer",
                    "Browse & order from home chefs",
                    Icons.restaurant,
                    Colors.white,
                    TColor.primary,
                    () async {
                      // Initialize wallet for customer
                      final walletService = WalletService();
                      await walletService.initializeWallet('customer_001');

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const MainTabView()),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 15),

                  // Chef Button
                  _buildUserTypeButton(
                    context,
                    "Home Chef",
                    "Share your culinary passion & earn",
                    Icons.restaurant_menu,
                    TColor.secondary,
                    Colors.white,
                    () async {
                      // Initialize wallet for chef
                      final walletService = WalletService();
                      await walletService.initializeWallet('chef_001');

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChefMainTabView()),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 15),

                  // Courier Button
                  _buildUserTypeButton(
                    context,
                    "Courier",
                    "Deliver meals & earn money",
                    Icons.motorcycle,
                    TColor.accent,
                    TColor.primaryText,
                    () async {
                      // Initialize wallet for courier
                      final walletService = WalletService();
                      await walletService.initializeWallet('courier_001');

                      if (context.mounted) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const DriverMainTabView()),
                        );
                      }
                    },
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Choose your experience\nSwitch between modes anytime",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserTypeButton(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    Color backgroundColor,
    Color textColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: TColor.cardShadow,
              blurRadius: 15,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 65,
              height: 65,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Icon(
                icon,
                size: 32,
                color: textColor,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: textColor.withValues(alpha: 0.8),
                      fontSize: 14,
                      height: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: textColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: textColor.withValues(alpha: 0.8),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
