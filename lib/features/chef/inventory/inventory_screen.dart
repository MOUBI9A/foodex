import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/ingredient.dart';
import '../../../core/providers/ingredient_provider.dart';
import '../../../core/theme/color_system_v2.dart';
import 'widgets/ingredient_card.dart';
import 'widgets/alerts_banner.dart';
import 'widgets/ingredient_form_dialog.dart';
import 'widgets/restock_modal.dart';

/// Chef Inventory Management Screen
class ChefInventoryScreen extends ConsumerStatefulWidget {
  final String chefId;

  const ChefInventoryScreen({
    super.key,
    required this.chefId,
  });

  @override
  ConsumerState<ChefInventoryScreen> createState() =>
      _ChefInventoryScreenState();
}

class _ChefInventoryScreenState extends ConsumerState<ChefInventoryScreen> {
  String _searchQuery = '';
  IngredientCategory? _selectedCategory;
  StorageType? _selectedStorageType;
  String _sortBy = 'name'; // name, expiry, freshness, quantity

  @override
  Widget build(BuildContext context) {
    final ingredientsAsync =
        ref.watch(ingredientNotifierProvider(widget.chefId));
    final alertCounts = ref.watch(ingredientAlertCountsProvider(widget.chefId));

    return Scaffold(
      backgroundColor: TColorV2.background,
      appBar: AppBar(
        title: const Text(
          'Ingredient Inventory',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: TColorV2.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.add_circle_outline),
            tooltip: 'Add Ingredient',
            onPressed: () => _showAddIngredientDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh',
            onPressed: () {
              ref
                  .read(ingredientNotifierProvider(widget.chefId).notifier)
                  .refresh();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Alerts Banner
          alertCounts.when(
            data: (counts) => AlertsBanner(
              alertCounts: counts,
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),

          // Search and Filter Bar
          _buildSearchAndFilterBar(),

          // Ingredients List
          Expanded(
            child: ingredientsAsync.when(
              data: (ingredients) {
                final filteredIngredients =
                    _filterAndSortIngredients(ingredients);

                if (filteredIngredients.isEmpty) {
                  return _buildEmptyState();
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await ref
                        .read(
                            ingredientNotifierProvider(widget.chefId).notifier)
                        .refresh();
                  },
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredIngredients.length,
                    itemBuilder: (context, index) {
                      final ingredient = filteredIngredients[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: IngredientCard(
                          ingredient: ingredient,
                          onEdit: () => _showEditIngredientDialog(
                            context,
                            ingredient,
                          ),
                          onRestock: () => _showRestockModal(
                            context,
                            ingredient,
                          ),
                          onDiscard: () => _showDiscardDialog(
                            context,
                            ingredient,
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: TColorV2.error,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Error loading ingredients',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: TColorV2.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      error.toString(),
                      style: TextStyle(
                        color: TColorV2.textSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        ref
                            .read(ingredientNotifierProvider(widget.chefId)
                                .notifier)
                            .refresh();
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: TColorV2.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Search Bar
          TextField(
            decoration: InputDecoration(
              hintText: 'Search ingredients...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchQuery.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchQuery = '';
                        });
                      },
                    )
                  : null,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(color: TColorV2.neutral300),
              ),
              filled: true,
              fillColor: TColorV2.neutral100,
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          const SizedBox(height: 12),

          // Filter Chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                // Category Filter
                _buildFilterChip(
                  label: _selectedCategory?.label ?? 'All Categories',
                  icon: Icons.category,
                  onTap: () => _showCategoryFilter(),
                ),
                const SizedBox(width: 8),

                // Storage Filter
                _buildFilterChip(
                  label: _selectedStorageType?.label ?? 'All Storage',
                  icon: Icons.kitchen,
                  onTap: () => _showStorageFilter(),
                ),
                const SizedBox(width: 8),

                // Sort
                _buildFilterChip(
                  label: 'Sort: ${_getSortLabel()}',
                  icon: Icons.sort,
                  onTap: () => _showSortOptions(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: TColorV2.primarySubtle,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: TColorV2.primary.withValues(alpha: 0.3)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: TColorV2.primary),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                color: TColorV2.primary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inventory_2_outlined,
            size: 80,
            color: TColorV2.neutral400,
          ),
          const SizedBox(height: 16),
          Text(
            _searchQuery.isNotEmpty
                ? 'No ingredients found'
                : 'No ingredients yet',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: TColorV2.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _searchQuery.isNotEmpty
                ? 'Try adjusting your search or filters'
                : 'Start by adding your first ingredient',
            style: TextStyle(
              color: TColorV2.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => _showAddIngredientDialog(context),
            icon: const Icon(Icons.add),
            label: const Text('Add Ingredient'),
            style: ElevatedButton.styleFrom(
              backgroundColor: TColorV2.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Ingredient> _filterAndSortIngredients(List<Ingredient> ingredients) {
    var filtered = ingredients;

    // Apply search filter
    if (_searchQuery.isNotEmpty) {
      filtered = filtered
          .where((ing) =>
              ing.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }

    // Apply category filter
    if (_selectedCategory != null) {
      filtered =
          filtered.where((ing) => ing.category == _selectedCategory).toList();
    }

    // Apply storage type filter
    if (_selectedStorageType != null) {
      filtered = filtered
          .where((ing) => ing.storageType == _selectedStorageType)
          .toList();
    }

    // Apply sorting
    switch (_sortBy) {
      case 'name':
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;
      case 'expiry':
        filtered.sort((a, b) {
          if (a.expiryDate == null) return 1;
          if (b.expiryDate == null) return -1;
          return a.expiryDate!.compareTo(b.expiryDate!);
        });
        break;
      case 'freshness':
        filtered.sort((a, b) => a.freshnessScore.compareTo(b.freshnessScore));
        break;
      case 'quantity':
        filtered.sort((a, b) => a.quantity.compareTo(b.quantity));
        break;
    }

    return filtered;
  }

  String _getSortLabel() {
    switch (_sortBy) {
      case 'name':
        return 'Name';
      case 'expiry':
        return 'Expiry';
      case 'freshness':
        return 'Freshness';
      case 'quantity':
        return 'Quantity';
      default:
        return 'Name';
    }
  }

  void _showCategoryFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Category',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColorV2.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('All Categories'),
              leading: const Icon(Icons.clear_all),
              onTap: () {
                setState(() {
                  _selectedCategory = null;
                });
                Navigator.pop(context);
              },
            ),
            ...IngredientCategory.values.map((category) {
              return ListTile(
                title: Text(category.label),
                leading: Icon(
                  _selectedCategory == category
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: _selectedCategory == category
                      ? TColorV2.primary
                      : TColorV2.neutral400,
                ),
                onTap: () {
                  setState(() {
                    _selectedCategory = category;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showStorageFilter() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Filter by Storage Type',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColorV2.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('All Storage Types'),
              leading: const Icon(Icons.clear_all),
              onTap: () {
                setState(() {
                  _selectedStorageType = null;
                });
                Navigator.pop(context);
              },
            ),
            ...StorageType.values.map((type) {
              return ListTile(
                title: Text(type.label),
                leading: Icon(
                  _selectedStorageType == type
                      ? Icons.check_circle
                      : Icons.circle_outlined,
                  color: _selectedStorageType == type
                      ? TColorV2.primary
                      : TColorV2.neutral400,
                ),
                onTap: () {
                  setState(() {
                    _selectedStorageType = type;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showSortOptions() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Sort By',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: TColorV2.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            ...[
              {'value': 'name', 'label': 'Name', 'icon': Icons.sort_by_alpha},
              {'value': 'expiry', 'label': 'Expiry Date', 'icon': Icons.event},
              {'value': 'freshness', 'label': 'Freshness', 'icon': Icons.eco},
              {
                'value': 'quantity',
                'label': 'Quantity',
                'icon': Icons.inventory_2
              },
            ].map((option) {
              return ListTile(
                title: Text(option['label'] as String),
                leading: Icon(
                  _sortBy == option['value']
                      ? Icons.check_circle
                      : option['icon'] as IconData,
                  color: _sortBy == option['value']
                      ? TColorV2.primary
                      : TColorV2.neutral400,
                ),
                onTap: () {
                  setState(() {
                    _sortBy = option['value'] as String;
                  });
                  Navigator.pop(context);
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showAddIngredientDialog(BuildContext context) async {
    final result = await showDialog<Ingredient>(
      context: context,
      builder: (context) => IngredientFormDialog(
        chefId: widget.chefId,
      ),
    );

    if (result != null && context.mounted) {
      await ref
          .read(ingredientNotifierProvider(widget.chefId).notifier)
          .add(result);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.name} added successfully'),
            backgroundColor: TColorV2.success,
          ),
        );
      }
    }
  }

  void _showEditIngredientDialog(
      BuildContext context, Ingredient ingredient) async {
    final result = await showDialog<Ingredient>(
      context: context,
      builder: (context) => IngredientFormDialog(
        chefId: widget.chefId,
        ingredient: ingredient,
      ),
    );

    if (result != null && context.mounted) {
      await ref
          .read(ingredientNotifierProvider(widget.chefId).notifier)
          .update(result);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${result.name} updated successfully'),
            backgroundColor: TColorV2.success,
          ),
        );
      }
    }
  }

  void _showRestockModal(BuildContext context, Ingredient ingredient) async {
    final result = await showDialog<Map<String, dynamic>>(
      context: context,
      builder: (context) => RestockModal(
        ingredient: ingredient,
      ),
    );

    if (result != null && context.mounted) {
      await ref
          .read(ingredientNotifierProvider(widget.chefId).notifier)
          .restock(
            ingredient.id,
            result['quantity'] as double,
            expiryDate: result['expiryDate'] as DateTime?,
            costPerUnit: result['cost'] as double?,
          );

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${ingredient.name} restocked successfully'),
            backgroundColor: TColorV2.success,
          ),
        );
      }
    }
  }

  void _showDiscardDialog(BuildContext context, Ingredient ingredient) {
    final reasonController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Discard Ingredient'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to discard ${ingredient.quantity} ${ingredient.unit} of ${ingredient.name}?',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason',
                hintText: 'e.g., Expired, Damaged, Spoiled',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await ref
                  .read(ingredientNotifierProvider(widget.chefId).notifier)
                  .discard(
                    ingredient.id,
                    reasonController.text.isEmpty
                        ? 'Discarded'
                        : reasonController.text,
                  );
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('${ingredient.name} discarded'),
                    backgroundColor: TColorV2.success,
                  ),
                );
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: TColorV2.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Discard'),
          ),
        ],
      ),
    );
  }
}
