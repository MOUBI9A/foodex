import '../models/customer_preference.dart';

class CustomerPreferenceRepository {
  final Map<String, CustomerPreference> _store = {
    'customer_001': const CustomerPreference(
      customerId: 'customer_001',
      likedIngredients: ['tomato', 'mint', 'chicken'],
      dislikedIngredients: ['olive'],
      allergies: ['peanut'],
      dietFlags: ['no_pork'],
    ),
    'customer_002': const CustomerPreference(
      customerId: 'customer_002',
      likedIngredients: ['lamb', 'onion'],
      dislikedIngredients: ['cilantro'],
      allergies: ['shrimp'],
      dietFlags: ['no_gluten'],
    ),
  };

  Future<CustomerPreference> fetch(String customerId) async {
    return _store[customerId] ??
        CustomerPreference(
          customerId: customerId,
          likedIngredients: const [],
          dislikedIngredients: const [],
          allergies: const [],
          dietFlags: const [],
        );
  }
}
