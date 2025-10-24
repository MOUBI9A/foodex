import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/admin_theme.dart';

/// Admin App Bar Widget
///
/// Top app bar for admin dashboard with:
/// - Breadcrumb navigation based on current route
/// - Notifications badge
/// - User profile dropdown
/// - Theme mode respect (light/dark)
class AdminAppBar extends StatelessWidget {
  final VoidCallback? onMenuPressed;
  final bool showMenuButton;

  const AdminAppBar({
    super.key,
    this.onMenuPressed,
    this.showMenuButton = true,
  });

  /// Generate breadcrumbs from current route path
  List<String> _generateBreadcrumbs(String path) {
    final segments = path.split('/').where((s) => s.isNotEmpty).toList();
    final breadcrumbs = <String>[];

    for (var segment in segments) {
      // Capitalize and format segment
      final formatted = segment
          .split('-')
          .map((word) => word[0].toUpperCase() + word.substring(1))
          .join(' ');
      breadcrumbs.add(formatted);
    }

    return breadcrumbs;
  }

  /// Show notifications dropdown
  void _showNotifications(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AdminTheme.infoBlue,
                  child: Icon(Icons.shopping_bag, color: Colors.white),
                ),
                title: const Text('New Order #1234'),
                subtitle: const Text('Just now'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/orders');
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AdminTheme.successGreen,
                  child: Icon(Icons.person_add, color: Colors.white),
                ),
                title: const Text('New Chef Registration'),
                subtitle: const Text('5 minutes ago'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/chefs');
                },
              ),
              ListTile(
                leading: const CircleAvatar(
                  backgroundColor: AdminTheme.warningYellow,
                  child: Icon(Icons.warning, color: Colors.white),
                ),
                title: const Text('System Alert'),
                subtitle: const Text('10 minutes ago'),
                onTap: () {
                  Navigator.pop(context);
                  context.go('/admin/logs');
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  /// Show user profile menu
  void _showProfileMenu(BuildContext context) {
    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 70, 0, 0),
      items: const [
        PopupMenuItem<String>(
          value: 'profile',
          child: ListTile(
            leading: Icon(Icons.person_outline),
            title: Text('My Profile'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuItem<String>(
          value: 'settings',
          child: ListTile(
            leading: Icon(Icons.settings_outlined),
            title: Text('Settings'),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
        PopupMenuDivider(),
        PopupMenuItem<String>(
          value: 'logout',
          child: ListTile(
            leading: Icon(Icons.logout, color: AdminTheme.errorRed),
            title: Text('Logout', style: TextStyle(color: AdminTheme.errorRed)),
            dense: true,
            contentPadding: EdgeInsets.zero,
          ),
        ),
      ],
    ).then((value) {
      if (value == 'profile') {
        context.go('/admin/profile');
      } else if (value == 'settings') {
        context.go('/admin/settings');
      } else if (value == 'logout') {
        // TODO: Implement logout logic
        context.go('/admin/login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentPath = GoRouterState.of(context).uri.path;
    final breadcrumbs = _generateBreadcrumbs(currentPath);

    final appBarColor = isDark ? AdminTheme.gray800 : AdminTheme.white;
    final textColor = isDark ? AdminTheme.white : AdminTheme.darkGray;

    return Container(
      height: 70,
      decoration: BoxDecoration(
        color: appBarColor,
        border: Border(
          bottom: BorderSide(
            color: theme.dividerColor,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          children: [
            // Menu button
            if (showMenuButton)
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: onMenuPressed,
                tooltip: 'Toggle Menu',
                color: textColor,
              ),

            const SizedBox(width: 16),

            // Breadcrumbs
            Expanded(
              child: Row(
                children: [
                  for (var i = 0; i < breadcrumbs.length; i++) ...[
                    if (i > 0)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.5),
                        ),
                      ),
                    Text(
                      breadcrumbs[i],
                      style: TextStyle(
                        fontSize: i == breadcrumbs.length - 1 ? 16 : 14,
                        fontWeight: i == breadcrumbs.length - 1
                            ? FontWeight.w600
                            : FontWeight.normal,
                        color: i == breadcrumbs.length - 1
                            ? textColor
                            : theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                      ),
                    ),
                  ],
                ],
              ),
            ),

            // Search button
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // TODO: Implement global search
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Search coming soon')),
                );
              },
              tooltip: 'Search',
              color: textColor,
            ),

            const SizedBox(width: 8),

            // Notifications button
            Badge(
              label: const Text('3'),
              backgroundColor: AdminTheme.errorRed,
              child: IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => _showNotifications(context),
                tooltip: 'Notifications',
                color: textColor,
              ),
            ),

            const SizedBox(width: 8),

            // Theme toggle button
            IconButton(
              icon: Icon(
                isDark ? Icons.light_mode : Icons.dark_mode,
              ),
              onPressed: () {
                // TODO: Implement theme toggle with Riverpod provider
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Theme toggle coming soon')),
                );
              },
              tooltip: 'Toggle Theme',
              color: textColor,
            ),

            const SizedBox(width: 16),

            // User profile button
            InkWell(
              onTap: () => _showProfileMenu(context),
              borderRadius: BorderRadius.circular(24),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: AdminTheme.primaryOrange,
                      child: Text(
                        'A',
                        style: TextStyle(
                          color: AdminTheme.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Admin User',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: textColor,
                          ),
                        ),
                        Text(
                          'Administrator',
                          style: TextStyle(
                            fontSize: 11,
                            color: theme.colorScheme.onSurface
                                .withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_drop_down,
                      color: textColor,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
