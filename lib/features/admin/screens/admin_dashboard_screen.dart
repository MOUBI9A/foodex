import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/dashboard_provider.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final data = ref.watch(dashboardOverviewProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Admin Dashboard')),
      body: data.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (ov) => GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16),
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [
            _StatCard(title: 'Active Orders', value: ov.activeOrders.toString(), color: Colors.orange),
            _StatCard(title: 'Customers', value: ov.totalCustomers.toString(), color: Colors.blue),
            _StatCard(title: 'Revenue Today', value: '\$${ov.revenueToday.toStringAsFixed(2)}', color: Colors.green),
            _StatCard(title: 'Revenue This Month', value: '\$${ov.revenueThisMonth.toStringAsFixed(2)}', color: Colors.purple),
          ],
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final Color color;
  const _StatCard({required this.title, required this.value, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(title, style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.headlineSmall?.copyWith(color: color, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }
}
