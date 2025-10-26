// InventoryScreen: Chef's ingredient inventory with search, filters, and actions.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/ingredient_provider.dart';
import '../widgets/ingredient_card.dart';
import '../widgets/alerts_banner.dart';
import '../widgets/ingredient_form.dart';
import '../../../core/theme/app_spacing.dart';

class InventoryScreen extends ConsumerStatefulWidget {
  const InventoryScreen({super.key});

  @override
  ConsumerState<InventoryScreen> createState() => _InventoryScreenState();
}

class _InventoryScreenState extends ConsumerState<InventoryScreen> {
  final _searchCtrl = TextEditingController();
  String _filter = 'All';

  List _applyFilters(List items) {
    final q = _searchCtrl.text.trim().toLowerCase();
    return items.where((i) {
      final matchesQuery = q.isEmpty || i.name.toLowerCase().contains(q);
      bool matchesFilter = true;
      switch (_filter) {
        case 'Low':
          matchesFilter = i.isLowStock;
          break;
        case 'Expiring':
          matchesFilter = !i.isExpired && i.freshness < 40;
          break;
        case 'Expired':
          matchesFilter = i.isExpired;
          break;
        default:
          matchesFilter = true;
      }
      return matchesQuery && matchesFilter;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final ingredientsAsync = ref.watch(ingredientListProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const AlertsBanner(),
            const SizedBox(height: AppSpacing.lg),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchCtrl,
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      hintText: 'Search ingredients',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                DropdownButton<String>(
                  value: _filter,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All')),
                    DropdownMenuItem(value: 'Low', child: Text('Low')),
                    DropdownMenuItem(value: 'Expiring', child: Text('Expiring')),
                    DropdownMenuItem(value: 'Expired', child: Text('Expired')),
                  ],
                  onChanged: (v) => setState(() => _filter = v ?? 'All'),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: ingredientsAsync.when(
                data: (ingredients) {
                  final filtered = _applyFilters(ingredients);
                  if (filtered.isEmpty) {
                    return const Center(child: Text('No ingredients match your filters'));
                  }
                  return ListView.separated(
                    itemCount: filtered.length,
                    separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
                    itemBuilder: (context, i) => IngredientCard(ingredient: filtered[i]),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, st) => Center(child: Text('Error: $e')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (_) => IngredientForm(
              onSubmit: (ing) async {
                await ref.read(ingredientListProvider.notifier).add(ing);
              },
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
