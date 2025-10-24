import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Admin Navigation Bar Component
///
/// Top horizontal navigation bar for admin dashboard.
/// Displayed above all admin pages (persistent header).
///
/// Features:
/// - FoodEx logo (clickable, returns to dashboard)
/// - Global search bar (search users, orders, chefs)
/// - Notifications dropdown (with badge count)
/// - Dark/Light theme toggle button
/// - Admin profile menu (settings, logout)
/// - Responsive layout (collapses on mobile)
///
/// Layout:
/// Desktop: Logo | Search | Notifications | Theme Toggle | Profile
/// Mobile: Hamburger Menu | Logo | Profile
///
/// State Management:
/// - Theme mode (Riverpod provider)
/// - Notification count (Riverpod provider)
/// - Search query state
///
/// Integration:
/// - Used in `admin_responsive_layout.dart`
/// - Persists across all admin pages
/// - Coordinates with AppSidebar for navigation
class AdminNavbar extends ConsumerStatefulWidget {
  /// Callback when hamburger menu is pressed (mobile only)
  final VoidCallback? onMenuPressed;

  /// Current theme mode
  final ThemeMode themeMode;

  /// Callback when theme is toggled
  final ValueChanged<ThemeMode> onThemeChanged;

  const AdminNavbar({
    super.key,
    this.onMenuPressed,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  ConsumerState<AdminNavbar> createState() => _AdminNavbarState();
}

class _AdminNavbarState extends ConsumerState<AdminNavbar> {
  // Search controller
  final _searchController = TextEditingController();

  // State variables
  int _notificationCount = 5; // TODO: Get from provider

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Handle search submission
  void _handleSearch(String query) {
    // TODO: Implement global search
    // - Search users
    // - Search orders
    // - Search chefs
    // - Navigate to search results page
    print('Searching for: $query');
  }

  /// Toggle theme mode
  void _toggleTheme() {
    final newMode =
        widget.themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    widget.onThemeChanged(newMode);
  }

  /// Show notifications dropdown
  void _showNotifications(BuildContext context) {
    // TODO: Implement notifications dropdown
    // - Recent notifications list
    // - Mark as read functionality
    // - Navigate to full notifications page
    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
      items: [
        const PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.notifications),
            title: Text('No new notifications'),
            dense: true,
          ),
        ),
      ],
    );
  }

  /// Show profile menu
  void _showProfileMenu(BuildContext context) {
    // TODO: Implement profile dropdown
    // - View profile
    // - Settings
    // - Logout
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
      items: const [
        PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            dense: true,
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: ListTile(
            leading: Icon(Icons.settings),
            title: Text('Settings'),
            dense: true,
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Logout', style: TextStyle(color: Colors.red)),
            dense: true,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 900;

    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Hamburger menu (mobile only)
          if (isMobile && widget.onMenuPressed != null)
            IconButton(
              icon: const Icon(Icons.menu),
              onPressed: widget.onMenuPressed,
              tooltip: 'Menu',
            ),

          // FoodEx logo
          if (!isMobile) ...[
            // TODO: Replace with actual logo
            const Icon(Icons.restaurant, size: 32, color: Colors.orange),
            const SizedBox(width: 8),
            const Text(
              'FoodEx',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(width: 32),
          ],

          // Search bar (desktop only)
          if (!isMobile)
            Expanded(
              flex: 2,
              child: Container(
                constraints: const BoxConstraints(maxWidth: 500),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: 'Search users, orders, chefs...',
                    prefixIcon: const Icon(Icons.search, size: 20),
                    suffixIcon: _searchController.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear, size: 20),
                            onPressed: () {
                              setState(() {
                                _searchController.clear();
                              });
                            },
                          )
                        : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: theme.colorScheme.surfaceContainerHighest,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    isDense: true,
                  ),
                  onSubmitted: _handleSearch,
                  onChanged: (value) {
                    setState(() {});
                  },
                ),
              ),
            ),

          const Spacer(),

          // Notifications button
          IconButton(
            icon: Badge(
              label: Text('$_notificationCount'),
              isLabelVisible: _notificationCount > 0,
              child: const Icon(Icons.notifications_outlined),
            ),
            onPressed: () => _showNotifications(context),
            tooltip: 'Notifications',
          ),

          const SizedBox(width: 8),

          // Theme toggle button
          IconButton(
            icon: Icon(
              widget.themeMode == ThemeMode.light
                  ? Icons.dark_mode
                  : Icons.light_mode,
            ),
            onPressed: _toggleTheme,
            tooltip: 'Toggle theme',
          ),

          const SizedBox(width: 8),

          // Profile menu
          InkWell(
            onTap: () => _showProfileMenu(context),
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 16,
                    backgroundColor: theme.colorScheme.primary,
                    child: const Text(
                      'A',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  if (!isMobile) ...[
                    const SizedBox(width: 8),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          'admin@foodex.com',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, size: 20),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
