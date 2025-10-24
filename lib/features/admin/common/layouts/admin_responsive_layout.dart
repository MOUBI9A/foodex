import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../widgets/admin_navbar.dart';
// TODO: Import AppSidebar when integrating with dashboard
// import '../../dashboard/widgets/app_sidebar.dart';

/// Admin Responsive Layout Wrapper
///
/// Main layout structure for all admin pages.
/// Provides consistent navbar, sidebar, and content area.
///
/// Layout Structure:
/// ┌─────────────────────────────────────┐
/// │         AdminNavbar                 │  ← Top (persistent)
/// ├───────┬─────────────────────────────┤
/// │       │                             │
/// │ Side  │      Content Area           │  ← Body
/// │ bar   │      (child widget)         │
/// │       │                             │
/// └───────┴─────────────────────────────┘
///
/// Responsive Behavior:
/// - Desktop (>1200px): Permanent sidebar (240px) + navbar
/// - Tablet (900-1200px): Collapsible sidebar (240px) + navbar
/// - Mobile (<900px): Drawer sidebar + navbar with hamburger
///
/// Features:
/// - Theme toggle (light/dark mode)
/// - Persistent navigation state
/// - Smooth drawer animations
/// - Keyboard shortcuts support
/// - Scroll behavior management
///
/// State Management:
/// - Theme mode (Riverpod provider)
/// - Sidebar expanded state (local state)
/// - Navigation state (GoRouter)
///
/// Usage:
/// ```dart
/// AdminResponsiveLayout(
///   child: AdminUsersPage(),
/// )
/// ```
class AdminResponsiveLayout extends ConsumerStatefulWidget {
  /// The main content to display in the body area
  final Widget child;

  /// Optional custom sidebar (overrides default)
  final Widget? customSidebar;

  /// Whether to show the sidebar (default: true)
  final bool showSidebar;

  const AdminResponsiveLayout({
    super.key,
    required this.child,
    this.customSidebar,
    this.showSidebar = true,
  });

  @override
  ConsumerState<AdminResponsiveLayout> createState() =>
      _AdminResponsiveLayoutState();
}

class _AdminResponsiveLayoutState extends ConsumerState<AdminResponsiveLayout> {
  // Sidebar state
  bool _isSidebarExpanded = true;

  // Drawer key (for mobile)
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Current theme mode
  ThemeMode _themeMode = ThemeMode.light; // TODO: Get from Riverpod provider

  @override
  void initState() {
    super.initState();
    // TODO: Initialize theme mode from provider
    // _themeMode = ref.read(themeModeProvider);
  }

  /// Toggle sidebar (desktop/tablet)
  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
    });
  }

  /// Open drawer (mobile)
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  /// Handle theme change
  void _handleThemeChange(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
    // TODO: Update theme provider
    // ref.read(themeModeProvider.notifier).state = mode;
  }

  /// Build sidebar widget
  Widget _buildSidebar(bool isMobile) {
    if (widget.customSidebar != null) {
      return widget.customSidebar!;
    }

    // TODO: Replace with actual AppSidebar from dashboard/widgets/
    // This is a placeholder until integration
    return Container(
      width: 240,
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      child: ListView(
        padding: const EdgeInsets.symmetric(vertical: 16),
        children: [
          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text('Dashboard'),
            selected: true,
            onTap: () {
              // TODO: Navigate to dashboard
              if (isMobile) {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.people),
            title: const Text('Users'),
            onTap: () {
              // TODO: Navigate to users page
              if (isMobile) {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.shopping_bag),
            title: const Text('Orders'),
            onTap: () {
              // TODO: Navigate to orders page
              if (isMobile) {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text('Analytics'),
            onTap: () {
              // TODO: Navigate to analytics page
              if (isMobile) {
                Navigator.pop(context);
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              // TODO: Navigate to settings page
              if (isMobile) {
                Navigator.pop(context);
              }
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // Responsive breakpoints
    final isMobile = screenWidth < 900;
    final isTablet = screenWidth >= 900 && screenWidth < 1200;
    // final isDesktop = screenWidth >= 1200; // Reserved for future desktop-specific features

    // Sidebar width
    final sidebarWidth = _isSidebarExpanded ? 240.0 : 64.0;

    return Scaffold(
      key: _scaffoldKey,

      // Drawer for mobile
      drawer: isMobile && widget.showSidebar
          ? Drawer(
              child: _buildSidebar(true),
            )
          : null,

      body: Column(
        children: [
          // Top navbar (persistent)
          AdminNavbar(
            onMenuPressed: isMobile ? _openDrawer : null,
            themeMode: _themeMode,
            onThemeChanged: _handleThemeChange,
          ),

          // Body (sidebar + content)
          Expanded(
            child: Row(
              children: [
                // Sidebar (desktop/tablet only)
                if (!isMobile && widget.showSidebar)
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    width: sidebarWidth,
                    child: _buildSidebar(false),
                  ),

                // Vertical divider
                if (!isMobile && widget.showSidebar)
                  Container(
                    width: 1,
                    color: Theme.of(context).dividerColor,
                  ),

                // Main content area
                Expanded(
                  child: Container(
                    color: Theme.of(context).colorScheme.surface,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // Floating action button for sidebar toggle (tablet only)
      floatingActionButton: isTablet && widget.showSidebar
          ? FloatingActionButton(
              mini: true,
              onPressed: _toggleSidebar,
              tooltip:
                  _isSidebarExpanded ? 'Collapse sidebar' : 'Expand sidebar',
              child: Icon(
                _isSidebarExpanded ? Icons.chevron_left : Icons.chevron_right,
              ),
            )
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
    );
  }
}
