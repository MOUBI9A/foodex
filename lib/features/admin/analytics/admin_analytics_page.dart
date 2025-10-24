import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';

/// Admin Analytics Page
///
/// Advanced analytics dashboard with charts and insights.
/// Provides deep insights into platform performance, user behavior, and business metrics.
///
/// Features:
/// - Revenue analytics (daily, weekly, monthly, yearly)
/// - User growth charts (new users, active users, retention)
/// - Order analytics (volume, average value, completion rate)
/// - Chef performance metrics (orders, ratings, revenue)
/// - Geographic distribution maps
/// - Time-based trends (peak hours, seasonal patterns)
/// - Export analytics data to Excel/CSV
/// - Date range picker for custom periods
/// - Multiple chart types (line, bar, pie, donut)
///
/// Layout:
/// ┌────────────────────────────────────────┐
/// │ Analytics (title)  [Date Range Picker] │
/// ├────────────────────────────────────────┤
/// │ [Revenue Card] [Orders Card] [Users]   │  ← Summary Cards
/// ├──────────────────┬─────────────────────┤
/// │                  │                     │
/// │  Revenue Chart   │   Order Chart       │  ← Row 1
/// │  (Line)          │   (Bar)             │
/// ├──────────────────┼─────────────────────┤
/// │                  │                     │
/// │  User Growth     │   Top Chefs         │  ← Row 2
/// │  (Area)          │   (Table)           │
/// └──────────────────┴─────────────────────┘
///
/// State Management:
/// - Analytics data (Riverpod AsyncValue)
/// - Date range (local state)
/// - Chart selections (local state)
///
/// API Integration:
/// - GET /api/admin/analytics/revenue
/// - GET /api/admin/analytics/orders
/// - GET /api/admin/analytics/users
/// - GET /api/admin/analytics/chefs
class AdminAnalyticsPage extends ConsumerStatefulWidget {
  const AdminAnalyticsPage({super.key});

  @override
  ConsumerState<AdminAnalyticsPage> createState() => _AdminAnalyticsPageState();
}

class _AdminAnalyticsPageState extends ConsumerState<AdminAnalyticsPage> {
  // Date range state
  DateTimeRange _dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  /// Pick custom date range
  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
      });
      // TODO: Trigger API call with new date range
    }
  }

  /// Export analytics data
  void _exportData() {
    // TODO: Implement export to CSV/Excel
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Exporting analytics data...')),
    );
  }

  @override
  Widget build(BuildContext context) {
    // final theme = Theme.of(context); // Reserved for theme-based styling

    // TODO: Fetch analytics data from providers
    // final revenueData = ref.watch(revenueAnalyticsProvider(_dateRange));
    // final ordersData = ref.watch(ordersAnalyticsProvider(_dateRange));
    // final usersData = ref.watch(usersAnalyticsProvider(_dateRange));

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with date range picker
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Analytics',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    OutlinedButton.icon(
                      onPressed: _exportData,
                      icon: const Icon(Icons.download),
                      label: const Text('Export'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      onPressed: _pickDateRange,
                      icon: const Icon(Icons.date_range),
                      label: Text(
                        '${_dateRange.start.toString().split(' ')[0]} - ${_dateRange.end.toString().split(' ')[0]}',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Summary cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Revenue',
                    '\$125,432',
                    '+12.5%',
                    Colors.green,
                    Icons.trending_up,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Orders',
                    '3,456',
                    '+8.2%',
                    Colors.blue,
                    Icons.shopping_bag,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Active Users',
                    '12,890',
                    '+15.3%',
                    Colors.purple,
                    Icons.people,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildSummaryCard(
                    'Avg Order Value',
                    '\$36.28',
                    '+5.1%',
                    Colors.orange,
                    Icons.attach_money,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Charts row 1
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Revenue chart
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Revenue Trend',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: _buildRevenueChart(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Orders chart
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Order Volume',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: _buildOrdersChart(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Charts row 2
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // User growth chart
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'User Growth',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: _buildUserGrowthChart(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),

                // Top chefs table
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Top Performing Chefs',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          SizedBox(
                            height: 300,
                            child: _buildTopChefsTable(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build summary card
  Widget _buildSummaryCard(
    String title,
    String value,
    String change,
    Color color,
    IconData icon,
  ) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
                Icon(icon, color: color, size: 24),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              value,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(
                  change.startsWith('+')
                      ? Icons.trending_up
                      : Icons.trending_down,
                  color: change.startsWith('+') ? Colors.green : Colors.red,
                  size: 16,
                ),
                const SizedBox(width: 4),
                Text(
                  change,
                  style: TextStyle(
                    color: change.startsWith('+') ? Colors.green : Colors.red,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  'vs last period',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// Build revenue line chart
  Widget _buildRevenueChart() {
    // TODO: Replace with real data
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 3),
              const FlSpot(1, 4),
              const FlSpot(2, 3.5),
              const FlSpot(3, 5),
              const FlSpot(4, 4.5),
              const FlSpot(5, 6),
              const FlSpot(6, 5.5),
            ],
            isCurved: true,
            color: Colors.blue,
            barWidth: 3,
            dotData: const FlDotData(show: true),
          ),
        ],
      ),
    );
  }

  /// Build orders bar chart
  Widget _buildOrdersChart() {
    // TODO: Replace with real data
    return BarChart(
      BarChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        barGroups: [
          BarChartGroupData(
              x: 0, barRods: [BarChartRodData(toY: 8, color: Colors.blue)]),
          BarChartGroupData(
              x: 1, barRods: [BarChartRodData(toY: 10, color: Colors.blue)]),
          BarChartGroupData(
              x: 2, barRods: [BarChartRodData(toY: 7, color: Colors.blue)]),
          BarChartGroupData(
              x: 3, barRods: [BarChartRodData(toY: 12, color: Colors.blue)]),
          BarChartGroupData(
              x: 4, barRods: [BarChartRodData(toY: 9, color: Colors.blue)]),
          BarChartGroupData(
              x: 5, barRods: [BarChartRodData(toY: 14, color: Colors.blue)]),
        ],
      ),
    );
  }

  /// Build user growth area chart
  Widget _buildUserGrowthChart() {
    // TODO: Replace with real data
    return LineChart(
      LineChartData(
        gridData: const FlGridData(show: true),
        titlesData: const FlTitlesData(show: true),
        borderData: FlBorderData(show: true),
        lineBarsData: [
          LineChartBarData(
            spots: [
              const FlSpot(0, 2),
              const FlSpot(1, 2.5),
              const FlSpot(2, 3),
              const FlSpot(3, 3.5),
              const FlSpot(4, 4.2),
              const FlSpot(5, 5),
              const FlSpot(6, 5.8),
            ],
            isCurved: true,
            color: Colors.purple,
            barWidth: 3,
            dotData: const FlDotData(show: true),
            belowBarData: BarAreaData(
              show: true,
              color: Colors.purple.withValues(alpha: 0.3),
            ),
          ),
        ],
      ),
    );
  }

  /// Build top chefs table
  Widget _buildTopChefsTable() {
    // TODO: Replace with real data
    return ListView.separated(
      itemCount: 5,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        return ListTile(
          leading: CircleAvatar(
            backgroundColor: Colors.primaries[index % Colors.primaries.length],
            child: Text('${index + 1}'),
          ),
          title: Text('Chef ${index + 1}'),
          subtitle: Text('${100 - index * 10} orders'),
          trailing: Text(
            '\$${5000 - index * 500}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        );
      },
    );
  }
}
