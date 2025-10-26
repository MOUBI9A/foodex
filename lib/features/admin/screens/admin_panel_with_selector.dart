// AdminPanelWithSelector: Admin panel with dynamic page selector/navigator.
// Allows admin to navigate to any customer/chef/admin page from dropdown.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';
import '../providers/dashboard_provider.dart';
import '../providers/admin_navigation_provider.dart';

class AdminPanelWithSelector extends ConsumerWidget {
  const AdminPanelWithSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardAsync = ref.watch(dashboardOverviewProvider);
    final selectedPage = ref.watch(adminSelectedPageProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Control Panel', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.local_shipping_outlined),
            tooltip: 'Assignations',
            onPressed: () => context.go(AppRouteNames.adminDeliveries),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Dashboard',
            onPressed: () {
              ref.invalidate(dashboardOverviewProvider);
            },
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: Row(
        children: [
          // Sidebar Navigation
          _AdminSidebar(selectedPage: selectedPage),
          
          // Main Content
          Expanded(
            child: Container(
              color: Colors.grey[50],
              child: Column(
                children: [
                  // Page Selector Dropdown Bar
                  _PageSelectorBar(),
                  
                  // Dashboard Content
                  Expanded(
                    child: dashboardAsync.when(
                      loading: () => const Center(child: CircularProgressIndicator()),
                      error: (e, st) => Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                            const SizedBox(height: AppSpacing.lg),
                            Text('Error loading dashboard: $e', style: const TextStyle(color: Colors.red)),
                            const SizedBox(height: AppSpacing.lg),
                            ElevatedButton.icon(
                              onPressed: () => ref.invalidate(dashboardOverviewProvider),
                              icon: const Icon(Icons.refresh),
                              label: const Text('Retry'),
                            ),
                          ],
                        ),
                      ),
                      data: (overview) => SingleChildScrollView(
                        padding: const EdgeInsets.all(AppSpacing.xl),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Stats Grid
                            _DashboardStatsGrid(overview: overview),
                            
                            const SizedBox(height: AppSpacing.xl),
                            
                            // Quick Actions
                            _QuickActionsSection(),
                            
                            const SizedBox(height: AppSpacing.xl),
                            
                            // Recent Activity
                            _RecentActivitySection(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AdminSidebar extends ConsumerWidget {
  final String selectedPage;
  
  const _AdminSidebar({required this.selectedPage});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: 250,
      color: const Color(0xFF1E1E2D),
      child: Column(
        children: [
          // Logo/Brand
          Container(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: AppColors.primary,
                  child: const Icon(Icons.admin_panel_settings, size: 40, color: Colors.white),
                ),
                const SizedBox(height: AppSpacing.md),
                const Text(
                  'FOODEx Admin',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const Text(
                  'Control Center',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          
          const Divider(color: Colors.white24),
          
          // Navigation Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
              children: [
                _SidebarItem(
                  icon: Icons.dashboard,
                  title: 'Dashboard',
                  isSelected: selectedPage == 'dashboard',
                  onTap: () => ref.read(adminSelectedPageProvider.notifier).state = 'dashboard',
                ),
                _SidebarItem(
                  icon: Icons.people,
                  title: 'Users',
                  isSelected: selectedPage == 'users',
                  onTap: () => ref.read(adminSelectedPageProvider.notifier).state = 'users',
                ),
                _SidebarItem(
                  icon: Icons.restaurant,
                  title: 'Chefs',
                  isSelected: selectedPage == 'chefs',
                  onTap: () => ref.read(adminSelectedPageProvider.notifier).state = 'chefs',
                ),
                _SidebarItem(
                  icon: Icons.shopping_bag,
                  title: 'Orders',
                  isSelected: selectedPage == 'orders',
                  onTap: () => ref.read(adminSelectedPageProvider.notifier).state = 'orders',
                ),
                _SidebarItem(
                  icon: Icons.analytics,
                  title: 'Analytics',
                  isSelected: selectedPage == 'analytics',
                  onTap: () => ref.read(adminSelectedPageProvider.notifier).state = 'analytics',
                ),
                _SidebarItem(
                  icon: Icons.inventory,
                  title: 'Inventory',
                  isSelected: selectedPage == 'inventory',
                  onTap: () => ref.read(adminSelectedPageProvider.notifier).state = 'inventory',
                ),
                _SidebarItem(
                  icon: Icons.settings,
                  title: 'Settings',
                  isSelected: selectedPage == 'settings',
                  onTap: () => ref.read(adminSelectedPageProvider.notifier).state = 'settings',
                ),
              ],
            ),
          ),
          
          const Divider(color: Colors.white24),
          
          // Logout
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.white70),
            title: const Text('Logout', style: TextStyle(color: Colors.white70)),
            onTap: () => context.go(AppRouteNames.selectUser),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _SidebarItem({
    required this.icon,
    required this.title,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primary.withValues(alpha: 0.2) : Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: ListTile(
        leading: Icon(icon, color: isSelected ? AppColors.primary : Colors.white70),
        title: Text(
          title,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

class _PageSelectorBar extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedRoute = ref.watch(adminNavigationRouteProvider);
    
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
            Icon(Icons.screen_share, color: AppColors.primary),
          const SizedBox(width: AppSpacing.md),
          const Text(
            'Navigate to:',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
          const SizedBox(width: AppSpacing.lg),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(AppRadius.md),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedRoute,
                  isExpanded: true,
                  icon: const Icon(Icons.arrow_drop_down),
                  items: _navigationOptions.map((opt) {
                    return DropdownMenuItem<String>(
                      value: opt['route'],
                      child: Row(
                        children: [
                          Icon(opt['icon'] as IconData, size: 20, color: AppColors.primary),
                          const SizedBox(width: AppSpacing.sm),
                          Text(opt['label'] as String),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: (opt['color'] as Color).withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              opt['category'] as String,
                              style: TextStyle(
                                fontSize: 10,
                                color: opt['color'] as Color,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null && value != selectedRoute) {
                      ref.read(adminNavigationRouteProvider.notifier).state = value;
                      context.push(value);
                    }
                  },
                ),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          ElevatedButton.icon(
            onPressed: () {
              final route = ref.read(adminNavigationRouteProvider);
              context.push(route);
            },
            icon: const Icon(Icons.open_in_new, size: 18),
            label: const Text('Go'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }
}

final List<Map<String, dynamic>> _navigationOptions = [
  // Admin
  {'label': 'Admin Dashboard', 'route': AppRouteNames.adminDashboard, 'icon': Icons.dashboard, 'category': 'Admin', 'color': Colors.purple},
  
  // Customer Pages
  {'label': 'Customer Home', 'route': AppRouteNames.customerHome, 'icon': Icons.home, 'category': 'Customer', 'color': Colors.blue},
  {'label': 'Taste Profile', 'route': AppRouteNames.customerTasteProfile, 'icon': Icons.favorite, 'category': 'Customer', 'color': Colors.blue},
  {'label': 'Recommendations', 'route': AppRouteNames.customerRecommendations, 'icon': Icons.recommend, 'category': 'Customer', 'color': Colors.blue},
  
  // Chef Pages
  {'label': 'Chef Dashboard', 'route': AppRouteNames.chef, 'icon': Icons.restaurant_menu, 'category': 'Chef', 'color': Colors.orange},
  {'label': 'Chef Inventory', 'route': AppRouteNames.chefInventory, 'icon': Icons.inventory_2, 'category': 'Chef', 'color': Colors.orange},
  
  // Driver
  {'label': 'Driver Dashboard', 'route': AppRouteNames.driver, 'icon': Icons.delivery_dining, 'category': 'Driver', 'color': Colors.green},
];

class _DashboardStatsGrid extends StatelessWidget {
  final dynamic overview;
  
  const _DashboardStatsGrid({required this.overview});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 4,
      crossAxisSpacing: AppSpacing.lg,
      mainAxisSpacing: AppSpacing.lg,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.5,
      children: [
        _StatCard(
          title: 'Active Orders',
          value: overview.activeOrders.toString(),
          icon: Icons.shopping_bag,
          color: Colors.orange,
          trend: '+12%',
          trendUp: true,
        ),
        _StatCard(
          title: 'Total Customers',
          value: overview.totalCustomers.toString(),
          icon: Icons.people,
          color: Colors.blue,
          trend: '+8%',
          trendUp: true,
        ),
        _StatCard(
          title: 'Revenue Today',
          value: '\$${overview.revenueToday.toStringAsFixed(0)}',
          icon: Icons.attach_money,
          color: Colors.green,
          trend: '+15%',
          trendUp: true,
        ),
        _StatCard(
          title: 'Monthly Revenue',
          value: '\$${overview.revenueThisMonth.toStringAsFixed(0)}',
          icon: Icons.trending_up,
          color: Colors.purple,
          trend: '+23%',
          trendUp: true,
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final String trend;
  final bool trendUp;
  
  const _StatCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.trend,
    required this.trendUp,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: (trendUp ? Colors.green : Colors.red).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      trendUp ? Icons.arrow_upward : Icons.arrow_downward,
                      size: 12,
                      color: trendUp ? Colors.green : Colors.red,
                    ),
                    const SizedBox(width: 2),
                    Text(
                      trend,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: trendUp ? Colors.green : Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickActionsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.lg),
        Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: [
            _ActionButton(
              icon: Icons.add_business,
              label: 'Add Chef',
              color: Colors.orange,
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.person_add,
              label: 'Add Customer',
              color: Colors.blue,
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.local_offer,
              label: 'Create Promotion',
              color: Colors.green,
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.email,
              label: 'Send Notification',
              color: Colors.purple,
              onTap: () {},
            ),
            _ActionButton(
              icon: Icons.download,
              label: 'Export Report',
              color: Colors.teal,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(color: Colors.grey[300]!),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class _RecentActivitySection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Activity',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.lg),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 5,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) => ListTile(
              leading: CircleAvatar(
                backgroundColor: _activityColors[index % _activityColors.length].withValues(alpha: 0.1),
                child: Icon(_activityIcons[index % _activityIcons.length], color: _activityColors[index % _activityColors.length], size: 20),
              ),
              title: Text(_activityTitles[index % _activityTitles.length], style: const TextStyle(fontWeight: FontWeight.w600)),
              subtitle: Text(_activitySubtitles[index % _activitySubtitles.length]),
              trailing: Text('${index + 1}m ago', style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ),
          ),
        ),
      ],
    );
  }
}

const _activityColors = [Colors.green, Colors.blue, Colors.orange, Colors.purple, Colors.red];
const _activityIcons = [Icons.check_circle, Icons.person_add, Icons.shopping_bag, Icons.restaurant, Icons.error];
const _activityTitles = [
  'Order #1234 completed',
  'New customer registered',
  'Order #1235 placed',
  'Chef menu updated',
  'Payment failed for Order #1236',
];
const _activitySubtitles = [
  'Customer: John Doe',
  'Email: jane@example.com',
  'Customer: Mike Smith',
  'Chef: Maria Garcia',
  'Customer: Sarah Johnson',
];
