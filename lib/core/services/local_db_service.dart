// LocalDbService
// Hive initialization and typed box helpers. Adapters to be registered in Phase C.
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/ingredient.dart';
import '../../data/models/ingredient_history_item.dart';
import '../../data/models/dish.dart';
import '../../data/models/taste_profile.dart';
import '../../data/models/dashboard_overview.dart';
import '../../data/models/customer_preferences.dart';

class LocalDbService {
  static bool _initialized = false;

  static Future<void> init() async {
    if (_initialized) return;
    await Hive.initFlutter();
    // Register adapters only once
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(IngredientAdapter());
    }
    if (!Hive.isAdapterRegistered(2)) {
      Hive.registerAdapter(IngredientHistoryItemAdapter());
    }
    if (!Hive.isAdapterRegistered(3)) {
      Hive.registerAdapter(DishAdapter());
    }
    if (!Hive.isAdapterRegistered(4)) {
      Hive.registerAdapter(IngredientUsageAdapter());
    }
    if (!Hive.isAdapterRegistered(5)) {
      Hive.registerAdapter(TasteProfileAdapter());
    }
    if (!Hive.isAdapterRegistered(7)) {
      Hive.registerAdapter(DashboardOverviewAdapter());
    }
    if (!Hive.isAdapterRegistered(8)) {
      Hive.registerAdapter(CustomerPreferencesAdapter());
    }
    _initialized = true;
  }

  static Future<Box<T>> openBox<T>(String name) async {
    await init();
    return Hive.openBox<T>(name);
  }

  static Future<void> close() async {
    if (!_initialized) return;
    await Hive.close();
    _initialized = false;
  }
}
