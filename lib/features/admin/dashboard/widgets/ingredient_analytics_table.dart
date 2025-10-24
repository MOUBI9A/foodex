import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/ingredient.dart';
import '../../../../core/theme/color_system_v2.dart';

/// Ingredient Analytics Table with Search, Filter, Sort, and Export
class IngredientAnalyticsTable extends StatefulWidget {
  final List<Ingredient> ingredients;

  const IngredientAnalyticsTable({
    super.key,
    required this.ingredients,
  });

  @override
  State<IngredientAnalyticsTable> createState() =>
      _IngredientAnalyticsTableState();
}

class _IngredientAnalyticsTableState extends State<IngredientAnalyticsTable> {
  String _searchQuery = '';
  IngredientCategory? _selectedCategory;
  StorageType? _selectedStorageType;
  int _sortColumnIndex = 0;
  bool _sortAscending = true;

  List<Ingredient> get _filteredIngredients {
    var filtered = widget.ingredients;

    // Search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where(
              (i) => i.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Category filter
    if (_selectedCategory != null) {
      filtered =
          filtered.where((i) => i.category == _selectedCategory).toList();
    }

    // Storage filter
    if (_selectedStorageType != null) {
      filtered =
          filtered.where((i) => i.storageType == _selectedStorageType).toList();
    }

    // Sort
    filtered.sort((a, b) {
      int comparison;
      switch (_sortColumnIndex) {
        case 0: // Name
          comparison = a.name.compareTo(b.name);
          break;
        case 1: // Category
          comparison = a.category.label.compareTo(b.category.label);
          break;
        case 2: // Quantity
          comparison = a.quantity.compareTo(b.quantity);
          break;
        case 3: // Freshness
          comparison = a.freshnessScore.compareTo(b.freshnessScore);
          break;
        case 4: // Expiry
          if (a.expiryDate == null && b.expiryDate == null) {
            comparison = 0;
          } else if (a.expiryDate == null) {
            comparison = 1;
          } else if (b.expiryDate == null) {
            comparison = -1;
          } else {
            comparison = a.expiryDate!.compareTo(b.expiryDate!);
          }
          break;
        case 5: // Storage
          comparison = a.storageType.label.compareTo(b.storageType.label);
          break;
        case 6: // Value
          final aValue = a.quantity * a.costPerUnit;
          final bValue = b.quantity * b.costPerUnit;
          comparison = aValue.compareTo(bValue);
          break;
        default:
          comparison = 0;
      }
      return _sortAscending ? comparison : -comparison;
    });

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredIngredients;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(Icons.table_chart, color: TColorV2.primary, size: 24),
                const SizedBox(width: 12),
                Text(
                  'Ingredient Inventory Table',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: TColorV2.textPrimary,
                  ),
                ),
                const Spacer(),
                Text(
                  '${filtered.length} of ${widget.ingredients.length} items',
                  style: TextStyle(
                    fontSize: 14,
                    color: TColorV2.textSecondary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Search and Filters
            Wrap(
              spacing: 16,
              runSpacing: 12,
              children: [
                // Search
                SizedBox(
                  width: 300,
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search ingredients...',
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    onChanged: (value) {
                      setState(() => _searchQuery = value);
                    },
                  ),
                ),

                // Category Filter
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<IngredientCategory?>(
                    value: _selectedCategory,
                    decoration: InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Categories'),
                      ),
                      ...IngredientCategory.values.map((category) {
                        return DropdownMenuItem(
                          value: category,
                          child: Text(category.label),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedCategory = value);
                    },
                  ),
                ),

                // Storage Filter
                SizedBox(
                  width: 200,
                  child: DropdownButtonFormField<StorageType?>(
                    value: _selectedStorageType,
                    decoration: InputDecoration(
                      labelText: 'Storage',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                    ),
                    items: [
                      const DropdownMenuItem(
                        value: null,
                        child: Text('All Storage Types'),
                      ),
                      ...StorageType.values.map((storage) {
                        return DropdownMenuItem(
                          value: storage,
                          child: Text(storage.label),
                        );
                      }),
                    ],
                    onChanged: (value) {
                      setState(() => _selectedStorageType = value);
                    },
                  ),
                ),

                // Export Button
                ElevatedButton.icon(
                  onPressed: _exportToCsv,
                  icon: const Icon(Icons.download),
                  label: const Text('Export CSV'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: TColorV2.secondary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20,
                      vertical: 16,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Table
            SizedBox(
              height: 400,
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SingleChildScrollView(
                  child: DataTable(
                    columnSpacing: 16,
                    horizontalMargin: 16,
                    sortColumnIndex: _sortColumnIndex,
                    sortAscending: _sortAscending,
                    columns: [
                      DataColumn(
                        label: const Text('Name'),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                          });
                        },
                      ),
                      DataColumn(
                        label: const Text('Category'),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                          });
                        },
                      ),
                      DataColumn(
                        label: const Text('Quantity'),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                          });
                        },
                      ),
                      DataColumn(
                        label: const Text('Freshness'),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                          });
                        },
                      ),
                      DataColumn(
                        label: const Text('Expiry Date'),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                          });
                        },
                      ),
                      DataColumn(
                        label: const Text('Storage'),
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                          });
                        },
                      ),
                      DataColumn(
                        label: const Text('Value'),
                        numeric: true,
                        onSort: (columnIndex, ascending) {
                          setState(() {
                            _sortColumnIndex = columnIndex;
                            _sortAscending = ascending;
                          });
                        },
                      ),
                      const DataColumn(
                        label: Text('Status'),
                      ),
                    ],
                    rows: filtered.map((ingredient) {
                      return DataRow(
                        cells: [
                          DataCell(Text(
                            ingredient.name,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          )),
                          DataCell(Text(ingredient.category.label)),
                          DataCell(Text(
                            '${ingredient.quantity.toStringAsFixed(1)} ${ingredient.unit}',
                          )),
                          DataCell(_buildFreshnessCell(ingredient)),
                          DataCell(Text(
                            ingredient.expiryDate != null
                                ? DateFormat('MMM dd, yyyy')
                                    .format(ingredient.expiryDate!)
                                : 'N/A',
                          )),
                          DataCell(Text(ingredient.storageType.label)),
                          DataCell(Text(
                            '\$${(ingredient.quantity * ingredient.costPerUnit).toStringAsFixed(2)}',
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          )),
                          DataCell(_buildStatusBadge(ingredient)),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFreshnessCell(Ingredient ingredient) {
    final color = _getFreshnessColor(ingredient.freshnessScore);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 60,
          height: 8,
          decoration: BoxDecoration(
            color: TColorV2.neutral200,
            borderRadius: BorderRadius.circular(4),
          ),
          child: FractionallySizedBox(
            alignment: Alignment.centerLeft,
            widthFactor: ingredient.freshnessScore / 100,
            child: Container(
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          '${ingredient.freshnessScore.toStringAsFixed(0)}%',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.bold,
            fontSize: 12,
          ),
        ),
      ],
    );
  }

  Widget _buildStatusBadge(Ingredient ingredient) {
    String label;
    Color color;

    if (ingredient.isExpired) {
      label = 'Expired';
      color = TColorV2.error;
    } else if (ingredient.isExpiringSoon) {
      label = 'Expiring';
      color = TColorV2.warning;
    } else if (ingredient.isLowStock) {
      label = 'Low Stock';
      color = TColorV2.warning;
    } else {
      label = 'Good';
      color = TColorV2.success;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Color _getFreshnessColor(double freshness) {
    if (freshness >= 70) return TColorV2.success;
    if (freshness >= 40) return TColorV2.warning;
    return TColorV2.error;
  }

  void _exportToCsv() {
    // Generate CSV data
    final csv = StringBuffer();
    csv.writeln(
        'Name,Category,Quantity,Unit,Freshness (%),Expiry Date,Storage,Cost per Unit,Total Value,Status');

    for (final ingredient in _filteredIngredients) {
      String status;
      if (ingredient.isExpired) {
        status = 'Expired';
      } else if (ingredient.isExpiringSoon) {
        status = 'Expiring Soon';
      } else if (ingredient.isLowStock) {
        status = 'Low Stock';
      } else {
        status = 'Good';
      }

      csv.writeln([
        ingredient.name,
        ingredient.category.label,
        ingredient.quantity.toStringAsFixed(2),
        ingredient.unit,
        ingredient.freshnessScore.toStringAsFixed(1),
        ingredient.expiryDate != null
            ? DateFormat('yyyy-MM-dd').format(ingredient.expiryDate!)
            : 'N/A',
        ingredient.storageType.label,
        ingredient.costPerUnit.toStringAsFixed(2),
        (ingredient.quantity * ingredient.costPerUnit).toStringAsFixed(2),
        status,
      ].join(','));
    }

    // Show dialog with CSV preview (in production, trigger download)
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Export CSV'),
        content: SizedBox(
          width: 600,
          height: 400,
          child: SingleChildScrollView(
            child: SelectableText(
              csv.toString(),
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // In production: trigger file download
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('CSV export would download here'),
                  backgroundColor: TColorV2.success,
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.download),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColorV2.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
