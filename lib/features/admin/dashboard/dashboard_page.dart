import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/admin/common/theme/admin_theme.dart';
import 'package:food_delivery/features/admin/dashboard/data/dashboard_metrics_provider.dart';
import 'package:food_delivery/features/admin/dashboard/widgets/app_sidebar.dart';
import 'package:food_delivery/features/admin/dashboard/widgets/metric_card.dart';
import 'package:food_delivery/features/admin/dashboard/widgets/orders_status_summary.dart';
import 'package:food_delivery/features/admin/dashboard/widgets/quick_actions_bar.dart';
import 'package:food_delivery/features/admin/dashboard/widgets/revenue_chart.dart';
import 'package:food_delivery/features/admin/dashboard/widgets/top_chefs_table.dart';

/// Admin Dashboard Page
///
/// Main container for the admin dashboard with responsive layout.
/// Features:
/// - Top navbar with logo, dark/light toggle, and profile
/// - Sidebar navigation (NavigationRail on desktop, Drawer on mobile)
/// - Responsive grid layout (4 columns desktop, 1 column mobile)
/// - Real-time metrics, charts, tables, and quick actions
class DashboardPage extends ConsumerStatefulWidget {
  const DashboardPage({super.key});

  @override
  ConsumerState<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends ConsumerState<DashboardPage> {
  int _selectedNavIndex = 0;
  ThemeMode _themeMode = ThemeMode.light;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(dashboardMetricsProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: AdminTheme.lightTheme,
      darkTheme: AdminTheme.darkTheme,
      themeMode: _themeMode,
      home: LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = constraints.maxWidth < 900;
          final isTablet =
              constraints.maxWidth >= 900 && constraints.maxWidth < 1200;

          return Scaffold(
            key: _scaffoldKey,
            appBar: _buildAppBar(isMobile),
            drawer: isMobile
                ? AppSidebar(
                    isMobile: true,
                    selectedIndex: _selectedNavIndex,
                    onDestinationSelected: (index) {
                      setState(() => _selectedNavIndex = index);
                    },
                  )
                : null,
            body: Row(
              children: [
                // Sidebar (desktop only)
                if (!isMobile)
                  AppSidebar(
                    isMobile: false,
                    selectedIndex: _selectedNavIndex,
                    onDestinationSelected: (index) {
                      setState(() => _selectedNavIndex = index);
                    },
                  ),

                // Main Content
                Expanded(
                  child: _buildDashboardContent(
                    metrics: metrics,
                    isMobile: isMobile,
                    isTablet: isTablet,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(bool isMobile) {
    final isDark = _themeMode == ThemeMode.dark;

    return AppBar(
      leading: isMobile
          ? IconButton(
              icon: const Icon(Icons.menu),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            )
          : null,
      title: Row(
        children: [
          if (!isMobile) ...[
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: AdminTheme.primaryOrange,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.restaurant_menu,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
          ],
          const Text(
            'FoodEx Admin',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      actions: [
        // Theme Toggle
        IconButton(
          icon: Icon(
            isDark ? Icons.light_mode : Icons.dark_mode,
          ),
          onPressed: () {
            setState(() {
              _themeMode = _themeMode == ThemeMode.light
                  ? ThemeMode.dark
                  : ThemeMode.light;
            });
          },
          tooltip: isDark ? 'Light Mode' : 'Dark Mode',
        ),

        // Notifications
        IconButton(
          icon: Stack(
            children: [
              const Icon(Icons.notifications_outlined),
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: AdminTheme.errorRed,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(
                    minWidth: 8,
                    minHeight: 8,
                  ),
                ),
              ),
            ],
          ),
          onPressed: () {
            // TODO: Show notifications
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications: 3 new items'),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          tooltip: 'Notifications',
        ),

        // Profile
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: PopupMenuButton<String>(
            offset: const Offset(0, 50),
            itemBuilder: (context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'profile',
                child: Row(
                  children: [
                    Icon(Icons.person_outline, size: 20),
                    SizedBox(width: 12),
                    Text('Profile'),
                  ],
                ),
              ),
              const PopupMenuItem<String>(
                value: 'settings',
                child: Row(
                  children: [
                    Icon(Icons.settings_outlined, size: 20),
                    SizedBox(width: 12),
                    Text('Settings'),
                  ],
                ),
              ),
              const PopupMenuDivider(),
              const PopupMenuItem<String>(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, size: 20, color: AdminTheme.errorRed),
                    SizedBox(width: 12),
                    Text('Logout',
                        style: TextStyle(color: AdminTheme.errorRed)),
                  ],
                ),
              ),
            ],
            onSelected: (value) {
              // TODO: Handle menu actions
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$value clicked'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: CircleAvatar(
              radius: 18,
              backgroundColor: AdminTheme.primaryOrange.withOpacity(0.1),
              child: const Text(
                'AD',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AdminTheme.primaryOrange,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildDashboardContent({
    required DashboardMetrics metrics,
    required bool isMobile,
    required bool isTablet,
  }) {
    final crossAxisCount = isMobile ? 1 : (isTablet ? 2 : 4);

    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Page Header
            _buildPageHeader(isMobile),
            SizedBox(height: isMobile ? 16 : 24),

            // Metric Cards Grid
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: isMobile ? 2.5 : (isTablet ? 2 : 1.8),
              children: [
                MetricCard(
                  label: 'Total Orders',
                  value: metrics.totalOrders.toString(),
                  icon: Icons.shopping_bag,
                  iconColor: AdminTheme.infoBlue,
                  growthPercentage: metrics.ordersGrowth,
                ),
                MetricCard(
                  label: 'Revenue',
                  value: '\$${metrics.totalRevenue.toStringAsFixed(2)}',
                  icon: Icons.attach_money,
                  iconColor: AdminTheme.successGreen,
                  growthPercentage: metrics.revenueGrowth,
                ),
                MetricCard(
                  label: 'Active Chefs',
                  value: metrics.activeChefs.toString(),
                  icon: Icons.restaurant,
                  iconColor: AdminTheme.warningYellow,
                  growthPercentage: metrics.chefsGrowth,
                ),
                MetricCard(
                  label: 'Active Couriers',
                  value: metrics.activeCouriers.toString(),
                  icon: Icons.delivery_dining,
                  iconColor: AdminTheme.primaryOrange,
                  growthPercentage: metrics.couriersGrowth,
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Revenue Chart
            const RevenueChart(),
            const SizedBox(height: 24),

            // Quick Actions Bar
            const QuickActionsBar(),
            const SizedBox(height: 24),

            // Two Column Layout (Desktop & Tablet)
            if (!isMobile)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top Chefs Table
                  const Expanded(
                    flex: 3,
                    child: TopChefsTable(),
                  ),
                  const SizedBox(width: 24),

                  // Orders Status Summary
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: const [
                        OrdersStatusSummary(),
                      ],
                    ),
                  ),
                ],
              )
            else ...[
              // Single Column Layout (Mobile)
              const TopChefsTable(),
              const SizedBox(height: 24),
              const OrdersStatusSummary(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPageHeader(bool isMobile) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Dashboard',
          style: TextStyle(
            fontSize: isMobile ? 24 : 32,
            fontWeight: FontWeight.w700,
            color: isDark ? Colors.white : AdminTheme.darkGray,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(
              Icons.access_time,
              size: 16,
              color: AdminTheme.gray600,
            ),
            const SizedBox(width: 8),
            Text(
              'Last updated: ${_formatLastUpdated()}',
              style: TextStyle(
                fontSize: 14,
                color: AdminTheme.gray600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatLastUpdated() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }
}
