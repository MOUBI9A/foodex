import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class DriverOrdersView extends StatefulWidget {
  const DriverOrdersView({super.key});

  @override
  State<DriverOrdersView> createState() => _DriverOrdersViewState();
}

class _DriverOrdersViewState extends State<DriverOrdersView> {
  String selectedFilter = "All";

  List<Map<String, dynamic>> orders = [
    {
      "id": "DP2024001",
      "restaurant": "Pizza Palace",
      "customer": "John Smith",
      "address": "123 Main St, Downtown",
      "items": "2x Large Pizza, 1x Coke",
      "amount": 25.50,
      "distance": "2.5 km",
      "status": "Delivered",
      "time": "2 hours ago",
      "rating": 4.8,
    },
    {
      "id": "DP2024002",
      "restaurant": "Burger King",
      "customer": "Emma Wilson",
      "address": "456 Oak Ave, Uptown",
      "items": "1x Whopper Meal, 1x Fries",
      "amount": 18.75,
      "distance": "1.8 km",
      "status": "In Progress",
      "time": "Now",
      "rating": null,
    },
    {
      "id": "DP2024003",
      "restaurant": "Sushi Express",
      "customer": "Mike Johnson",
      "address": "789 Pine St, Eastside",
      "items": "1x Sushi Combo, 1x Miso Soup",
      "amount": 32.00,
      "distance": "3.2 km",
      "status": "Pending",
      "time": "5 min ago",
      "rating": null,
    },
    {
      "id": "DP2024004",
      "restaurant": "Taco Bell",
      "customer": "Sarah Davis",
      "address": "321 Elm St, Westside",
      "items": "3x Tacos, 1x Nachos",
      "amount": 16.25,
      "distance": "1.5 km",
      "status": "Delivered",
      "time": "1 hour ago",
      "rating": 5.0,
    },
  ];

  List<String> filterOptions = ["All", "Pending", "In Progress", "Delivered"];

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> filteredOrders = selectedFilter == "All"
        ? orders
        : orders.where((order) => order["status"] == selectedFilter).toList();

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: TColor.primary,
        elevation: 0,
        title: const Text(
          "My Orders",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Filter Tabs
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Row(
              children: filterOptions.map((filter) {
                bool isSelected = selectedFilter == filter;
                return Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedFilter = filter;
                      });
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color:
                            isSelected ? TColor.primary : Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(25),
                      ),
                      child: Text(
                        filter,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color:
                              isSelected ? Colors.white : TColor.secondaryText,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),

          // Orders List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: filteredOrders.length,
              itemBuilder: (context, index) {
                var order = filteredOrders[index];
                return _buildOrderCard(order);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order) {
    Color statusColor = _getStatusColor(order["status"]);
    IconData statusIcon = _getStatusIcon(order["status"]);

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Order #${order["id"]}",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(statusIcon, size: 14, color: statusColor),
                    const SizedBox(width: 4),
                    Text(
                      order["status"],
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Restaurant and Customer Info
          Row(
            children: [
              Icon(Icons.restaurant, color: TColor.primary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  order["restaurant"],
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.person, color: TColor.secondaryText, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  order["customer"],
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Icon(Icons.location_on, color: TColor.secondaryText, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  order["address"],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Items and Details
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Items:",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  order["items"],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 15),

          // Bottom Info
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "\$${order["amount"].toStringAsFixed(2)}",
                    style: TextStyle(
                      color: TColor.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    "${order["distance"]} • ${order["time"]}",
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              if (order["rating"] != null)
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      order["rating"].toString(),
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
            ],
          ),

          // Action Buttons
          if (order["status"] == "Pending" || order["status"] == "In Progress")
            Column(
              children: [
                const SizedBox(height: 15),
                Row(
                  children: [
                    if (order["status"] == "Pending") ...[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: Colors.red),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Decline",
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Accept",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                    ] else ...[
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: TColor.primary,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            "Navigate",
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {},
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(color: TColor.primary),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text(
                            "Call",
                            style: TextStyle(color: TColor.primary),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case "Pending":
        return Colors.orange;
      case "In Progress":
        return Colors.blue;
      case "Delivered":
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  IconData _getStatusIcon(String status) {
    switch (status) {
      case "Pending":
        return Icons.schedule;
      case "In Progress":
        return Icons.delivery_dining;
      case "Delivered":
        return Icons.check_circle;
      default:
        return Icons.info;
    }
  }
}
