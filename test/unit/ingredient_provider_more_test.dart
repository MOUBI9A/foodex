import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/chef/providers/ingredient_provider.dart';
import 'package:food_delivery/data/models/ingredient.dart';
import '../test_helpers/mock_path_provider.dart';

void main() {
  test('IngredientListProvider restock and discard flows', () async {
    await setUpMockPathProvider();
    final container = ProviderContainer();
    final notifier = container.read(ingredientListProvider.notifier);

    // Avoid asset-based seeding by adding a known ingredient manually
    await notifier.add(
      // id 'ing-001' to align with other parts of the app
      // quantity starts at 10
      // unit pcs
      // minimal fields used in test
      // ignore other optional fields
      // coverage of restock/discard flows
      //
      // Using constructor to ensure Hive adapters are exercised via repo
      // and provider update logic is hit.
      //
      // Note: Ingredient model is mutable; repo.write persists updated values.
      //
      // Create base ingredient
      // name 'Tomato'
      //
      // After add, proceed with restock/discard without loading assets.
      //
      // Using quantity 10 for clear arithmetic.
      //
      // Using default threshold 1 (not used here).
      //
      // expiryDate left null for simplicity.
      Ingredient(id: 'ing-001', name: 'Tomato', quantity: 10, unit: 'pcs'),
    );

    var list = await notifier.repo.getAll();
    final tomato = list.firstWhere((i) => i.id == 'ing-001');
    final initialQty = tomato.quantity;

    // Restock +5
    await notifier.restock(tomato.id, 5);
    list = await notifier.repo.getAll();
    final afterRestock = list.firstWhere((i) => i.id == 'ing-001');
    expect(afterRestock.quantity, initialQty + 5);

    // Discard partial 2
    await notifier.discard(tomato.id, qty: 2);
    list = await notifier.repo.getAll();
    final afterPartialDiscard = list.firstWhere((i) => i.id == 'ing-001');
    expect(afterPartialDiscard.quantity, initialQty + 5 - 2);

    // Discard all remaining
    await notifier.discard(tomato.id);
    list = await notifier.repo.getAll();
    expect(list.any((i) => i.id == 'ing-001'), isFalse);
  });
}
