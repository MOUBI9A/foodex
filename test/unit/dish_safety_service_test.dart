import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/core/services/dish_safety_service.dart';
import 'package:food_delivery/data/models/dish.dart';
import 'package:food_delivery/data/models/ingredient.dart';
import 'package:food_delivery/data/models/customer_preference.dart';

void main() {
  test('DishSafetyService blocks allergens and diet flags', () {
    final service = DishSafetyService();
    final dish = Dish(
      id: 'dish',
      name: 'Sandwich bacon',
      ingredients: const [IngredientUsage(ingredientId: 'ing-bacon', qty: 1)],
      price: 40,
      prepTime: 12,
      rating: 4.2,
    );
    final preference = const CustomerPreference(
      customerId: 'c1',
      likedIngredients: [],
      dislikedIngredients: [],
      allergies: ['bacon'],
      dietFlags: ['no_pork'],
    );
    final ingredientMap = {
      'ing-bacon': Ingredient(id: 'ing-bacon', name: 'Bacon', quantity: 5, unit: 'pcs'),
    };

    final result = service.evaluate(dish: dish, preference: preference, ingredientLookup: ingredientMap);
    expect(result.isBlocked, isTrue);
    expect(result.warnings, isNotEmpty);
  });
}
