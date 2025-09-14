import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class ChefOrdersView extends StatefulWidget {
  const ChefOrdersView({super.key});

  @override
  State<ChefOrdersView> createState() => _ChefOrdersViewState();
}

class _ChefOrdersViewState extends State<ChefOrdersView>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final List<Map<String, dynamic>> newOrders = [
    {
      "id": "CM001",
      "customer": "John Smith",
      "items": [
        {"name": "Chicken Biryani", "qty": 2, "price": 15.99},
        {"name": "Lassi", "qty": 1, "price": 3.99},
      ],
      "total": 35.97,
      "order_time": "2:30 PM",
      "delivery_time": "3:00 PM",
      "customer_note": "Extra spicy please",
      "address": "123 Main St, Downtown",
      "phone": "+1 234 567 8900",
    },
    {
      "id": "CM002",
      "customer": "Emma Wilson",
      "items": [
        {"name": "Pasta Alfredo", "qty": 1, "price": 12.50},
      ],
      "total": 12.50,
      "order_time": "2:45 PM",
      "delivery_time": "3:15 PM",
      "customer_note": "No garlic please",
      "address": "456 Oak Ave, Midtown",
      "phone": "+1 234 567 8901",
    },
  ];

  final List<Map<String, dynamic>> cookingOrders = [
    {
      "id": "CM003",
      "customer": "Mike Johnson",
      "items": [
        {"name": "Grilled Salmon", "qty": 1, "price": 18.99},
        {"name": "Side Salad", "qty": 1, "price": 5.99},
      ],
      "total": 24.98,
      "order_time": "2:00 PM",
      "delivery_time": "2:45 PM",
      "started_time": "2:10 PM",
      "estimated_completion": "2:40 PM",
      "address": "789 Pine St, Uptown",
      "phone": "+1 234 567 8902",
    },
  ];

  final List<Map<String, dynamic>> readyOrders = [
    {
      "id": "CM004",
      "customer": "Sarah Davis",
      "items": [
        {"name": "Chocolate Cake", "qty": 1, "price": 8.99},
        {"name": "Coffee", "qty": 2, "price": 2.99},
      ],
      "total": 14.97,
      "order_time": "1:30 PM",
      "delivery_time": "2:15 PM",
      "completed_time": "2:05 PM",
      "address": "321 Elm St, Southside",
      "phone": "+1 234 567 8903",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Orders",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "${newOrders.length} New",
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.refresh,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  // Quick Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildQuickStat(
                            "Today's Orders", "15", Icons.receipt_long),
                      ),
                      const SizedBox(width: 15),
                      Expanded(
                        child: _buildQuickStat(
                            "Avg. Prep Time", "22 min", Icons.timer),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Order Status Tabs
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
                isScrollable: true,
                indicator: BoxDecoration(
                  color: TColor.primary,
                  borderRadius: BorderRadius.circular(25),
                ),
                labelColor: Colors.white,
                unselectedLabelColor: TColor.primaryText,
                labelStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
                tabs: [
                  Tab(text: "New (${newOrders.length})"),
                  Tab(text: "Cooking (${cookingOrders.length})"),
                  Tab(text: "Ready (${readyOrders.length})"),
                  Tab(text: "History"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Orders Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildNewOrdersTab(),
                  _buildCookingOrdersTab(),
                  _buildReadyOrdersTab(),
                  _buildHistoryTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickStat(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.white, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNewOrdersTab() {
    if (newOrders.isEmpty) {
      return _buildEmptyState("No new orders",
          "All caught up! New orders will appear here.", Icons.inbox);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: newOrders.length,
      itemBuilder: (context, index) {
        final order = newOrders[index];
        return _buildOrderCard(
          order,
          Colors.orange,
          "New Order",
          [
            _buildActionButton(
                "Accept", TColor.primary, () => _acceptOrder(order)),
            _buildActionButton("Reject", Colors.red, () => _rejectOrder(order)),
          ],
        );
      },
    );
  }

  Widget _buildCookingOrdersTab() {
    if (cookingOrders.isEmpty) {
      return _buildEmptyState("No orders cooking",
          "Orders you're preparing will appear here.", Icons.restaurant);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: cookingOrders.length,
      itemBuilder: (context, index) {
        final order = cookingOrders[index];
        return _buildOrderCard(
          order,
          Colors.blue,
          "Cooking",
          [
            _buildActionButton(
                "Mark Ready", Colors.green, () => _markOrderReady(order)),
            _buildActionButton(
                "Add Time", Colors.orange, () => _addCookingTime(order)),
          ],
          showTimer: true,
        );
      },
    );
  }

  Widget _buildReadyOrdersTab() {
    if (readyOrders.isEmpty) {
      return _buildEmptyState(
          "No orders ready",
          "Completed orders waiting for pickup will appear here.",
          Icons.check_circle);
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      itemCount: readyOrders.length,
      itemBuilder: (context, index) {
        final order = readyOrders[index];
        return _buildOrderCard(
          order,
          Colors.green,
          "Ready for Pickup",
          [
            _buildActionButton("Mark Delivered", Colors.green,
                () => _markOrderDelivered(order)),
            _buildActionButton(
                "Call Customer", Colors.blue, () => _callCustomer(order)),
          ],
        );
      },
    );
  }

  Widget _buildHistoryTab() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 80, color: TColor.placeholder),
          const SizedBox(height: 20),
          Text(
            "Order history will appear here",
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Completed orders from the past will be shown here",
            style: TextStyle(
              color: TColor.placeholder,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: TColor.placeholder),
          const SizedBox(height: 20),
          Text(
            title,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 18,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subtitle,
            style: TextStyle(
              color: TColor.placeholder,
              fontSize: 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, Color statusColor,
      String statusText, List<Widget> actions,
      {bool showTimer = false}) {
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
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Order #${order['id']}",
                    style: TextStyle(
                      color: TColor.primaryText,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    order['customer'],
                    style: TextStyle(
                      color: TColor.secondaryText,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    color: statusColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          // Order Items
          Column(
            children: order['items'].map<Widget>((item) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "${item['qty']}x ${item['name']}",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      "\$${(item['price'] * item['qty']).toStringAsFixed(2)}",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),

          const Divider(height: 20),

          // Order Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Total: \$${order['total'].toStringAsFixed(2)}",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                "Delivery: ${order['delivery_time']}",
                style: TextStyle(
                  color: TColor.secondaryText,
                  fontSize: 14,
                ),
              ),
            ],
          ),

          if (order['customer_note'] != null &&
              order['customer_note'].isNotEmpty) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.yellow.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.note, size: 16, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Note: ${order['customer_note']}",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          if (showTimer) ...[
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text(
                    "Estimated completion: ${order['estimated_completion']}",
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 15),

          // Action Buttons
          Row(
            children: actions.map((action) {
              final index = actions.indexOf(action);
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: index < actions.length - 1 ? 10 : 0,
                  ),
                  child: action,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, Color color, VoidCallback onPressed) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  void _acceptOrder(Map<String, dynamic> order) {
    setState(() {
      newOrders.remove(order);
      order['started_time'] = DateTime.now().toString();
      order['estimated_completion'] =
          DateTime.now().add(const Duration(minutes: 25)).toString();
      cookingOrders.add(order);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Order #${order['id']} accepted and started cooking!")),
    );
  }

  void _rejectOrder(Map<String, dynamic> order) {
    setState(() {
      newOrders.remove(order);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order #${order['id']} rejected")),
    );
  }

  void _markOrderReady(Map<String, dynamic> order) {
    setState(() {
      cookingOrders.remove(order);
      order['completed_time'] = DateTime.now().toString();
      readyOrders.add(order);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order #${order['id']} is ready for pickup!")),
    );
  }

  void _addCookingTime(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Add Cooking Time"),
        content: const Text("How many additional minutes do you need?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Additional time added")),
              );
            },
            child: const Text("Add 10 min"),
          ),
        ],
      ),
    );
  }

  void _markOrderDelivered(Map<String, dynamic> order) {
    setState(() {
      readyOrders.remove(order);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Order #${order['id']} marked as delivered!")),
    );
  }

  void _callCustomer(Map<String, dynamic> order) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text("Calling ${order['customer']} at ${order['phone']}")),
    );
  }
}
