// Customer preferences repository using Hive for local storage.
import 'package:hive_flutter/hive_flutter.dart';
import '../models/customer_preferences.dart';

class CustomerPreferencesRepository {
  static const String _boxName = 'customer_preferences';

  Future<Box<CustomerPreferences>> get _box async {
    if (!Hive.isBoxOpen(_boxName)) {
      return await Hive.openBox<CustomerPreferences>(_boxName);
    }
    return Hive.box<CustomerPreferences>(_boxName);
  }

  Future<CustomerPreferences?> getPreferences(String customerId) async {
    final box = await _box;
    return box.get(customerId);
  }

  Future<void> savePreferences(CustomerPreferences preferences) async {
    final box = await _box;
    await box.put(preferences.customerId, preferences);
  }

  Future<void> deletePreferences(String customerId) async {
    final box = await _box;
    await box.delete(customerId);
  }

  Future<List<CustomerPreferences>> getAllPreferences() async {
    final box = await _box;
    return box.values.toList();
  }
}
