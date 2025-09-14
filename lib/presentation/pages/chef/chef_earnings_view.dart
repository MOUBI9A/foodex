import 'package:flutter/material.dart';
import 'package:food_delivery/core/theme/color_extension.dart';

class ChefEarningsView extends StatefulWidget {
  const ChefEarningsView({super.key});

  @override
  State<ChefEarningsView> createState() => _ChefEarningsViewState();
}

class _ChefEarningsViewState extends State<ChefEarningsView>
    with TickerProviderStateMixin {
  late TabController _tabController;
  String selectedPeriod = "Today";

  final Map<String, Map<String, dynamic>> earningsData = {
    "Today": {
      "total": 125.50,
      "orders": 12,
      "average_order": 10.46,
      "peak_hour": "7:00 PM",
      "breakdown": [
        {"time": "12:00 PM", "amount": 25.50, "orders": 2},
        {"time": "1:00 PM", "amount": 35.00, "orders": 3},
        {"time": "6:00 PM", "amount": 45.00, "orders": 4},
        {"time": "7:00 PM", "amount": 20.00, "orders": 3},
      ],
    },
    "This Week": {
      "total": 850.75,
      "orders": 68,
      "average_order": 12.51,
      "peak_day": "Saturday",
      "breakdown": [
        {"day": "Monday", "amount": 95.50, "orders": 8},
        {"day": "Tuesday", "amount": 110.25, "orders": 9},
        {"day": "Wednesday", "amount": 85.00, "orders": 7},
        {"day": "Thursday", "amount": 125.50, "orders": 12},
        {"day": "Friday", "amount": 145.00, "orders": 11},
        {"day": "Saturday", "amount": 165.50, "orders": 13},
        {"day": "Sunday", "amount": 124.00, "orders": 8},
      ],
    },
    "This Month": {
      "total": 3420.80,
      "orders": 285,
      "average_order": 12.00,
      "peak_week": "Week 3",
      "breakdown": [
        {"week": "Week 1", "amount": 820.50, "orders": 68},
        {"week": "Week 2", "amount": 950.25, "orders": 78},
        {"week": "Week 3", "amount": 1050.00, "orders": 85},
        {"week": "Week 4", "amount": 600.05, "orders": 54},
      ],
    },
  };

  final List<Map<String, dynamic>> recentTransactions = [
    {
      "order_id": "CM001",
      "customer": "John Smith",
      "amount": 25.50,
      "commission": 2.55,
      "net_amount": 22.95,
      "time": "2:30 PM",
      "status": "completed",
    },
    {
      "order_id": "CM002",
      "customer": "Emma Wilson",
      "amount": 15.75,
      "commission": 1.58,
      "net_amount": 14.17,
      "time": "1:45 PM",
      "status": "completed",
    },
    {
      "order_id": "CM003",
      "customer": "Mike Johnson",
      "amount": 32.80,
      "commission": 3.28,
      "net_amount": 29.52,
      "time": "12:15 PM",
      "status": "pending",
    },
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentData = earningsData[selectedPeriod]!;

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
                        "Earnings",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      IconButton(
                        onPressed: () => _showEarningsSettings(),
                        icon: const Icon(
                          Icons.settings,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Period Selector
                  Row(
                    children:
                        ["Today", "This Week", "This Month"].map((period) {
                      final isSelected = selectedPeriod == period;
                      return Expanded(
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedPeriod = period;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 5),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? Colors.white
                                  : Colors.white.withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              period,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color:
                                    isSelected ? TColor.primary : Colors.white,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 20),

                  // Total Earnings Display
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "\$${currentData['total'].toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "Total Earnings ($selectedPeriod)",
                          style: TextStyle(
                            color: TColor.secondaryText,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 15),
                        Row(
                          children: [
                            Expanded(
                              child: _buildEarningStat(
                                "Orders",
                                "${currentData['orders']}",
                                Icons.receipt_long,
                              ),
                            ),
                            Container(
                              width: 1,
                              height: 40,
                              color: TColor.placeholder.withValues(alpha: 0.3),
                            ),
                            Expanded(
                              child: _buildEarningStat(
                                "Avg. Order",
                                "\$${currentData['average_order'].toStringAsFixed(2)}",
                                Icons.trending_up,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Content Tabs
            Container(
              height: 50,
              margin: const EdgeInsets.symmetric(horizontal: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TabBar(
                controller: _tabController,
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
                tabs: const [
                  Tab(text: "Overview"),
                  Tab(text: "Transactions"),
                  Tab(text: "Analytics"),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildOverviewTab(currentData),
                  _buildTransactionsTab(),
                  _buildAnalyticsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningStat(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: TColor.primary, size: 20),
        const SizedBox(height: 5),
        Text(
          value,
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 16,
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
    );
  }

  Widget _buildOverviewTab(Map<String, dynamic> data) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breakdown Chart Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Earnings Breakdown",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                ...data['breakdown'].map<Widget>((item) {
                  final String label = item.keys.first;
                  final String labelValue = item[label];
                  final double amount = item['amount'];
                  final int orders = item['orders'];
                  final double percentage = (amount / data['total']) * 100;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 15),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              labelValue,
                              style: TextStyle(
                                color: TColor.primaryText,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              "\$${amount.toStringAsFixed(2)} ($orders orders)",
                              style: TextStyle(
                                color: TColor.primary,
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 5),
                        LinearProgressIndicator(
                          value: percentage / 100,
                          backgroundColor: Colors.grey[200],
                          valueColor:
                              AlwaysStoppedAnimation<Color>(TColor.primary),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Quick Actions
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
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
                      child: _buildActionCard(
                        "Withdraw",
                        "Transfer to bank",
                        Icons.account_balance,
                        Colors.green,
                        () => _showWithdrawDialog(),
                      ),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildActionCard(
                        "Tax Report",
                        "Download summary",
                        Icons.description,
                        Colors.blue,
                        () => _downloadTaxReport(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildTransactionsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Recent Transactions",
                style: TextStyle(
                  color: TColor.primaryText,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text(
                  "View All",
                  style: TextStyle(
                    color: TColor.primary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          ...recentTransactions
              .map((transaction) => _buildTransactionCard(transaction)),
        ],
      ),
    );
  }

  Widget _buildAnalyticsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          // Performance Metrics
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Performance Metrics",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard("Acceptance Rate", "95%",
                          Icons.check_circle, Colors.green),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildMetricCard("Avg. Prep Time", "22 min",
                          Icons.timer, Colors.orange),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricCard(
                          "Customer Rating", "4.9 ⭐", Icons.star, Colors.amber),
                    ),
                    const SizedBox(width: 15),
                    Expanded(
                      child: _buildMetricCard("Repeat Customers", "68%",
                          Icons.refresh, Colors.blue),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Goals Section
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Monthly Goals",
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 15),
                _buildGoalProgress("Earnings Goal", 3420.80, 4000.00),
                const SizedBox(height: 15),
                _buildGoalProgress("Orders Goal", 285, 350),
              ],
            ),
          ),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildActionCard(String title, String subtitle, IconData icon,
      Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 30),
            const SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subtitle,
              style: TextStyle(
                color: TColor.secondaryText,
                fontSize: 12,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction) {
    final isCompleted = transaction['status'] == 'completed';

    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: isCompleted
                  ? Colors.green.withValues(alpha: 0.1)
                  : Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Icon(
              isCompleted ? Icons.check_circle : Icons.access_time,
              color: isCompleted ? Colors.green : Colors.orange,
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order #${transaction['order_id']}",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      transaction['time'],
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  transaction['customer'],
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Net: \$${transaction['net_amount'].toStringAsFixed(2)}",
                      style: TextStyle(
                        color: TColor.primary,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      "Fee: \$${transaction['commission'].toStringAsFixed(2)}",
                      style: TextStyle(
                        color: TColor.secondaryText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
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
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            title,
            style: TextStyle(
              color: TColor.secondaryText,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildGoalProgress(String title, double current, double target) {
    final progress = current / target;
    final isEarnings = title.contains("Earnings");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                color: TColor.primaryText,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              "${isEarnings ? '\$' : ''}${current.toStringAsFixed(isEarnings ? 2 : 0)} / ${isEarnings ? '\$' : ''}${target.toStringAsFixed(isEarnings ? 2 : 0)}",
              style: TextStyle(
                color: TColor.primary,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: progress.clamp(0.0, 1.0),
          backgroundColor: Colors.grey[200],
          valueColor: AlwaysStoppedAnimation<Color>(
            progress >= 1.0 ? Colors.green : TColor.primary,
          ),
        ),
      ],
    );
  }

  void _showEarningsSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Earnings Settings",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: TColor.primaryText,
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.account_balance),
              title: const Text("Banking Details"),
              subtitle: const Text("Manage withdrawal accounts"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: const Text("Payment Notifications"),
              subtitle: const Text("Configure earning alerts"),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text("Tax Information"),
              subtitle: const Text("Update tax details"),
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  void _showWithdrawDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Withdraw Earnings"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
                "Available balance: \$${earningsData[selectedPeriod]!['total'].toStringAsFixed(2)}"),
            const SizedBox(height: 15),
            const TextField(
              decoration: InputDecoration(
                labelText: "Withdrawal Amount",
                border: OutlineInputBorder(),
                prefixText: "\$",
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Withdrawal request submitted!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColor.primary,
              foregroundColor: Colors.white,
            ),
            child: const Text("Withdraw"),
          ),
        ],
      ),
    );
  }

  void _downloadTaxReport() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Tax report downloaded successfully!")),
    );
  }
}
