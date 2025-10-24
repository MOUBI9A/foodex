import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/presentation/pages/main_tabview/main_tabview.dart';
import 'package:food_delivery/presentation/pages/driver/driver_main_tabview.dart';
import 'package:food_delivery/presentation/pages/chef/chef_main_tabview.dart';
import 'package:food_delivery/data/repositories/wallet_service.dart';
import 'package:food_delivery/features/test_navigation_screen.dart';

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
                  // App Logo/Title with enhanced design
                  Container(
                    width: 150,
                    height: 150,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 30,
                          offset: const Offset(0, 12),
                          spreadRadius: 3,
                        ),
                        BoxShadow(
                          color: TColor.secondary.withValues(alpha: 0.25),
                          blurRadius: 35,
                          offset: const Offset(0, 15),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.restaurant_menu,
                          size: 60,
                          color: TColor.primary,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "FoodEx",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 35),

                  Text(
                    "FoodEx",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.25),
                          offset: const Offset(0, 4),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    "Community-driven food marketplace\nConnect with local home chefs",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.95),
                      fontSize: 16,
                      height: 1.5,
                      fontWeight: FontWeight.w500,
                      shadows: [
                        Shadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 50),

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

                  const SizedBox(height: 18),

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

                  const SizedBox(height: 18),

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

                  const SizedBox(height: 18),

                  // Test Features Button
                  _buildUserTypeButton(
                    context,
                    "🧪 Test Features",
                    "Quick access to Inventory & Analytics",
                    Icons.science,
                    Colors.deepPurple,
                    Colors.white,
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const TestNavigationScreen(),
                        ),
                      );
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
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(25),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
                spreadRadius: 2,
              ),
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.3),
                blurRadius: 25,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: textColor.withValues(alpha: 0.15),
                    width: 2,
                  ),
                ),
                child: Icon(
                  icon,
                  size: 38,
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
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: textColor.withValues(alpha: 0.85),
                        fontSize: 14,
                        height: 1.3,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: textColor.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: textColor.withValues(alpha: 0.15),
                    width: 1.5,
                  ),
                ),
                child: Icon(
                  Icons.arrow_forward,
                  color: textColor,
                  size: 24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
