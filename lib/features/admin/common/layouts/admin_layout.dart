import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/admin_theme.dart';
import '../widgets/admin_app_bar.dart';
import '../../dashboard/widgets/app_sidebar.dart';

/// Admin Shell Layout
///
/// Main layout wrapper for all admin pages.
/// Provides persistent navigation sidebar, app bar, and content area.
///
/// Features:
/// - Responsive sidebar (collapse at < 1000px)
/// - Persistent app bar with breadcrumbs
/// - Smooth animations for sidebar toggle
/// - Theme-aware colors from AdminTheme
/// - Navigation state management via GoRouter
class AdminLayout extends StatefulWidget {
  /// The child widget to display in the main content area
  final Widget child;

  const AdminLayout({
    super.key,
    required this.child,
  });

  @override
  State<AdminLayout> createState() => _AdminLayoutState();
}

class _AdminLayoutState extends State<AdminLayout>
    with SingleTickerProviderStateMixin {
  // Sidebar state
  bool _isSidebarExpanded = true;
  late AnimationController _sidebarAnimationController;
  late Animation<double> _sidebarAnimation;

  // Drawer key for mobile
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // Breakpoint for responsive behavior
  static const double _mobileBreakpoint = 1000;

  // Sidebar widths
  static const double _expandedSidebarWidth = 280;
  static const double _collapsedSidebarWidth = 80;

  @override
  void initState() {
    super.initState();

    // Initialize sidebar animation
    _sidebarAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _sidebarAnimation = Tween<double>(
      begin: _expandedSidebarWidth,
      end: _collapsedSidebarWidth,
    ).animate(CurvedAnimation(
      parent: _sidebarAnimationController,
      curve: Curves.easeInOut,
    ));

    // Start expanded
    _sidebarAnimationController.value = 0;
  }

  @override
  void dispose() {
    _sidebarAnimationController.dispose();
    super.dispose();
  }

  /// Toggle sidebar expanded/collapsed state
  void _toggleSidebar() {
    setState(() {
      _isSidebarExpanded = !_isSidebarExpanded;
      if (_isSidebarExpanded) {
        _sidebarAnimationController.reverse();
      } else {
        _sidebarAnimationController.forward();
      }
    });
  }

  /// Open drawer for mobile
  void _openDrawer() {
    _scaffoldKey.currentState?.openDrawer();
  }

  /// Get current selected index based on route
  int _getCurrentIndex(String path) {
    if (path.contains('/dashboard')) return 0;
    if (path.contains('/users')) return 1;
    if (path.contains('/chefs')) return 2;
    if (path.contains('/orders')) return 3;
    if (path.contains('/couriers')) return 4;
    if (path.contains('/analytics')) return 5;
    if (path.contains('/settings')) return 6;
    if (path.contains('/logs')) return 7;
    return 0;
  }

  /// Handle navigation destination selection
  void _onDestinationSelected(int index) {
    final routes = [
      '/admin/dashboard',
      '/admin/users',
      '/admin/chefs',
      '/admin/orders',
      '/admin/couriers',
      '/admin/analytics',
      '/admin/settings',
      '/admin/logs',
    ];

    if (index < routes.length) {
      context.go(routes[index]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < _mobileBreakpoint;
    final currentPath = GoRouterState.of(context).uri.path;
    final selectedIndex = _getCurrentIndex(currentPath);

    // Use AdminTheme colors
    final theme = Theme.of(context);
    final backgroundColor = theme.brightness == Brightness.light
        ? AdminTheme.gray100
        : AdminTheme.gray900;
    final sidebarColor = theme.brightness == Brightness.light
        ? AdminTheme.white
        : AdminTheme.gray800;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: backgroundColor,

      // Drawer for mobile
      drawer: isMobile
          ? Drawer(
              backgroundColor: sidebarColor,
              child: SafeArea(
                child: AppSidebar(
                  isMobile: true,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) {
                    _onDestinationSelected(index);
                    Navigator.pop(context); // Close drawer after navigation
                  },
                ),
              ),
            )
          : null,

      body: Column(
        children: [
          // Admin App Bar
          AdminAppBar(
            onMenuPressed: isMobile ? _openDrawer : _toggleSidebar,
            showMenuButton: true,
          ),

          // Main content area with sidebar
          Expanded(
            child: Row(
              children: [
                // Sidebar for desktop/tablet
                if (!isMobile)
                  AnimatedBuilder(
                    animation: _sidebarAnimation,
                    builder: (context, child) {
                      return Container(
                        width: _sidebarAnimation.value,
                        decoration: BoxDecoration(
                          color: sidebarColor,
                          border: Border(
                            right: BorderSide(
                              color: theme.dividerColor,
                              width: 1,
                            ),
                          ),
                        ),
                        child: AppSidebar(
                          isMobile: false,
                          selectedIndex: selectedIndex,
                          onDestinationSelected: _onDestinationSelected,
                        ),
                      );
                    },
                  ),

                // Main content area
                Expanded(
                  child: Container(
                    color: backgroundColor,
                    child: widget.child,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
