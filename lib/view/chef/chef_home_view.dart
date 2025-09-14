import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class ChefHomeView extends StatefulWidget {
  const ChefHomeView({super.key});

  @override
  State<ChefHomeView> createState() => _ChefHomeViewState();
}

class _ChefHomeViewState extends State<ChefHomeView> {
  bool isKitchenOpen = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header Section
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                decoration: BoxDecoration(
                  color: TColor.primary,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                  ),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Icon(
                            Icons.restaurant_menu,
                            size: 30,
                            color: TColor.primary,
                          ),
                        ),
                        const SizedBox(width: 15),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Chef Maria's Kitchen",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                "Chef ID: CH001 • ⭐ 4.9 (156 reviews)",
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.notifications_outlined,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Kitchen Status Toggle
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                isKitchenOpen
                                    ? "Kitchen is Open"
                                    : "Kitchen is Closed",
                                style: TextStyle(
                                  color: TColor.primaryText,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                isKitchenOpen
                                    ? "Ready to receive orders"
                                    : "Turn on to start receiving orders",
                                style: TextStyle(
                                  color: TColor.secondaryText,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: isKitchenOpen,
                            onChanged: (value) {
                              setState(() {
                                isKitchenOpen = value;
                              });
                            },
                            activeColor: TColor.primary,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Today's Summary
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Today's Summary",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard("Earnings", "\$125.50",
                                Icons.attach_money, Colors.green),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildSummaryCard("Orders", "12",
                                Icons.receipt_long, Colors.blue),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Expanded(
                            child: _buildSummaryCard("Dishes Sold", "28",
                                Icons.restaurant, Colors.orange),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _buildSummaryCard(
                                "Rating", "4.9", Icons.star, Colors.amber),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Current Orders (if kitchen is open)
              if (isKitchenOpen)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 5,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Active Orders",
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                "3 Cooking",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 15),
                        _buildActiveOrder("Order #CM001", "Chicken Biryani x2",
                            "John Smith", "20 min", Colors.orange),
                        const SizedBox(height: 10),
                        _buildActiveOrder("Order #CM002", "Pasta Alfredo x1",
                            "Emma Wilson", "15 min", Colors.blue),
                        const SizedBox(height: 10),
                        _buildActiveOrder("Order #CM003", "Chocolate Cake x1",
                            "Mike Johnson", "30 min", Colors.green),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Popular Dishes Today
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Popular Dishes Today",
                        style: TextStyle(
                          color: TColor.primaryText,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 15),
                      _buildPopularDish("Chicken Biryani", "8 orders",
                          "\$15.99", "assets/img/item_1.png"),
                      const SizedBox(height: 10),
                      _buildPopularDish("Homemade Pasta", "6 orders", "\$12.50",
                          "assets/img/item_2.png"),
                      const SizedBox(height: 10),
                      _buildPopularDish("Chocolate Cake", "4 orders", "\$8.99",
                          "assets/img/dess_1.png"),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Quick Actions
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Quick Actions",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickAction(
                              "Add Dish", Icons.add_circle, () {}),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildQuickAction(
                              "Update Menu", Icons.edit, () {}),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildQuickAction(
                              "Kitchen Timer", Icons.timer, () {}),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildQuickAction(
                              "Analytics", Icons.analytics, () {}),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActiveOrder(String orderNumber, String dish, String customer,
      String time, Color statusColor) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(Icons.restaurant, color: statusColor, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderNumber,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                "$dish • $customer",
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(
            time,
            style: TextStyle(
              color: statusColor,
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPopularDish(
      String name, String orders, String price, String image) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            image: DecorationImage(
              image: AssetImage(image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                orders,
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ),
        Text(
          price,
          style: TextStyle(
            color: TColor.primary,
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAction(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          children: [
            Icon(icon, color: TColor.primary, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
