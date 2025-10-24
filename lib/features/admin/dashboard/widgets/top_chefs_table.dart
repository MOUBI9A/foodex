import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/admin/common/theme/admin_theme.dart';
import 'package:food_delivery/features/admin/dashboard/data/dashboard_metrics_provider.dart';

/// Top Chefs Table Widget
///
/// Displays top performing chefs with sortable columns and clickable rows.
/// Features pagination, sorting, and smooth hover effects.
class TopChefsTable extends ConsumerStatefulWidget {
  const TopChefsTable({super.key});

  @override
  ConsumerState<TopChefsTable> createState() => _TopChefsTableState();
}

class _TopChefsTableState extends ConsumerState<TopChefsTable> {
  int _sortColumnIndex = 4; // Sort by total revenue by default
  bool _sortAscending = false;
  final int _rowsPerPage = 10;
  int _currentPage = 0;
  String? _hoveredChefId;

  @override
  Widget build(BuildContext context) {
    final metrics = ref.watch(dashboardMetricsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Sort chefs based on selected column
    final sortedChefs = List<ChefData>.from(metrics.topChefs);
    _sortChefs(sortedChefs);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Top Performing Chefs',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Based on completed orders and revenue',
                      style: TextStyle(
                        fontSize: 14,
                        color: isDark ? AdminTheme.gray400 : AdminTheme.gray600,
                      ),
                    ),
                  ],
                ),
                OutlinedButton.icon(
                  onPressed: () {
                    // TODO: Export chefs data
                  },
                  icon: const Icon(Icons.download, size: 18),
                  label: const Text('Export'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Table
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minWidth: MediaQuery.of(context).size.width - 100,
                ),
                child: DataTable(
                  sortColumnIndex: _sortColumnIndex,
                  sortAscending: _sortAscending,
                  columns: [
                    const DataColumn(
                      label: Text('Chef'),
                    ),
                    DataColumn(
                      label: const Text('Rating'),
                      numeric: true,
                      onSort: (columnIndex, ascending) {
                        _handleSort(columnIndex, ascending);
                      },
                    ),
                    DataColumn(
                      label: const Text('Completed Orders'),
                      numeric: true,
                      onSort: (columnIndex, ascending) {
                        _handleSort(columnIndex, ascending);
                      },
                    ),
                    DataColumn(
                      label: const Text('Total Revenue'),
                      numeric: true,
                      onSort: (columnIndex, ascending) {
                        _handleSort(columnIndex, ascending);
                      },
                    ),
                    const DataColumn(
                      label: Text('Actions'),
                    ),
                  ],
                  rows: sortedChefs.map((chef) {
                    final isHovered = _hoveredChefId == chef.id;

                    return DataRow(
                      onSelectChanged: (_) {
                        _viewChefProfile(chef);
                      },
                      cells: [
                        DataCell(
                          MouseRegion(
                            onEnter: (_) =>
                                setState(() => _hoveredChefId = chef.id),
                            onExit: (_) =>
                                setState(() => _hoveredChefId = null),
                            child: Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundImage: NetworkImage(chef.imageUrl),
                                  backgroundColor: AdminTheme.gray300,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  chef.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    color: isHovered
                                        ? AdminTheme.primaryOrange
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        DataCell(
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.star,
                                size: 16,
                                color: AdminTheme.warningYellow,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                chef.rating.toStringAsFixed(1),
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DataCell(
                          Text(
                            chef.completedOrders.toString(),
                            style: const TextStyle(
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        DataCell(
                          Text(
                            '\$${chef.totalRevenue.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: AdminTheme.successGreen,
                            ),
                          ),
                        ),
                        DataCell(
                          OutlinedButton(
                            onPressed: () => _viewChefProfile(chef),
                            style: OutlinedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('View Profile'),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),
            ),

            // Pagination Info
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Showing ${sortedChefs.length} of ${metrics.topChefs.length} chefs',
                  style: TextStyle(
                    fontSize: 14,
                    color: isDark ? AdminTheme.gray400 : AdminTheme.gray600,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: _currentPage > 0
                          ? () => setState(() => _currentPage--)
                          : null,
                      icon: const Icon(Icons.chevron_left),
                    ),
                    Text(
                      'Page ${_currentPage + 1}',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      onPressed: (_currentPage + 1) * _rowsPerPage <
                              metrics.topChefs.length
                          ? () => setState(() => _currentPage++)
                          : null,
                      icon: const Icon(Icons.chevron_right),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _handleSort(int columnIndex, bool ascending) {
    setState(() {
      _sortColumnIndex = columnIndex;
      _sortAscending = ascending;
    });
  }

  void _sortChefs(List<ChefData> chefs) {
    switch (_sortColumnIndex) {
      case 1: // Rating
        chefs.sort((a, b) => _sortAscending
            ? a.rating.compareTo(b.rating)
            : b.rating.compareTo(a.rating));
        break;
      case 2: // Completed Orders
        chefs.sort((a, b) => _sortAscending
            ? a.completedOrders.compareTo(b.completedOrders)
            : b.completedOrders.compareTo(a.completedOrders));
        break;
      case 3: // Total Revenue
        chefs.sort((a, b) => _sortAscending
            ? a.totalRevenue.compareTo(b.totalRevenue)
            : b.totalRevenue.compareTo(a.totalRevenue));
        break;
    }
  }

  void _viewChefProfile(ChefData chef) {
    // TODO: Navigate to chef profile page or show modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Chef Profile: ${chef.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(chef.imageUrl),
              ),
            ),
            const SizedBox(height: 24),
            _buildProfileRow('Rating', '⭐ ${chef.rating}'),
            _buildProfileRow(
              'Completed Orders',
              chef.completedOrders.toString(),
            ),
            _buildProfileRow(
              'Total Revenue',
              '\$${chef.totalRevenue.toStringAsFixed(2)}',
            ),
            _buildProfileRow('Chef ID', chef.id),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              // TODO: Navigate to full chef management page
            },
            child: const Text('Manage Chef'),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(value),
        ],
      ),
    );
  }
}
