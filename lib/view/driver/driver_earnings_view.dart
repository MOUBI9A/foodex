import 'package:flutter/material.dart';
import 'package:food_delivery/common/color_extension.dart';

class DriverEarningsView extends StatefulWidget {
  const DriverEarningsView({super.key});

  @override
  State<DriverEarningsView> createState() => _DriverEarningsViewState();
}

class _DriverEarningsViewState extends State<DriverEarningsView> {
  String selectedPeriod = "Today";

  List<String> periods = ["Today", "This Week", "This Month", "All Time"];

  Map<String, Map<String, dynamic>> earningsData = {
    "Today": {
      "totalEarnings": 45.50,
      "orders": 8,
      "hours": 5.5,
      "avgPerOrder": 5.69,
      "tips": 12.50,
      "basePay": 33.00,
    },
    "This Week": {
      "totalEarnings": 285.75,
      "orders": 42,
      "hours": 28.5,
      "avgPerOrder": 6.80,
      "tips": 78.25,
      "basePay": 207.50,
    },
    "This Month": {
      "totalEarnings": 1247.50,
      "orders": 186,
      "hours": 124.0,
      "avgPerOrder": 6.71,
      "tips": 345.50,
      "basePay": 902.00,
    },
    "All Time": {
      "totalEarnings": 5280.75,
      "orders": 798,
      "hours": 456.5,
      "avgPerOrder": 6.62,
      "tips": 1458.25,
      "basePay": 3822.50,
    },
  };

  List<Map<String, dynamic>> recentEarnings = [
    {
      "date": "Dec 13, 2024",
      "orders": 8,
      "earnings": 45.50,
      "hours": 5.5,
    },
    {
      "date": "Dec 12, 2024",
      "orders": 12,
      "earnings": 68.75,
      "hours": 7.0,
    },
    {
      "date": "Dec 11, 2024",
      "orders": 6,
      "earnings": 42.25,
      "hours": 4.5,
    },
    {
      "date": "Dec 10, 2024",
      "orders": 10,
      "earnings": 55.80,
      "hours": 6.5,
    },
    {
      "date": "Dec 9, 2024",
      "orders": 9,
      "earnings": 51.25,
      "hours": 6.0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    var currentData = earningsData[selectedPeriod]!;

    return Scaffold(
      backgroundColor: const Color(0xfff5f5f5),
      appBar: AppBar(
        backgroundColor: TColor.primary,
        elevation: 0,
        title: const Text(
          "Earnings",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Period Filter
            Container(
              color: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Row(
                children: periods.map((period) {
                  bool isSelected = selectedPeriod == period;
                  return Expanded(
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedPeriod = period;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 2),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? TColor.primary
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Text(
                          period,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : TColor.secondaryText,
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // Total Earnings Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                padding: const EdgeInsets.all(25),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [TColor.primary, TColor.primary.withOpacity(0.8)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: TColor.primary.withOpacity(0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      "Total Earnings",
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "\$${currentData["totalEarnings"].toStringAsFixed(2)}",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _buildEarningsStat("Orders", "${currentData["orders"]}",
                            Icons.receipt_long),
                        _buildEarningsStat("Hours", "${currentData["hours"]}h",
                            Icons.access_time),
                        _buildEarningsStat(
                            "Avg/Order",
                            "\$${currentData["avgPerOrder"].toStringAsFixed(2)}",
                            Icons.trending_up),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Earnings Breakdown
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
                      "Earnings Breakdown",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _buildBreakdownItem(
                      "Base Pay",
                      currentData["basePay"],
                      Icons.attach_money,
                      Colors.blue,
                    ),
                    const SizedBox(height: 15),
                    _buildBreakdownItem(
                      "Tips",
                      currentData["tips"],
                      Icons.favorite,
                      Colors.green,
                    ),
                    const SizedBox(height: 15),
                    Container(
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    const SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Total",
                          style: TextStyle(
                            color: TColor.primaryText,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        Text(
                          "\$${currentData["totalEarnings"].toStringAsFixed(2)}",
                          style: TextStyle(
                            color: TColor.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // Recent Earnings History
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
                      "Recent Days",
                      style: TextStyle(
                        color: TColor.primaryText,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 15),
                    ...recentEarnings
                        .map((earning) => _buildEarningHistoryItem(earning)),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  Widget _buildEarningsStat(String title, String value, IconData icon) {
    return Column(
      children: [
        Icon(icon, color: Colors.white70, size: 24),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          title,
          style: TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildBreakdownItem(
      String title, double amount, IconData icon, Color color) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(icon, color: color, size: 20),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Text(
            title,
            style: TextStyle(
              color: TColor.primaryText,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          "\$${amount.toStringAsFixed(2)}",
          style: TextStyle(
            color: TColor.primaryText,
            fontSize: 16,
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }

  Widget _buildEarningHistoryItem(Map<String, dynamic> earning) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  earning["date"],
                  style: TextStyle(
                    color: TColor.primaryText,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "${earning["orders"]} orders • ${earning["hours"]}h",
                  style: TextStyle(
                    color: TColor.secondaryText,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          Text(
            "\$${earning["earnings"].toStringAsFixed(2)}",
            style: TextStyle(
              color: TColor.primary,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
