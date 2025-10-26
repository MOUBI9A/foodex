import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/customer/providers/taste_profile_provider.dart';
import 'package:food_delivery/data/models/taste_profile.dart';
import '../test_helpers/mock_path_provider.dart';

void main() {
  test('TasteProfileProvider save and clear', () async {
    await setUpMockPathProvider();
    final container = ProviderContainer();

    // Initially null
  final initial = await container.read(tasteProfileProvider.future);
    expect(initial, isNull);

    // Save
    const profile = TasteProfile(
      likedIngredients: ['ing-001'],
      dislikedIngredients: ['ing-002'],
      cuisines: ['Moroccan'],
      prefersSpicy: true,
    );
  await container.read(tasteProfileProvider.notifier).save(profile);

  final saved = await container.read(tasteProfileProvider.future);
    expect(saved, isNotNull);
    expect(saved!.likedIngredients, contains('ing-001'));

    // Clear
  await container.read(tasteProfileProvider.notifier).clear();
  final cleared = await container.read(tasteProfileProvider.future);
    expect(cleared, isNull);
  });
}
