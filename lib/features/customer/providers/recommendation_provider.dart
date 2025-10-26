import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/dish.dart';
import '../../../data/models/chef_profile.dart';
import '../../../core/providers/dish_providers.dart';
import '../../../core/providers/customer_preference_provider.dart';
import '../../../core/providers/chef_directory_provider.dart';
import '../../../core/providers/service_providers.dart';
import '../../../core/services/dish_safety_service.dart';
import '../../../core/services/delivery_estimate_service.dart';
import '../../chef/providers/ingredient_provider.dart';
import '../../chef/providers/dish_availability_provider.dart';

const _defaultCustomerLat = 33.5724;
const _defaultCustomerLng = -7.6223;

class CustomerDishViewModel {
  final Dish dish;
  final DishAvailability availability;
  final DishSafetyResult safety;
  final DeliveryEstimate estimate;
  final ChefProfile? chef;

  const CustomerDishViewModel({
    required this.dish,
    required this.availability,
    required this.safety,
    required this.estimate,
    required this.chef,
  });

  bool get canAddToCart =>
      !safety.isBlocked && availability.status != DishAvailabilityStatus.unavailable;
}

final customerDishFeedProvider = FutureProvider<List<CustomerDishViewModel>>((ref) async {
  final dishes = await ref.watch(dishListProvider.future);
  final ingredients = await ref.watch(ingredientListProvider.future);
  final preference = await ref.watch(customerPreferenceProvider('customer_001').future);
  final availabilityMap = ref.watch(dishAvailabilityProvider);
  final ingredientMap = {for (final ingredient in ingredients) ingredient.id: ingredient};
  final chefDirectory = ref.watch(chefDirectoryProvider);
  final safetyService = ref.watch(dishSafetyServiceProvider);
  final deliveryService = ref.watch(deliveryEstimateServiceProvider);

  double ratingScore(Dish dish) => dish.rating;

  final vms = dishes.map((dish) {
    final availability = availabilityMap[dish.id] ??
        DishAvailability(dishId: dish.id, status: DishAvailabilityStatus.available, reason: 'Disponible');
    final safety = safetyService.evaluate(
      dish: dish,
      preference: preference,
      ingredientLookup: ingredientMap,
    );
    final chef = chefDirectory[dish.chefId];
    final estimate = deliveryService.estimate(
      prepMinutes: dish.prepTime,
      chefLat: chef?.lat ?? 33.5899,
      chefLng: chef?.lng ?? -7.6039,
      destLat: _defaultCustomerLat,
      destLng: _defaultCustomerLng,
    );
    return CustomerDishViewModel(
      dish: dish,
      availability: availability,
      safety: safety,
      estimate: estimate,
      chef: chef,
    );
  }).toList();

  vms.sort((a, b) => ratingScore(b.dish).compareTo(ratingScore(a.dish)));
  return vms;
});
