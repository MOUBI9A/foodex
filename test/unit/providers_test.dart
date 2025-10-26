import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/chef/providers/ingredient_provider.dart';
import 'package:food_delivery/data/models/ingredient.dart';
import '../test_helpers/mock_path_provider.dart';

void main() {
  test('IngredientListProvider can add and fetch', () async {
    // Ensure plugin calls are mocked for path_provider.
    await setUpMockPathProvider();
    final container = ProviderContainer();
    final notifier = container.read(ingredientListProvider.notifier);
    final ing = Ingredient(id: 'test', name: 'Test', quantity: 1, unit: 'pcs');
  await notifier.add(ing);
  final list = await notifier.repo.getAll();
  expect(list.any((i) => i.id == 'test'), isTrue);
  });
}
