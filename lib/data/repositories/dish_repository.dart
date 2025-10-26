// DishRepository mock using seed JSON, with optional Hive storage for caching.
import 'package:hive/hive.dart';
import '../models/dish.dart';
import '../../core/services/local_db_service.dart';
import 'mock_data_provider.dart';

abstract class DishRepository {
  Future<List<Dish>> getAll();
}

class DishRepositoryMock implements DishRepository {
  static const String boxName = 'dishes_box';

  Future<Box<Dish>> _box() async {
    await LocalDbService.init();
    return LocalDbService.openBox<Dish>(boxName);
  }

  @override
  Future<List<Dish>> getAll() async {
    final box = await _box();
    if (box.isEmpty) {
      final data = await MockDataProvider.load('dishes_seed.json');
      final list = (data['dishes'] as List)
          .map((e) => Dish.fromJson(e as Map<String, dynamic>))
          .toList();
      for (final d in list) {
        await box.put(d.id, d);
      }
      return list;
    }
    return box.values.toList(growable: false);
  }
}
