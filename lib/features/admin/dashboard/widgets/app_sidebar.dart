import 'package:flutter/material.dart';
import 'package:food_delivery/features/admin/common/theme/admin_theme.dart';

/// Admin App Sidebar Widget
///
/// Navigation sidebar with menu items, logo, and profile section.
/// Uses NavigationRail for desktop, Drawer for mobile.
class AppSidebar extends StatefulWidget {
  final bool isMobile;
  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  const AppSidebar({
    super.key,
    this.isMobile = false,
    this.selectedIndex = 0,
    required this.onDestinationSelected,
  });

  @override
  State<AppSidebar> createState() => _AppSidebarState();
}

class _AppSidebarState extends State<AppSidebar> {
  int? _hoveredIndex;

  final List<NavigationItem> _navigationItems = [
    NavigationItem(
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
      label: 'Dashboard',
    ),
    NavigationItem(
      icon: Icons.people_outline,
      activeIcon: Icons.people,
      label: 'Users',
    ),
    NavigationItem(
      icon: Icons.restaurant_outlined,
      activeIcon: Icons.restaurant,
      label: 'Chefs',
    ),
    NavigationItem(
      icon: Icons.shopping_bag_outlined,
      activeIcon: Icons.shopping_bag,
      label: 'Orders',
    ),
    NavigationItem(
      icon: Icons.local_offer_outlined,
      activeIcon: Icons.local_offer,
      label: 'Offers',
    ),
    NavigationItem(
      icon: Icons.analytics_outlined,
      activeIcon: Icons.analytics,
      label: 'Analytics',
    ),
    NavigationItem(
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
      label: 'Settings',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    if (widget.isMobile) {
      return _buildDrawer();
    } else {
      return _buildNavigationRail();
    }
  }

  Widget _buildDrawer() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Drawer(
      child: Container(
        color: isDark ? AdminTheme.gray900 : Colors.white,
        child: Column(
          children: [
            // Logo Section
            _buildLogoSection(isMobile: true),
            const Divider(),

            // Navigation Items
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _navigationItems.length,
                itemBuilder: (context, index) {
                  return _buildDrawerItem(index);
                },
              ),
            ),

            // Profile Section
            const Divider(),
            _buildProfileSection(isMobile: true),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationRail() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 280,
      decoration: BoxDecoration(
        color: isDark ? AdminTheme.gray900 : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(2, 0),
          ),
        ],
      ),
      child: Column(
        children: [
          // Logo Section
          _buildLogoSection(isMobile: false),
          const SizedBox(height: 20),

          // Navigation Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              itemCount: _navigationItems.length,
              itemBuilder: (context, index) {
                return _buildRailItem(index);
              },
            ),
          ),

          // Profile Section
          const Divider(),
          _buildProfileSection(isMobile: false),
        ],
      ),
    );
  }

  Widget _buildLogoSection({required bool isMobile}) {
    return Container(
      padding: EdgeInsets.all(isMobile ? 20 : 24),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AdminTheme.primaryOrange,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.restaurant_menu,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'FoodEx',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: AdminTheme.primaryOrange,
                  ),
                ),
                Text(
                  'Admin Panel',
                  style: TextStyle(
                    fontSize: 12,
                    color: AdminTheme.gray600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(int index) {
    final item = _navigationItems[index];
    final isSelected = widget.selectedIndex == index;
    final isHovered = _hoveredIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 4),
        child: ListTile(
          selected: isSelected,
          leading: Icon(
            isSelected ? item.activeIcon : item.icon,
            color: isSelected
                ? AdminTheme.primaryOrange
                : (isHovered
                    ? AdminTheme.primaryOrange.withOpacity(0.7)
                    : AdminTheme.gray600),
          ),
          title: Text(
            item.label,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected
                  ? AdminTheme.primaryOrange
                  : (isDark ? Colors.white : AdminTheme.darkGray),
            ),
          ),
          selectedTileColor: AdminTheme.primaryOrange.withOpacity(0.1),
          hoverColor: AdminTheme.primaryOrange.withOpacity(0.05),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          onTap: () {
            widget.onDestinationSelected(index);
            Navigator.pop(context); // Close drawer on mobile
          },
        ),
      ),
    );
  }

  Widget _buildRailItem(int index) {
    final item = _navigationItems[index];
    final isSelected = widget.selectedIndex == index;
    final isHovered = _hoveredIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredIndex = index),
      onExit: (_) => setState(() => _hoveredIndex = null),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        margin: const EdgeInsets.only(bottom: 4),
        decoration: BoxDecoration(
          color: isSelected
              ? AdminTheme.primaryOrange.withOpacity(0.1)
              : (isHovered
                  ? AdminTheme.primaryOrange.withOpacity(0.05)
                  : Colors.transparent),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AdminTheme.primaryOrange : Colors.transparent,
            width: 2,
          ),
        ),
        child: InkWell(
          onTap: () => widget.onDestinationSelected(index),
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  isSelected ? item.activeIcon : item.icon,
                  color: isSelected
                      ? AdminTheme.primaryOrange
                      : (isHovered
                          ? AdminTheme.primaryOrange.withOpacity(0.7)
                          : AdminTheme.gray600),
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    item.label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isSelected ? FontWeight.w600 : FontWeight.w500,
                      color: isSelected
                          ? AdminTheme.primaryOrange
                          : (isDark ? Colors.white : AdminTheme.darkGray),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileSection({required bool isMobile}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(isMobile ? 16 : 20),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor: AdminTheme.primaryOrange.withOpacity(0.1),
            child: const Text(
              'AD',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AdminTheme.primaryOrange,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Admin User',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AdminTheme.darkGray,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'admin@foodex.com',
                  style: TextStyle(
                    fontSize: 12,
                    color: AdminTheme.gray600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.logout, size: 20),
            color: AdminTheme.errorRed,
            onPressed: _handleLogout,
            tooltip: 'Logout',
          ),
        ],
      ),
    );
  }

  void _handleLogout() {
    // TODO: Implement logout
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Logout clicked'),
        behavior: SnackBarBehavior.floating,
        backgroundColor: AdminTheme.errorRed,
      ),
    );
  }
}

/// Navigation Item Model
class NavigationItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  NavigationItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
