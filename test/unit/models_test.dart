import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/data/models/ingredient.dart';
import 'package:food_delivery/data/models/ingredient_history_item.dart';

void main() {
  test('Ingredient toJson/fromJson round-trip', () {
    final ing = Ingredient(
      id: 'ing-001',
      name: 'Tomato',
      quantity: 3,
      unit: 'pcs',
      threshold: 1,
      category: 'Vegetable',
      storageType: 'dry',
      history: [
        IngredientHistoryItem(action: 'added', qty: 3, date: DateTime(2025, 1, 1)),
      ],
    );
    final json = ing.toJson();
    final back = Ingredient.fromJson(json);
    expect(back.id, ing.id);
    expect(back.name, ing.name);
    expect(back.quantity, ing.quantity);
    expect(back.history.first.action, 'added');
  });
}
