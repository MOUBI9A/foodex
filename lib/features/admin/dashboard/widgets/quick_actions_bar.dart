import 'package:flutter/material.dart';
import 'package:food_delivery/features/admin/common/theme/admin_theme.dart';

/// Quick Actions Bar Widget
///
/// Provides 4 primary action buttons for common admin tasks.
/// Responsive layout: horizontal row on desktop, grid on mobile.
class QuickActionsBar extends StatefulWidget {
  const QuickActionsBar({super.key});

  @override
  State<QuickActionsBar> createState() => _QuickActionsBarState();
}

class _QuickActionsBarState extends State<QuickActionsBar> {
  int? _hoveredIndex;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Quick Actions',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 20),
            LayoutBuilder(
              builder: (context, constraints) {
                final isMobile = constraints.maxWidth < 600;

                if (isMobile) {
                  return _buildGridLayout();
                } else {
                  return _buildRowLayout();
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRowLayout() {
    return Row(
      children: [
        _buildActionButton(
          icon: Icons.person_add,
          label: 'Add New Chef',
          color: AdminTheme.successGreen,
          index: 0,
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          icon: Icons.shopping_bag_outlined,
          label: 'View All Orders',
          color: AdminTheme.infoBlue,
          index: 1,
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          icon: Icons.download_outlined,
          label: 'Export Reports',
          color: AdminTheme.warningYellow,
          index: 2,
        ),
        const SizedBox(width: 16),
        _buildActionButton(
          icon: Icons.people_outline,
          label: 'Manage Users',
          color: AdminTheme.primaryOrange,
          index: 3,
        ),
      ],
    );
  }

  Widget _buildGridLayout() {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 2,
      children: [
        _buildActionButton(
          icon: Icons.person_add,
          label: 'Add New Chef',
          color: AdminTheme.successGreen,
          index: 0,
        ),
        _buildActionButton(
          icon: Icons.shopping_bag_outlined,
          label: 'View All Orders',
          color: AdminTheme.infoBlue,
          index: 1,
        ),
        _buildActionButton(
          icon: Icons.download_outlined,
          label: 'Export Reports',
          color: AdminTheme.warningYellow,
          index: 2,
        ),
        _buildActionButton(
          icon: Icons.people_outline,
          label: 'Manage Users',
          color: AdminTheme.primaryOrange,
          index: 3,
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required int index,
  }) {
    final isHovered = _hoveredIndex == index;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: MouseRegion(
        onEnter: (_) => setState(() => _hoveredIndex = index),
        onExit: (_) => setState(() => _hoveredIndex = null),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          child: ElevatedButton(
            onPressed: () => _handleAction(index),
            style: ElevatedButton.styleFrom(
              backgroundColor: isHovered
                  ? color
                  : (isDark ? AdminTheme.gray800 : Colors.white),
              foregroundColor: isHovered ? Colors.white : color,
              elevation: isHovered ? 8 : 0,
              shadowColor: color.withOpacity(0.5),
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 20,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: BorderSide(
                  color:
                      isHovered ? Colors.transparent : color.withOpacity(0.3),
                  width: 2,
                ),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    icon,
                    size: isHovered ? 28 : 24,
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _handleAction(int index) {
    // TODO: Implement action handlers
    final actions = [
      'Add New Chef',
      'View All Orders',
      'Export Reports',
      'Manage Users',
    ];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${actions[index]} clicked'),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        backgroundColor: _getActionColor(index),
      ),
    );
  }

  Color _getActionColor(int index) {
    switch (index) {
      case 0:
        return AdminTheme.successGreen;
      case 1:
        return AdminTheme.infoBlue;
      case 2:
        return AdminTheme.warningYellow;
      case 3:
        return AdminTheme.primaryOrange;
      default:
        return AdminTheme.primaryOrange;
    }
  }
}
