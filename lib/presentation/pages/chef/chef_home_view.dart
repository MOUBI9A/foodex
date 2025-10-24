import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';
import 'package:food_delivery/core/theme/color_system_v2.dart';
import 'package:food_delivery/core/theme/design_tokens_v2.dart';
import 'package:food_delivery/core/theme/animations_v2.dart';
import 'package:food_delivery/presentation/widgets/modern_button.dart';
import 'package:food_delivery/presentation/widgets/modern_card.dart';
import 'package:food_delivery/presentation/widgets/interactive_widgets.dart';
import 'package:food_delivery/presentation/widgets/animated_widgets.dart';
import 'package:food_delivery/core/utils/haptic_feedback.dart';
import 'package:food_delivery/features/chef/inventory/inventory_screen.dart';
import 'package:food_delivery/features/admin/dashboard/admin_dashboard_screen.dart';

class ChefHomeView extends StatefulWidget {
  const ChefHomeView({super.key});

  @override
  State<ChefHomeView> createState() => _ChefHomeViewState();
}

class _ChefHomeViewState extends State<ChefHomeView> {
  bool isKitchenOpen = false;

  Future<void> _toggleKitchen(bool value) async {
    await HapticFeedbackHelper.mediumImpact();
    setState(() {
      isKitchenOpen = value;
    });
    if (value) {
      await HapticFeedbackHelper.success();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: TColorV2.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section with Animation
              FadeInAnimation(
                duration: AnimationsV2.normal,
                child: Container(
                  padding: EdgeInsets.all(SpacingV2.lg),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [TColorV2.primary, TColorV2.primary.withValues(alpha: 0.8)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(RadiusV2.xl),
                      bottomRight: Radius.circular(RadiusV2.xl),
                    ),
                    boxShadow: ShadowsV2.md,
                  ),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          PulseAnimation(
                            minScale: 0.95,
                            maxScale: 1.05,
                            child: Container(
                              width: 60,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(RadiusV2.full),
                                boxShadow: ShadowsV2.sm,
                              ),
                              child: Icon(
                                Icons.restaurant_menu,
                                size: 30,
                                color: TColorV2.primary,
                              ),
                            ),
                          ),
                          SizedBox(width: SpacingV2.md),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Chef Maria's Kitchen",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: TypographyScaleV2.lg,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: SpacingV2.xs),
                                Text(
                                  "Chef ID: CH001 • ⭐ 4.9 (156 reviews)",
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: TypographyScaleV2.sm,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InteractiveWidget(
                            onTap: () {},
                            child: Container(
                              padding: EdgeInsets.all(SpacingV2.sm),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(RadiusV2.full),
                              ),
                              child: const Icon(
                                Icons.notifications_outlined,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: SpacingV2.lg),
                      // Kitchen Status Toggle with Modern Card
                      ModernCard(
                        padding: EdgeInsets.all(SpacingV2.lg),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isKitchenOpen ? "Kitchen is Open" : "Kitchen is Closed",
                                    style: TypographyScaleV2.lg.copyWith(
                                      color: TColorV2.textPrimary,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  SizedBox(height: SpacingV2.xs),
                                  Text(
                                    isKitchenOpen
                                        ? "Ready to receive orders"
                                        : "Turn on to start receiving orders",
                                    style: TypographyScaleV2.sm.copyWith(
                                      color: TColorV2.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            ScaleInAnimation(
                              delay: const Duration(milliseconds: 300),
                              child: Switch(
                                value: isKitchenOpen,
                                onChanged: _toggleKitchen,
                                activeColor: TColorV2.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: SpacingV2.lg),

              // Today's Summary with Staggered Animation
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                child: SlideInAnimation(
                  delay: const Duration(milliseconds: 200),
                  child: ModernCard(
                    padding: EdgeInsets.all(SpacingV2.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Summary",
                          style: TypographyScaleV2.lg.copyWith(
                            color: TColorV2.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: SpacingV2.md),
                        StaggeredListAnimation(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryCard("Earnings", "\$125.50",
                                      Icons.attach_money, Colors.green),
                                ),
                                SizedBox(width: SpacingV2.sm),
                                Expanded(
                                  child: _buildSummaryCard("Orders", "12",
                                      Icons.receipt_long, Colors.blue),
                                ),
                              ],
                            ),
                            SizedBox(height: SpacingV2.sm),
                            Row(
                              children: [
                                Expanded(
                                  child: _buildSummaryCard("Dishes Sold", "28",
                                      Icons.restaurant, Colors.orange),
                                ),
                                SizedBox(width: SpacingV2.sm),
                                Expanded(
                                  child: _buildSummaryCard(
                                      "Rating", "4.9", Icons.star, Colors.amber),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              SizedBox(height: SpacingV2.lg),

              // Current Orders (if kitchen is open)
              if (isKitchenOpen)
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                  child: ScaleInAnimation(
                    delay: const Duration(milliseconds: 400),
                    child: ModernCard(
                      padding: EdgeInsets.all(SpacingV2.lg),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Active Orders",
                                style: TypographyScaleV2.lg.copyWith(
                                  color: TColorV2.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: SpacingV2.md, vertical: SpacingV2.xs),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(RadiusV2.full),
                                ),
                                child: Text(
                                  "3 Cooking",
                                  style: TypographyScaleV2.sm.copyWith(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: SpacingV2.md),
                          _buildActiveOrder("Order #CM001", "Chicken Biryani x2",
                              "John Smith", "20 min", Colors.orange),
                          SizedBox(height: SpacingV2.sm),
                          _buildActiveOrder("Order #CM002", "Pasta Alfredo x1",
                              "Emma Wilson", "15 min", Colors.blue),
                          SizedBox(height: SpacingV2.sm),
                          _buildActiveOrder("Order #CM003", "Chocolate Cake x1",
                              "Mike Johnson", "30 min", Colors.green),
                        ],
                      ),
                    ),
                  ),
                ),

              SizedBox(height: SpacingV2.lg),

              // Popular Dishes Today
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                child: SlideInAnimation(
                  delay: const Duration(milliseconds: 600),
                  child: ModernCard(
                    padding: EdgeInsets.all(SpacingV2.lg),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Popular Dishes Today",
                          style: TypographyScaleV2.lg.copyWith(
                            color: TColorV2.textPrimary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        SizedBox(height: SpacingV2.md),
                        _buildPopularDish("Chicken Biryani", "8 orders",
                            "\$15.99", "assets/img/item_1.png"),
                        SizedBox(height: SpacingV2.sm),
                        _buildPopularDish("Homemade Pasta", "6 orders", "\$12.50",
                            "assets/img/item_2.png"),
                        SizedBox(height: SpacingV2.sm),
                        _buildPopularDish("Chocolate Cake", "4 orders", "\$8.99",
                            "assets/img/dess_1.png"),
                      ],
                    ),
                  ),
                ),

              SizedBox(height: SpacingV2.lg),

              // Quick Actions with Bouncy Buttons
              Padding(
                padding: EdgeInsets.symmetric(horizontal: SpacingV2.lg),
                child: FadeInAnimation(
                  delay: const Duration(milliseconds: 800),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Quick Actions",
                        style: TypographyScaleV2.lg.copyWith(
                          color: TColorV2.textPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: SpacingV2.md),
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickAction(
                                "Add Dish", Icons.add_circle, () {}),
                          ),
                          SizedBox(width: SpacingV2.sm),
                          Expanded(
                            child: _buildQuickAction(
                                "Update Menu", Icons.edit, () {}),
                          ),
                        ],
                      ),
                      SizedBox(height: SpacingV2.sm),
                      Row(
                        children: [
                          Expanded(
                            child: _buildQuickAction(
                                "Inventory", Icons.inventory_2, () async {
                              await HapticFeedbackHelper.selectionClick();
                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const ChefInventoryScreen(
                                      chefId: 'chef_001',
                                    ),
                                  ),
                                );
                              }
                            }),
                          ),
                          SizedBox(width: SpacingV2.sm),
                          Expanded(
                            child: _buildQuickAction(
                                "Analytics", Icons.analytics, () async {
                              await HapticFeedbackHelper.selectionClick();
                              if (mounted) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AdminDashboardScreen(
                                      chefId: 'chef_001',
                                    ),
                                  ),
                                );
                              }
                            }),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: SpacingV2.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return PressableCard(
      onPressed: () async {
        await HapticFeedbackHelper.lightImpact();
      },
      padding: EdgeInsets.all(SpacingV2.md),
      backgroundColor: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(RadiusV2.md),
      elevation: 0,
      pressedElevation: 2,
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: SpacingV2.xs),
          Text(
            value,
            style: TypographyScaleV2.lg.copyWith(
              color: TColorV2.textPrimary,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: TypographyScaleV2.xs.copyWith(
              color: TColorV2.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrder(String orderNumber, String dish, String customer,
      String time, Color statusColor) {
    return InteractiveWidget(
      onTap: () async {
        await HapticFeedbackHelper.selectionClick();
      },
      child: Container(
        padding: EdgeInsets.all(SpacingV2.sm),
        decoration: BoxDecoration(
          color: TColorV2.surface,
          borderRadius: BorderRadius.circular(RadiusV2.md),
          border: Border.all(color: statusColor.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(RadiusV2.full),
              ),
              child: Icon(Icons.restaurant, color: statusColor, size: 20),
            ),
            SizedBox(width: SpacingV2.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    orderNumber,
                    style: TypographyScaleV2.sm.copyWith(
                      color: TColorV2.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "$dish • $customer",
                    style: TypographyScaleV2.xs.copyWith(
                      color: TColorV2.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(
                  horizontal: SpacingV2.sm, vertical: SpacingV2.xs),
              decoration: BoxDecoration(
                color: statusColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(RadiusV2.sm),
              ),
              child: Text(
                time,
                style: TypographyScaleV2.xs.copyWith(
                  color: statusColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPopularDish(
      String name, String orders, String price, String image) {
    return InteractiveWidget(
      onTap: () async {
        await HapticFeedbackHelper.lightImpact();
      },
      child: Container(
        padding: EdgeInsets.all(SpacingV2.sm),
        decoration: BoxDecoration(
          color: TColorV2.surface,
          borderRadius: BorderRadius.circular(RadiusV2.md),
        ),
        child: Row(
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(RadiusV2.sm),
                image: DecorationImage(
                  image: AssetImage(image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: SpacingV2.md),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TypographyScaleV2.sm.copyWith(
                      color: TColorV2.textPrimary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    orders,
                    style: TypographyScaleV2.xs.copyWith(
                      color: TColorV2.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: TypographyScaleV2.sm.copyWith(
                color: TColorV2.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return BouncyButton(
      onPressed: () async {
        await HapticFeedbackHelper.mediumImpact();
        onTap();
      },
      child: ModernCard(
        padding: EdgeInsets.all(SpacingV2.lg),
        child: Column(
          children: [
            Icon(icon, color: TColorV2.primary, size: 32),
            SizedBox(height: SpacingV2.sm),
            Text(
              title,
              style: TypographyScaleV2.sm.copyWith(
                color: TColorV2.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
