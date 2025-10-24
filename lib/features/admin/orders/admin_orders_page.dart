import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Admin Orders Management Page
///
/// Comprehensive order management interface for administrators.
/// Allows viewing, searching, filtering, and managing all orders.
///
/// Features:
/// - Orders list with real-time status updates
/// - Search by order ID, customer name, or chef name
/// - Filter by status (pending, preparing, delivering, completed, cancelled)
/// - Filter by date range
/// - Sort by order date, total, status
/// - Order details modal (full order information)
/// - Update order status (admin override)
/// - Assign delivery personnel
/// - Export orders to CSV/Excel
/// - Real-time order statistics
///
/// Layout:
/// ┌────────────────────────────────────────┐
/// │ Orders (title)                         │
/// ├─────────┬──────────┬──────────┬────────┤
/// │ Total   │ Pending  │ Active   │Completed│  ← Stats Cards
/// │ 1,234   │    45    │    89    │ 1,100  │
/// ├────────────────────────────────────────┤
/// │ [Search] [Status] [Date Range]         │
/// ├────────────────────────────────────────┤
/// │                                        │
/// │  Order Table:                          │
/// │  Order ID | Customer | Chef | Items |  │
/// │  Total | Status | Date | Actions       │
/// │                                        │
/// │  [Pagination]                          │
/// └────────────────────────────────────────┘
///
/// State Management:
/// - Orders list (Riverpod AsyncValue with auto-refresh)
/// - Order statistics (Riverpod)
/// - Search/filter state (local)
/// - Pagination state (local)
///
/// API Integration:
/// - GET /api/admin/orders (with filters)
/// - GET /api/admin/orders/stats
/// - PUT /api/admin/orders/:id/status
/// - PUT /api/admin/orders/:id/assign-delivery
class AdminOrdersPage extends ConsumerStatefulWidget {
  const AdminOrdersPage({super.key});

  @override
  ConsumerState<AdminOrdersPage> createState() => _AdminOrdersPageState();
}

class _AdminOrdersPageState extends ConsumerState<AdminOrdersPage> {
  // Search and filter state
  final _searchController = TextEditingController();
  // String _searchQuery = ''; // TODO: Use for API filtering
  String? _selectedStatus;
  DateTimeRange? _dateRange;

  // Pagination
  int _currentPage = 1;
  // final int _itemsPerPage = 20; // TODO: Use for API pagination

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Handle search
  void _handleSearch(String query) {
    setState(() {
      // _searchQuery = query; // Store for API call
      _currentPage = 1;
    });
    // TODO: Trigger API call with query parameter
  }

  /// Handle status filter
  void _handleStatusFilter(String? status) {
    setState(() {
      _selectedStatus = status;
      _currentPage = 1;
    });
    // TODO: Trigger API call
  }

  /// Pick date range
  Future<void> _pickDateRange() async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: _dateRange,
    );

    if (picked != null) {
      setState(() {
        _dateRange = picked;
        _currentPage = 1;
      });
      // TODO: Trigger API call
    }
  }

  /// Show order details
  void _showOrderDetails(String orderId) {
    // TODO: Fetch order details and show modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order Details - #$orderId'),
        content: const SizedBox(
          width: 600,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: John Doe'),
              SizedBox(height: 8),
              Text('Chef: Jane Smith'),
              SizedBox(height: 8),
              Text('Items: 3'),
              SizedBox(height: 8),
              Text('Total: \$45.99'),
              SizedBox(height: 8),
              Text('Status: Delivering'),
              SizedBox(height: 8),
              Text('Order Date: 2024-01-15 14:30'),
              SizedBox(height: 8),
              Text('Delivery Address: 123 Main St'),
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

  /// Update order status
  void _updateOrderStatus(String orderId, String newStatus) async {
    // TODO: Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Order Status'),
        content: Text('Change order status to $newStatus?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Update'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Call API to update status
      // await ref.read(adminOrdersProvider.notifier).updateOrderStatus(orderId, newStatus);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: Fetch orders and stats from providers
    // final ordersAsync = ref.watch(adminOrdersProvider);
    // final statsAsync = ref.watch(orderStatsProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Orders',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 24),

            // Statistics cards
            Row(
              children: [
                Expanded(
                  child: _buildStatCard('Total Orders', '1,234', Colors.blue),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('Pending', '45', Colors.orange),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('Active', '89', Colors.green),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _buildStatCard('Completed', '1,100', Colors.purple),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search and filters
            Row(
              children: [
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by order ID, customer, or chef...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: _handleSearch,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    value: _selectedStatus,
                    decoration: InputDecoration(
                      labelText: 'Status',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(
                          value: 'pending', child: Text('Pending')),
                      DropdownMenuItem(
                          value: 'preparing', child: Text('Preparing')),
                      DropdownMenuItem(
                          value: 'delivering', child: Text('Delivering')),
                      DropdownMenuItem(
                          value: 'completed', child: Text('Completed')),
                      DropdownMenuItem(
                          value: 'cancelled', child: Text('Cancelled')),
                    ],
                    onChanged: _handleStatusFilter,
                  ),
                ),
                const SizedBox(width: 16),
                OutlinedButton.icon(
                  onPressed: _pickDateRange,
                  icon: const Icon(Icons.date_range),
                  label: Text(
                    _dateRange == null
                        ? 'Date Range'
                        : '${_dateRange!.start.toString().split(' ')[0]} - ${_dateRange!.end.toString().split(' ')[0]}',
                  ),
                ),
                if (_dateRange != null) ...[
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      setState(() {
                        _dateRange = null;
                      });
                    },
                    tooltip: 'Clear date range',
                  ),
                ],
              ],
            ),
            const SizedBox(height: 24),

            // Orders table
            Expanded(
              child: Card(
                child: Column(
                  children: [
                    // Table header
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Expanded(
                              flex: 1,
                              child: Text('Order ID',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text('Customer',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text('Chef',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 1,
                              child: Text('Items',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 1,
                              child: Text('Total',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 1,
                              child: Text('Status',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          Expanded(
                              flex: 2,
                              child: Text('Date',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          SizedBox(
                              width: 100,
                              child: Text('Actions',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                        ],
                      ),
                    ),

                    // Table rows (TODO: Replace with real data)
                    Expanded(
                      child: ListView.builder(
                        itemCount: 15,
                        itemBuilder: (context, index) {
                          final orderId = 'ORD${1000 + index}';

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: theme.dividerColor),
                              ),
                            ),
                            child: Row(
                              children: [
                                Expanded(flex: 1, child: Text(orderId)),
                                Expanded(
                                    flex: 2,
                                    child: Text('Customer ${index + 1}')),
                                Expanded(
                                    flex: 2,
                                    child: Text('Chef ${index % 5 + 1}')),
                                Expanded(
                                    flex: 1, child: Text('${index % 5 + 1}')),
                                Expanded(
                                    flex: 1,
                                    child: Text('\$${20 + index * 3}.99')),
                                Expanded(
                                  flex: 1,
                                  child: _buildStatusChip(index % 5 == 0
                                      ? 'pending'
                                      : index % 5 == 1
                                          ? 'preparing'
                                          : index % 5 == 2
                                              ? 'delivering'
                                              : 'completed'),
                                ),
                                const Expanded(
                                    flex: 2, child: Text('2024-01-15 14:30')),
                                SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility,
                                            size: 18),
                                        onPressed: () =>
                                            _showOrderDetails(orderId),
                                        tooltip: 'View details',
                                      ),
                                      PopupMenuButton<String>(
                                        icon: const Icon(Icons.more_vert,
                                            size: 18),
                                        itemBuilder: (context) => const [
                                          PopupMenuItem<String>(
                                            value: 'preparing',
                                            child: Text('Mark Preparing'),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'delivering',
                                            child: Text('Mark Delivering'),
                                          ),
                                          PopupMenuItem<String>(
                                            value: 'completed',
                                            child: Text('Mark Completed'),
                                          ),
                                          PopupMenuDivider(),
                                          PopupMenuItem<String>(
                                            value: 'cancelled',
                                            child: Text('Cancel Order',
                                                style: TextStyle(
                                                    color: Colors.red)),
                                          ),
                                        ],
                                        onSelected: (value) =>
                                            _updateOrderStatus(orderId, value),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    // Pagination
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.chevron_left),
                            onPressed: _currentPage > 1
                                ? () => setState(() => _currentPage--)
                                : null,
                          ),
                          Text('Page $_currentPage'),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () => setState(() => _currentPage++),
                          ),
                        ],
                      ),
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

  /// Build statistic card
  Widget _buildStatCard(String title, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Build status chip
  Widget _buildStatusChip(String status) {
    Color color;
    switch (status) {
      case 'pending':
        color = Colors.orange;
        break;
      case 'preparing':
        color = Colors.blue;
        break;
      case 'delivering':
        color = Colors.purple;
        break;
      case 'completed':
        color = Colors.green;
        break;
      case 'cancelled':
        color = Colors.red;
        break;
      default:
        color = Colors.grey;
    }

    return Chip(
      label: Text(
        status.toUpperCase(),
        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
      ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color, width: 1),
    );
  }
}
