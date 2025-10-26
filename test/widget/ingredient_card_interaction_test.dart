import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/chef/widgets/ingredient_card.dart';
import 'package:food_delivery/features/chef/providers/ingredient_provider.dart';
import 'package:food_delivery/data/models/ingredient.dart';

class _FakeIngredientNotifier extends IngredientListNotifier {
  int updateCalls = 0;
  int restockCalls = 0;
  int discardCalls = 0;
  Ingredient? lastUpdated;
  String? lastRestockId;
  double? lastRestockQty;
  DateTime? lastRestockExpiry;
  String? lastDiscardId;
  double? lastDiscardQty;

  @override
  Future<List<Ingredient>> build() async {
    return <Ingredient>[];
  }

  @override
  Future<void> updateIngredient(Ingredient ing) async {
    updateCalls++;
    lastUpdated = ing;
  }

  @override
  Future<void> restock(String id, double qty, {DateTime? expiry}) async {
    restockCalls++;
    lastRestockId = id;
    lastRestockQty = qty;
    lastRestockExpiry = expiry;
  }

  @override
  Future<void> discard(String id, {double? qty}) async {
    discardCalls++;
    lastDiscardId = id;
    lastDiscardQty = qty;
  }
}

void main() {
  testWidgets('IngredientCard edit and restock invoke notifier methods', (tester) async {
    final fakeNotifier = _FakeIngredientNotifier();

    final overrides = [
      ingredientListProvider.overrideWith(() => fakeNotifier),
    ];

    final ingredient = Ingredient(
      id: 'ing-x',
      name: 'Lettuce',
      quantity: 2,
      unit: 'pcs',
      threshold: 1,
      freshness: 35, // show expiring chip
      expiryDate: DateTime.now().add(const Duration(days: 2)),
    );

    await tester.pumpWidget(ProviderScope(
      overrides: overrides,
      child: MaterialApp(home: Scaffold(body: IngredientCard(ingredient: ingredient))),
    ));

    // Tap edit icon and submit the form with changed name
    await tester.tap(find.byIcon(Icons.edit));
    await tester.pumpAndSettle();

    expect(find.text('Edit Ingredient'), findsOneWidget);

    await tester.enterText(find.widgetWithText(TextFormField, 'Name'), 'Lettuce Edited');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Save'));
    await tester.pumpAndSettle();

    expect(fakeNotifier.updateCalls, 1);
    expect(fakeNotifier.lastUpdated?.name, 'Lettuce Edited');

    // Tap restock icon and add 3
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('Restock Ingredient'), findsOneWidget);

    // Fill quantity
    await tester.enterText(find.widgetWithText(TextFormField, 'Quantity'), '3');
    await tester.tap(find.widgetWithText(ElevatedButton, 'Restock'));
    await tester.pumpAndSettle();

    expect(fakeNotifier.restockCalls, 1);
    expect(fakeNotifier.lastRestockId, 'ing-x');
    expect(fakeNotifier.lastRestockQty, 3);

    // Tap delete icon
    await tester.tap(find.byIcon(Icons.delete));
    await tester.pumpAndSettle();

    expect(fakeNotifier.discardCalls, 1);
    expect(fakeNotifier.lastDiscardId, 'ing-x');
  });
}
