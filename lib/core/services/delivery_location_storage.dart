import 'package:shared_preferences/shared_preferences.dart';
import 'package:food_delivery/data/models/delivery_location.dart';

class DeliveryLocationStorage {
  const DeliveryLocationStorage();

  static const _storageKey = 'delivery_location';

  Future<DeliveryLocation?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_storageKey);
    if (jsonString == null) return null;
    try {
      return DeliveryLocation.fromJson(jsonString);
    } catch (_) {
      return null;
    }
  }

  Future<void> save(DeliveryLocation? location) async {
    final prefs = await SharedPreferences.getInstance();
    if (location == null) {
      await prefs.remove(_storageKey);
    } else {
      await prefs.setString(_storageKey, location.toJson());
    }
  }
}
