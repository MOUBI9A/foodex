import 'package:flutter/material.dart';
import '../../../../../core/themes/app_theme.dart';

/// Orders table widget with pagination and filtering
class OrdersTable extends StatelessWidget {
  final List<dynamic> orders;
  final int currentPage;
  final int totalPages;
  final String? selectedStatus;
  final String? searchQuery;
  final Function(int) onPageChanged;
  final Function(String?) onStatusChanged;
  final Function(String?) onSearchChanged;

  const OrdersTable({
    super.key,
    required this.orders,
    required this.currentPage,
    required this.totalPages,
    this.selectedStatus,
    this.searchQuery,
    required this.onPageChanged,
    required this.onStatusChanged,
    required this.onSearchChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with filters
            _buildHeader(),
            const SizedBox(height: AppSpacing.lg),

            // Table
            if (orders.isEmpty) _buildEmptyState() else _buildTable(),

            const SizedBox(height: AppSpacing.lg),

            // Pagination
            _buildPagination(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Text(
          'Recent Orders',
          style: AppTextStyles.heading3.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const Spacer(),

        // Search field
        SizedBox(
          width: 250,
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search orders...',
              prefixIcon: const Icon(Icons.search, size: 20),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              isDense: true,
            ),
            onChanged: onSearchChanged,
          ),
        ),
        const SizedBox(width: AppSpacing.md),

        // Status filter
        SizedBox(
          width: 150,
          child: DropdownButtonFormField<String>(
            value: selectedStatus,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(AppRadius.sm),
                borderSide: BorderSide(color: AppColors.border),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: AppSpacing.sm,
              ),
              isDense: true,
            ),
            hint: const Text('All Status'),
            items: const [
              DropdownMenuItem(value: null, child: Text('All Status')),
              DropdownMenuItem(value: 'pending', child: Text('Pending')),
              DropdownMenuItem(value: 'confirmed', child: Text('Confirmed')),
              DropdownMenuItem(value: 'preparing', child: Text('Preparing')),
              DropdownMenuItem(value: 'ready', child: Text('Ready')),
              DropdownMenuItem(value: 'picked_up', child: Text('Picked Up')),
              DropdownMenuItem(value: 'delivered', child: Text('Delivered')),
              DropdownMenuItem(value: 'cancelled', child: Text('Cancelled')),
            ],
            onChanged: onStatusChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildTable() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(AppRadius.sm),
      ),
      child: Column(
        children: [
          // Table header
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(AppRadius.sm),
                topRight: Radius.circular(AppRadius.sm),
              ),
            ),
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: [
                _buildHeaderCell('Order ID', flex: 2),
                _buildHeaderCell('Customer', flex: 3),
                _buildHeaderCell('Chef', flex: 3),
                _buildHeaderCell('Amount', flex: 2),
                _buildHeaderCell('Status', flex: 2),
                _buildHeaderCell('Date', flex: 2),
              ],
            ),
          ),

          // Table rows
          ...orders.asMap().entries.map((entry) {
            final index = entry.key;
            final order = entry.value;
            final isEven = index % 2 == 0;

            return Container(
              decoration: BoxDecoration(
                color:
                    isEven ? Colors.white : AppColors.surface.withOpacity(0.3),
              ),
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  _buildDataCell(
                    '#${order['id'] ?? 'N/A'}',
                    flex: 2,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildDataCell(order['customer'] ?? 'N/A', flex: 3),
                  _buildDataCell(order['chef'] ?? 'N/A', flex: 3),
                  _buildDataCell(
                    '\$${order['amount'] ?? '0.00'}',
                    flex: 2,
                    style: AppTextStyles.bodySmall.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  _buildDataCell(
                    '',
                    flex: 2,
                    child: _buildStatusBadge(order['status'] ?? 'unknown'),
                  ),
                  _buildDataCell(order['date'] ?? 'N/A', flex: 2),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildHeaderCell(String text, {int flex = 1}) {
    return Expanded(
      flex: flex,
      child: Text(
        text,
        style: AppTextStyles.bodySmall.copyWith(
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      ),
    );
  }

  Widget _buildDataCell(
    String text, {
    int flex = 1,
    TextStyle? style,
    Widget? child,
  }) {
    return Expanded(
      flex: flex,
      child: child ??
          Text(
            text,
            style: style ?? AppTextStyles.bodySmall,
          ),
    );
  }

  Widget _buildStatusBadge(String status) {
    Color color;
    String displayText;

    switch (status.toLowerCase()) {
      case 'pending':
        color = AppColors.warning;
        displayText = 'Pending';
        break;
      case 'confirmed':
      case 'preparing':
        color = AppColors.info;
        displayText = status == 'confirmed' ? 'Confirmed' : 'Preparing';
        break;
      case 'ready':
      case 'picked_up':
        color = AppColors.primary;
        displayText = status == 'ready' ? 'Ready' : 'Picked Up';
        break;
      case 'delivered':
        color = AppColors.success;
        displayText = 'Delivered';
        break;
      case 'cancelled':
        color = AppColors.error;
        displayText = 'Cancelled';
        break;
      default:
        color = AppColors.grey;
        displayText = 'Unknown';
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.xs),
      ),
      child: Text(
        displayText,
        style: AppTextStyles.caption.copyWith(
          color: color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xxxl),
      alignment: Alignment.center,
      child: Column(
        children: [
          Icon(
            Icons.receipt_long,
            size: 64,
            color: AppColors.greyLight,
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            'No orders found',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Page $currentPage of $totalPages',
          style: AppTextStyles.bodySmall.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Row(
          children: [
            IconButton(
              onPressed:
                  currentPage > 1 ? () => onPageChanged(currentPage - 1) : null,
              icon: const Icon(Icons.chevron_left),
              style: IconButton.styleFrom(
                backgroundColor: currentPage > 1
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surface,
                foregroundColor:
                    currentPage > 1 ? AppColors.primary : AppColors.greyLight,
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            IconButton(
              onPressed: currentPage < totalPages
                  ? () => onPageChanged(currentPage + 1)
                  : null,
              icon: const Icon(Icons.chevron_right),
              style: IconButton.styleFrom(
                backgroundColor: currentPage < totalPages
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.surface,
                foregroundColor: currentPage < totalPages
                    ? AppColors.primary
                    : AppColors.greyLight,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
