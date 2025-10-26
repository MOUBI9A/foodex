// TasteProfileRepository for storing user preferences locally.
import '../models/taste_profile.dart';

abstract class TasteProfileRepository {
  Future<TasteProfile?> get();
  Future<void> save(TasteProfile profile);
  Future<void> clear();
}
