// FreshnessProvider and FreshnessScheduler for periodic recalculation.
import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'ingredient_provider.dart';

final freshnessProvider = StateNotifierProvider<FreshnessScheduler, bool>((ref) => FreshnessScheduler(ref));

class FreshnessScheduler extends StateNotifier<bool> {
  final Ref ref;
  Timer? _timer;

  FreshnessScheduler(this.ref) : super(false);

  void start() {
    if (state) return;
    _timer = Timer.periodic(const Duration(hours: 24), (_) => recalcAll());
    state = true;
  }

  void stop() {
    _timer?.cancel();
    state = false;
  }

  Future<void> recalcAll() async {
    final notifier = ref.read(ingredientListProvider.notifier);
    final list = await notifier.repo.getAll();
    for (final ing in list) {
      ing.recalculateFreshness();
      await notifier.repo.update(ing);
    }
    await notifier.reload();
  }

  @override
  void dispose() {
    stop();
    super.dispose();
  }
}
