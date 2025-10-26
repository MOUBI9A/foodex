import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/dish.dart';
import '../../data/repositories/dish_repository.dart';

final dishRepositoryProvider = Provider<DishRepository>((ref) {
  return DishRepositoryMock();
});

final dishListProvider = FutureProvider<List<Dish>>((ref) async {
  final repo = ref.watch(dishRepositoryProvider);
  return repo.getAll();
});
