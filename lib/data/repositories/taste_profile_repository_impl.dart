// TasteProfileRepository Hive implementation.
import 'package:hive/hive.dart';
import '../models/taste_profile.dart';
import '../../core/services/local_db_service.dart';
import 'taste_profile_repository.dart';

class TasteProfileRepositoryImpl implements TasteProfileRepository {
  static const String boxName = 'taste_profile_box';
  static const String key = 'default';

  Future<Box<TasteProfile>> _box() async {
    await LocalDbService.init();
    return LocalDbService.openBox<TasteProfile>(boxName);
  }

  @override
  Future<TasteProfile?> get() async {
    final box = await _box();
    return box.get(key);
  }

  @override
  Future<void> save(TasteProfile profile) async {
    final box = await _box();
    await box.put(key, profile);
  }

  @override
  Future<void> clear() async {
    final box = await _box();
    await box.delete(key);
  }
}
