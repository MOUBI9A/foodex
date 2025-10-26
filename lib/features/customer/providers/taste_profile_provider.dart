// TasteProfileProvider for user preferences.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/models/taste_profile.dart';
import '../../../data/repositories/taste_profile_repository.dart';
import '../../../data/repositories/taste_profile_repository_impl.dart';

final tasteProfileRepositoryProvider = Provider<TasteProfileRepository>((ref) => TasteProfileRepositoryImpl());

final tasteProfileProvider = AsyncNotifierProvider<TasteProfileNotifier, TasteProfile?>(() => TasteProfileNotifier());

class TasteProfileNotifier extends AsyncNotifier<TasteProfile?> {
  late final TasteProfileRepository _repo;

  @override
  Future<TasteProfile?> build() async {
    _repo = ref.read(tasteProfileRepositoryProvider);
    return _repo.get();
  }

  Future<void> save(TasteProfile profile) async {
    await _repo.save(profile);
    state = AsyncValue.data(profile);
  }

  Future<void> clear() async {
    await _repo.clear();
    state = const AsyncValue.data(null);
  }
}
