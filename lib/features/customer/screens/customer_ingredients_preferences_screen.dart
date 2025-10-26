// Customer ingredient preferences screen with likes/dislikes/allergies management.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/customer_preferences_provider.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_radius.dart';

class CustomerIngredientsPreferencesScreen extends ConsumerStatefulWidget {
  const CustomerIngredientsPreferencesScreen({super.key});

  @override
  ConsumerState<CustomerIngredientsPreferencesScreen> createState() => _CustomerIngredientsPreferencesScreenState();
}

class _CustomerIngredientsPreferencesScreenState extends ConsumerState<CustomerIngredientsPreferencesScreen> {
  final _likedController = TextEditingController();
  final _dislikedController = TextEditingController();
  final _allergyController = TextEditingController();
  
  // Common ingredients for quick selection
  final List<String> _commonIngredients = [
    'Chicken', 'Beef', 'Fish', 'Shrimp', 'Tofu',
    'Tomato', 'Onion', 'Garlic', 'Pepper', 'Mushroom',
    'Cheese', 'Milk', 'Eggs', 'Butter', 'Cream',
    'Rice', 'Pasta', 'Bread', 'Flour', 'Oats',
    'Peanuts', 'Almonds', 'Walnuts', 'Soy', 'Gluten',
  ];

  @override
  void dispose() {
    _likedController.dispose();
    _dislikedController.dispose();
    _allergyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final preferencesAsync = ref.watch(customerPreferencesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ingredient Preferences', style: TextStyle(fontWeight: FontWeight.w700)),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: preferencesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, st) => Center(child: Text('Error: $e')),
        data: (preferences) => SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: AppSpacing.xl),

              // Liked Ingredients
              _buildSection(
                title: '💚 Liked Ingredients',
                description: 'We\'ll recommend dishes with these ingredients',
                items: preferences.likedIngredients,
                color: Colors.green,
                onAdd: (ingredient) async {
                  final updated = List<String>.from(preferences.likedIngredients)..add(ingredient);
                  await ref.read(customerPreferencesProvider.notifier).updateLikedIngredients(updated);
                },
                onRemove: (ingredient) async {
                  final updated = List<String>.from(preferences.likedIngredients)..remove(ingredient);
                  await ref.read(customerPreferencesProvider.notifier).updateLikedIngredients(updated);
                },
                controller: _likedController,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Disliked Ingredients
              _buildSection(
                title: '👎 Disliked Ingredients',
                description: 'We\'ll avoid dishes with these ingredients',
                items: preferences.dislikedIngredients,
                color: Colors.orange,
                onAdd: (ingredient) async {
                  final updated = List<String>.from(preferences.dislikedIngredients)..add(ingredient);
                  await ref.read(customerPreferencesProvider.notifier).updateDislikedIngredients(updated);
                },
                onRemove: (ingredient) async {
                  final updated = List<String>.from(preferences.dislikedIngredients)..remove(ingredient);
                  await ref.read(customerPreferencesProvider.notifier).updateDislikedIngredients(updated);
                },
                controller: _dislikedController,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Allergies
              _buildSection(
                title: '🚫 Allergies',
                description: 'Critical: Dishes with these ingredients will be hidden',
                items: preferences.allergies,
                color: Colors.red,
                onAdd: (ingredient) async {
                  final updated = List<String>.from(preferences.allergies)..add(ingredient);
                  await ref.read(customerPreferencesProvider.notifier).updateAllergies(updated);
                },
                onRemove: (ingredient) async {
                  final updated = List<String>.from(preferences.allergies)..remove(ingredient);
                  await ref.read(customerPreferencesProvider.notifier).updateAllergies(updated);
                },
                controller: _allergyController,
              ),

              const SizedBox(height: AppSpacing.xl),

              // Dietary Restrictions
              _buildDietaryRestrictions(preferences.dietaryRestrictions),

              const SizedBox(height: AppSpacing.xl),

              // Spice Level
              _buildSpiceLevel(preferences.spiceLevel),

              const SizedBox(height: AppSpacing.xl),

              // Quick Add from Common Ingredients
              _buildQuickAdd(),

              const SizedBox(height: AppSpacing.xl),

              // Save Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Preferences saved successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text('Save Preferences', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.primary.withValues(alpha: 0.1), Colors.white],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.restaurant_menu, color: AppColors.primary, size: 28),
              SizedBox(width: AppSpacing.md),
              Text(
                'Personalize Your Menu',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: AppColors.primary),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
            const Text(
            'Tell us what you love, dislike, or are allergic to. We\'ll customize dish recommendations just for you!',
            style: TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildSection({
    required String title,
    required String description,
    required List<String> items,
    required Color color,
    required Future<void> Function(String) onAdd,
    required Future<void> Function(String) onRemove,
    required TextEditingController controller,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        Text(description, style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: AppSpacing.md),
        
        // Add ingredient field
        Row(
          children: [
            Expanded(
              child: TextField(
                controller: controller,
                decoration: InputDecoration(
                  hintText: 'Type ingredient name',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
                ),
                onSubmitted: (value) async {
                  if (value.trim().isNotEmpty) {
                    await onAdd(value.trim());
                    controller.clear();
                  }
                },
              ),
            ),
            const SizedBox(width: AppSpacing.sm),
            ElevatedButton(
              onPressed: () async {
                if (controller.text.trim().isNotEmpty) {
                  await onAdd(controller.text.trim());
                  controller.clear();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: color,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: 16),
              ),
              child: const Icon(Icons.add),
            ),
          ],
        ),
        
        const SizedBox(height: AppSpacing.md),
        
        // Ingredient chips
        if (items.isEmpty)
          Container(
            padding: const EdgeInsets.all(AppSpacing.lg),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Center(
              child: Text('No ingredients added yet', style: TextStyle(color: Colors.grey)),
            ),
          )
        else
          Wrap(
            spacing: AppSpacing.sm,
            runSpacing: AppSpacing.sm,
            children: items.map((ingredient) {
              return Chip(
                label: Text(ingredient, style: const TextStyle(fontWeight: FontWeight.w500)),
                deleteIcon: const Icon(Icons.close, size: 18),
                onDeleted: () async {
                  await onRemove(ingredient);
                },
                backgroundColor: color.withValues(alpha: 0.1),
                deleteIconColor: color,
                side: BorderSide(color: color.withValues(alpha: 0.3)),
              );
            }).toList(),
          ),
      ],
    );
  }

  Widget _buildDietaryRestrictions(List<String> currentRestrictions) {
    final restrictions = ['Vegetarian', 'Vegan', 'Gluten-Free', 'Halal', 'Kosher', 'Dairy-Free', 'Nut-Free'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🥗 Dietary Restrictions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        Text('Select all that apply', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: restrictions.map((restriction) {
            final isSelected = currentRestrictions.contains(restriction);
            return FilterChip(
              label: Text(restriction),
              selected: isSelected,
              onSelected: (selected) async {
                final updated = List<String>.from(currentRestrictions);
                if (selected) {
                  updated.add(restriction);
                } else {
                  updated.remove(restriction);
                }
                await ref.read(customerPreferencesProvider.notifier).updateDietaryRestrictions(updated);
              },
              selectedColor: Colors.blue.withValues(alpha: 0.2),
              checkmarkColor: Colors.blue,
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSpiceLevel(int currentLevel) {
    final levels = ['None', 'Mild', 'Medium', 'Hot', 'Extra Hot'];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('🌶️ Spice Level', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.md),
        Slider(
          value: currentLevel.toDouble(),
          min: 0,
          max: 4,
          divisions: 4,
          label: levels[currentLevel],
          activeColor: AppColors.primary,
          onChanged: (value) async {
            await ref.read(customerPreferencesProvider.notifier).updateSpiceLevel(value.toInt());
          },
        ),
        Center(
          child: Text(
            levels[currentLevel],
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.primary),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickAdd() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('⚡ Quick Add', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        const SizedBox(height: AppSpacing.sm),
        Text('Tap to quickly add common ingredients', style: TextStyle(fontSize: 13, color: Colors.grey[600])),
        const SizedBox(height: AppSpacing.md),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: _commonIngredients.map((ingredient) {
            return ActionChip(
              label: Text(ingredient, style: const TextStyle(fontSize: 13)),
              avatar: const Icon(Icons.add, size: 16),
              onPressed: () {
                _showQuickAddDialog(ingredient);
              },
              backgroundColor: Colors.grey[200],
            );
          }).toList(),
        ),
      ],
    );
  }

  void _showQuickAddDialog(String ingredient) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Add "$ingredient"'),
        content: const Text('Where would you like to add this ingredient?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              final prefs = ref.read(customerPreferencesProvider).valueOrNull;
              if (prefs != null) {
                final updated = List<String>.from(prefs.likedIngredients)..add(ingredient);
                await ref.read(customerPreferencesProvider.notifier).updateLikedIngredients(updated);
              }
              Navigator.pop(context);
            },
            child: const Text('💚 Liked', style: TextStyle(color: Colors.green)),
          ),
          TextButton(
            onPressed: () async {
              final prefs = ref.read(customerPreferencesProvider).valueOrNull;
              if (prefs != null) {
                final updated = List<String>.from(prefs.dislikedIngredients)..add(ingredient);
                await ref.read(customerPreferencesProvider.notifier).updateDislikedIngredients(updated);
              }
              Navigator.pop(context);
            },
            child: const Text('👎 Disliked', style: TextStyle(color: Colors.orange)),
          ),
          TextButton(
            onPressed: () async {
              final prefs = ref.read(customerPreferencesProvider).valueOrNull;
              if (prefs != null) {
                final updated = List<String>.from(prefs.allergies)..add(ingredient);
                await ref.read(customerPreferencesProvider.notifier).updateAllergies(updated);
              }
              Navigator.pop(context);
            },
            child: const Text('🚫 Allergy', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
