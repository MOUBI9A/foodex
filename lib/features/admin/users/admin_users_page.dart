import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Admin Users Management Page
///
/// Comprehensive user management interface for administrators.
/// Allows viewing, searching, filtering, editing, and managing all users.
///
/// Features:
/// - User list table (DataTable with pagination)
/// - Search bar (by name, email, phone)
/// - Filter by user type (customer, chef, delivery, admin)
/// - Filter by status (active, suspended, pending)
/// - Sort by columns (name, email, join date, status)
/// - Bulk actions (delete, suspend, activate)
/// - Individual actions (edit, view details, suspend/activate)
/// - User details modal (view full profile)
/// - Export to CSV/Excel functionality
///
/// Layout:
/// ┌────────────────────────────────────────┐
/// │ Users (title)             [+ Add User] │
/// ├────────────────────────────────────────┤
/// │ [Search] [Type Filter] [Status Filter] │
/// ├────────────────────────────────────────┤
/// │                                        │
/// │  User Table with Columns:              │
/// │  ☐ | Avatar | Name | Email | Type |   │
/// │     Status | Join Date | Actions       │
/// │                                        │
/// │  [Pagination: 1 2 3 ... 10]            │
/// └────────────────────────────────────────┘
///
/// State Management:
/// - Users list (Riverpod AsyncValue)
/// - Search query (local state)
/// - Filter selections (local state)
/// - Pagination state (current page, items per page)
/// - Selected users (for bulk actions)
///
/// API Integration:
/// - GET /api/admin/users (with query params)
/// - PUT /api/admin/users/:id/suspend
/// - PUT /api/admin/users/:id/activate
/// - DELETE /api/admin/users/:id
class AdminUsersPage extends ConsumerStatefulWidget {
  const AdminUsersPage({super.key});

  @override
  ConsumerState<AdminUsersPage> createState() => _AdminUsersPageState();
}

class _AdminUsersPageState extends ConsumerState<AdminUsersPage> {
  // Search and filter state
  final _searchController = TextEditingController();
  // String _searchQuery = ''; // TODO: Use for API filtering
  String? _selectedUserType; // 'all', 'customer', 'chef', 'delivery', 'admin'
  String? _selectedStatus; // 'all', 'active', 'suspended', 'pending'

  // Pagination state
  int _currentPage = 1;
  // final int _itemsPerPage = 20; // TODO: Use for API pagination  // Selection state
  final Set<String> _selectedUserIds = {};
  bool _selectAll = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Handle search input
  void _handleSearch(String query) {
    setState(() {
      // _searchQuery = query; // Store for API call
      _currentPage = 1; // Reset to first page
    });
    // TODO: Trigger API call with new search query
  }

  /// Handle user type filter change
  void _handleUserTypeFilter(String? type) {
    setState(() {
      _selectedUserType = type;
      _currentPage = 1;
    });
    // TODO: Trigger API call with new filter
  }

  /// Handle status filter change
  void _handleStatusFilter(String? status) {
    setState(() {
      _selectedStatus = status;
      _currentPage = 1;
    });
    // TODO: Trigger API call with new filter
  }

  /// Handle pagination
  void _handlePageChange(int page) {
    setState(() {
      _currentPage = page;
    });
    // TODO: Trigger API call with new page
  }

  /// Toggle select all users
  void _toggleSelectAll(bool? value) {
    setState(() {
      _selectAll = value ?? false;
      if (_selectAll) {
        // TODO: Add all current page user IDs to selection
        _selectedUserIds.clear();
        _selectedUserIds.addAll(['user1', 'user2', 'user3']); // Placeholder
      } else {
        _selectedUserIds.clear();
      }
    });
  }

  /// Toggle individual user selection
  void _toggleUserSelection(String userId, bool? value) {
    setState(() {
      if (value == true) {
        _selectedUserIds.add(userId);
      } else {
        _selectedUserIds.remove(userId);
      }
    });
  }

  /// Bulk suspend selected users
  void _bulkSuspendUsers() async {
    if (_selectedUserIds.isEmpty) return;

    // TODO: Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Suspend Users'),
        content: Text(
            'Are you sure you want to suspend ${_selectedUserIds.length} users?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Suspend'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // TODO: Call API to suspend users
      // await ref.read(adminUsersProvider.notifier).bulkSuspendUsers(_selectedUserIds);
      setState(() {
        _selectedUserIds.clear();
        _selectAll = false;
      });
    }
  }

  /// Show add user dialog
  void _showAddUserDialog() {
    // TODO: Show modal to add new user
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New User'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              decoration: InputDecoration(labelText: 'Name'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Email'),
            ),
            SizedBox(height: 16),
            TextField(
              decoration: InputDecoration(labelText: 'Phone'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              // TODO: Call API to create user
              Navigator.pop(context);
            },
            child: const Text('Add User'),
          ),
        ],
      ),
    );
  }

  /// Show user details modal
  void _showUserDetails(String userId) {
    // TODO: Fetch user details and show modal
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('User Details'),
        content: const SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('User ID: 12345'),
              SizedBox(height: 8),
              Text('Name: John Doe'),
              SizedBox(height: 8),
              Text('Email: john@example.com'),
              SizedBox(height: 8),
              Text('Type: Customer'),
              SizedBox(height: 8),
              Text('Status: Active'),
              SizedBox(height: 8),
              Text('Join Date: 2024-01-15'),
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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // TODO: Fetch users from provider
    // final usersAsync = ref.watch(adminUsersProvider);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with title and add button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Users',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                FilledButton.icon(
                  onPressed: _showAddUserDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('Add User'),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Search and filters
            Row(
              children: [
                // Search bar
                Expanded(
                  flex: 2,
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: 'Search by name, email, or phone...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    onChanged: _handleSearch,
                  ),
                ),
                const SizedBox(width: 16),

                // User type filter
                SizedBox(
                  width: 150,
                  child: DropdownButtonFormField<String>(
                    value: _selectedUserType,
                    decoration: InputDecoration(
                      labelText: 'User Type',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: const [
                      DropdownMenuItem(value: null, child: Text('All')),
                      DropdownMenuItem(
                          value: 'customer', child: Text('Customer')),
                      DropdownMenuItem(value: 'chef', child: Text('Chef')),
                      DropdownMenuItem(
                          value: 'delivery', child: Text('Delivery')),
                      DropdownMenuItem(value: 'admin', child: Text('Admin')),
                    ],
                    onChanged: _handleUserTypeFilter,
                  ),
                ),
                const SizedBox(width: 16),

                // Status filter
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
                      DropdownMenuItem(value: 'active', child: Text('Active')),
                      DropdownMenuItem(
                          value: 'suspended', child: Text('Suspended')),
                      DropdownMenuItem(
                          value: 'pending', child: Text('Pending')),
                    ],
                    onChanged: _handleStatusFilter,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Bulk actions bar (shown when users are selected)
            if (_selectedUserIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      '${_selectedUserIds.length} users selected',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.onPrimaryContainer,
                      ),
                    ),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _bulkSuspendUsers,
                      icon: const Icon(Icons.block),
                      label: const Text('Suspend'),
                      style: FilledButton.styleFrom(
                        backgroundColor: theme.colorScheme.error,
                      ),
                    ),
                  ],
                ),
              ),
            if (_selectedUserIds.isNotEmpty) const SizedBox(height: 16),

            // Users table
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
                      child: Row(
                        children: [
                          Checkbox(
                            value: _selectAll,
                            onChanged: _toggleSelectAll,
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                              flex: 2,
                              child: Text('Name',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const Expanded(
                              flex: 2,
                              child: Text('Email',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const Expanded(
                              flex: 1,
                              child: Text('Type',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const Expanded(
                              flex: 1,
                              child: Text('Status',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const Expanded(
                              flex: 1,
                              child: Text('Join Date',
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold))),
                          const SizedBox(
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
                        itemCount: 10, // Placeholder count
                        itemBuilder: (context, index) {
                          final userId = 'user_$index';
                          final isSelected = _selectedUserIds.contains(userId);

                          return Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(color: theme.dividerColor),
                              ),
                            ),
                            child: Row(
                              children: [
                                Checkbox(
                                  value: isSelected,
                                  onChanged: (value) =>
                                      _toggleUserSelection(userId, value),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  flex: 2,
                                  child: Row(
                                    children: [
                                      const CircleAvatar(
                                        radius: 16,
                                        child: Icon(Icons.person, size: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Text('User $index'),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 2,
                                    child: Text('user$index@example.com')),
                                const Expanded(
                                    flex: 1, child: Text('Customer')),
                                Expanded(
                                  flex: 1,
                                  child: Chip(
                                    label: const Text('Active',
                                        style: TextStyle(fontSize: 12)),
                                    backgroundColor:
                                        Colors.green.withValues(alpha: 0.1),
                                  ),
                                ),
                                const Expanded(
                                    flex: 1, child: Text('2024-01-15')),
                                SizedBox(
                                  width: 100,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.visibility,
                                            size: 18),
                                        onPressed: () =>
                                            _showUserDetails(userId),
                                        tooltip: 'View details',
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.block, size: 18),
                                        onPressed: () {
                                          // TODO: Suspend user
                                        },
                                        tooltip: 'Suspend',
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
                                ? () => _handlePageChange(_currentPage - 1)
                                : null,
                          ),
                          ...List.generate(
                            5,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: TextButton(
                                onPressed: () => _handlePageChange(index + 1),
                                style: TextButton.styleFrom(
                                  backgroundColor: _currentPage == index + 1
                                      ? theme.colorScheme.primary
                                      : null,
                                  foregroundColor: _currentPage == index + 1
                                      ? theme.colorScheme.onPrimary
                                      : null,
                                ),
                                child: Text('${index + 1}'),
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.chevron_right),
                            onPressed: () =>
                                _handlePageChange(_currentPage + 1),
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
}
