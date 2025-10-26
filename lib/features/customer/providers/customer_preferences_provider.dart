// Customer preferences provider with Riverpod.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/customer_preferences.dart';
import '../../../data/repositories/customer_preferences_repository.dart';

final customerPreferencesRepositoryProvider = Provider<CustomerPreferencesRepository>((ref) {
  return CustomerPreferencesRepository();
});

final customerPreferencesProvider = AsyncNotifierProvider<CustomerPreferencesNotifier, CustomerPreferences>(
  CustomerPreferencesNotifier.new,
);

class CustomerPreferencesNotifier extends AsyncNotifier<CustomerPreferences> {
  CustomerPreferencesRepository get repo => ref.read(customerPreferencesRepositoryProvider);

  @override
  Future<CustomerPreferences> build() async {
    // Load preferences for current user (mock ID for now)
    final prefs = await repo.getPreferences('customer_001');
    return prefs ?? CustomerPreferences(customerId: 'customer_001');
  }

  Future<void> updateLikedIngredients(List<String> ingredients) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    final updated = CustomerPreferences(
      customerId: current.customerId,
      likedIngredients: ingredients,
      dislikedIngredients: current.dislikedIngredients,
      allergies: current.allergies,
      dietaryRestrictions: current.dietaryRestrictions,
      spiceLevel: current.spiceLevel,
      favoriteCuisines: current.favoriteCuisines,
      organicPreference: current.organicPreference,
      updatedAt: DateTime.now(),
    );
    
    await repo.savePreferences(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> updateDislikedIngredients(List<String> ingredients) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    final updated = CustomerPreferences(
      customerId: current.customerId,
      likedIngredients: current.likedIngredients,
      dislikedIngredients: ingredients,
      allergies: current.allergies,
      dietaryRestrictions: current.dietaryRestrictions,
      spiceLevel: current.spiceLevel,
      favoriteCuisines: current.favoriteCuisines,
      organicPreference: current.organicPreference,
      updatedAt: DateTime.now(),
    );
    
    await repo.savePreferences(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> updateAllergies(List<String> allergies) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    final updated = CustomerPreferences(
      customerId: current.customerId,
      likedIngredients: current.likedIngredients,
      dislikedIngredients: current.dislikedIngredients,
      allergies: allergies,
      dietaryRestrictions: current.dietaryRestrictions,
      spiceLevel: current.spiceLevel,
      favoriteCuisines: current.favoriteCuisines,
      organicPreference: current.organicPreference,
      updatedAt: DateTime.now(),
    );
    
    await repo.savePreferences(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> updateDietaryRestrictions(List<String> restrictions) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    final updated = CustomerPreferences(
      customerId: current.customerId,
      likedIngredients: current.likedIngredients,
      dislikedIngredients: current.dislikedIngredients,
      allergies: current.allergies,
      dietaryRestrictions: restrictions,
      spiceLevel: current.spiceLevel,
      favoriteCuisines: current.favoriteCuisines,
      organicPreference: current.organicPreference,
      updatedAt: DateTime.now(),
    );
    
    await repo.savePreferences(updated);
    state = AsyncValue.data(updated);
  }

  Future<void> updateSpiceLevel(int level) async {
    final current = state.valueOrNull;
    if (current == null) return;
    
    final updated = CustomerPreferences(
      customerId: current.customerId,
      likedIngredients: current.likedIngredients,
      dislikedIngredients: current.dislikedIngredients,
      allergies: current.allergies,
      dietaryRestrictions: current.dietaryRestrictions,
      spiceLevel: level,
      favoriteCuisines: current.favoriteCuisines,
      organicPreference: current.organicPreference,
      updatedAt: DateTime.now(),
    );
    
    await repo.savePreferences(updated);
    state = AsyncValue.data(updated);
  }
}
