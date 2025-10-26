import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/data/models/dish.dart';
import 'package:food_delivery/data/models/ingredient.dart';
import 'package:food_delivery/data/models/customer_preference.dart';
import 'package:food_delivery/features/customer/providers/recommendation_provider.dart';
import 'package:food_delivery/core/providers/dish_providers.dart';
import 'package:food_delivery/core/providers/customer_preference_provider.dart';
import 'package:food_delivery/features/chef/providers/ingredient_provider.dart';

class _StaticIngredientNotifier extends IngredientListNotifier {
  _StaticIngredientNotifier(this._ingredients);
  final List<Ingredient> _ingredients;

  @override
  Future<List<Ingredient>> build() async => _ingredients;
}

void main() {
  test('customerDishFeedProvider flags blocked dishes from allergies', () async {
    final dishes = [
      Dish(
        id: 'dish-safe',
        name: 'Couscous veggie',
        ingredients: const [IngredientUsage(ingredientId: 'ing-carrot', qty: 1)],
        price: 60,
        prepTime: 35,
        rating: 4.8,
      ),
      Dish(
        id: 'dish-allergen',
        name: 'Satay cacahuètes',
        ingredients: const [IngredientUsage(ingredientId: 'ing-peanut', qty: 0.2)],
        price: 55,
        prepTime: 25,
        rating: 4.6,
      ),
    ];
    final ingredients = [
      Ingredient(id: 'ing-carrot', name: 'Carotte', quantity: 10, unit: 'kg'),
      Ingredient(id: 'ing-peanut', name: 'Cacahuètes', quantity: 5, unit: 'kg'),
    ];

    final preference = const CustomerPreference(
      customerId: 'customer_001',
      likedIngredients: [],
      dislikedIngredients: [],
      allergies: ['cacahuètes'],
      dietFlags: [],
    );

    final container = ProviderContainer(overrides: [
      dishListProvider.overrideWith((ref) async => dishes),
      ingredientListProvider.overrideWith(() => _StaticIngredientNotifier(ingredients)),
      customerPreferenceProvider.overrideWith((ref, id) async => preference),
    ]);

    final results = await container.read(customerDishFeedProvider.future);
    expect(results.length, 2);
    final blocked = results.firstWhere((vm) => vm.dish.id == 'dish-allergen');
    expect(blocked.safety.isBlocked, isTrue);
    expect(blocked.canAddToCart, isFalse);
    final safe = results.firstWhere((vm) => vm.dish.id == 'dish-safe');
    expect(safe.canAddToCart, isTrue);
  });
}
