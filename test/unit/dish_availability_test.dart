import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/data/models/dish.dart';
import 'package:food_delivery/data/models/ingredient.dart';
import 'package:food_delivery/features/chef/providers/dish_availability_provider.dart';
import 'package:food_delivery/features/chef/providers/ingredient_provider.dart';
import 'package:food_delivery/core/providers/dish_providers.dart';

class _StaticIngredientNotifier extends IngredientListNotifier {
  _StaticIngredientNotifier(this._ingredients);
  final List<Ingredient> _ingredients;
  @override
  Future<List<Ingredient>> build() async => _ingredients;
}

void main() {
  test('Dish availability detects expired and low stock ingredients', () async {
    final dishes = [
      Dish(
        id: 'dish-fresh',
        name: 'Salade',
        ingredients: const [IngredientUsage(ingredientId: 'ing-fresh', qty: 1)],
        price: 20,
        prepTime: 10,
        rating: 4,
      ),
      Dish(
        id: 'dish-expired',
        name: 'Soup',
        ingredients: const [IngredientUsage(ingredientId: 'ing-expired', qty: 1)],
        price: 25,
        prepTime: 15,
        rating: 4,
      ),
      Dish(
        id: 'dish-limited',
        name: 'Curry',
        ingredients: const [IngredientUsage(ingredientId: 'ing-low', qty: 2)],
        price: 30,
        prepTime: 20,
        rating: 4,
      ),
    ];

    final ingredients = [
      Ingredient(id: 'ing-fresh', name: 'Tomate', quantity: 10, unit: 'pcs'),
      Ingredient(
        id: 'ing-expired',
        name: 'Avocat',
        quantity: 5,
        unit: 'pcs',
        expiryDate: DateTime(2023, 1, 1),
      ),
      Ingredient(id: 'ing-low', name: 'Poulet', quantity: 4, unit: 'kg'),
    ];

    final container = ProviderContainer(overrides: [
      dishListProvider.overrideWith((ref) async => dishes),
      ingredientListProvider.overrideWith(() => _StaticIngredientNotifier(ingredients)),
    ]);

    await container.read(dishListProvider.future);
    await container.read(ingredientListProvider.future);
    final availability = container.read(dishAvailabilityProvider);
    expect(availability['dish-expired']?.status, DishAvailabilityStatus.unavailable);
    expect(availability['dish-limited']?.status, DishAvailabilityStatus.limited);
    expect(availability['dish-fresh']?.status, DishAvailabilityStatus.available);
  });
}
