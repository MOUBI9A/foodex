import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/customer_preference.dart';
import '../../data/repositories/customer_preference_repository.dart';

final customerPreferenceRepositoryProvider = Provider<CustomerPreferenceRepository>((ref) {
  return CustomerPreferenceRepository();
});

final customerPreferenceProvider =
    FutureProvider.family<CustomerPreference, String>((ref, customerId) async {
  final repo = ref.watch(customerPreferenceRepositoryProvider);
  return repo.fetch(customerId);
});
