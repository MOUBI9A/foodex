import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/ingredient_service.dart';
import '../services/freshness_scheduler.dart';
import 'ingredient_provider.dart';

/// Freshness scheduler provider
final freshnessSchedulerProvider = Provider((ref) {
  final service = ref.watch(ingredientServiceProvider);
  final scheduler = FreshnessScheduler(service);

  // Auto-start scheduler
  scheduler.start();

  // Dispose on provider disposal
  ref.onDispose(() {
    scheduler.dispose();
  });

  return scheduler;
});

/// Manual freshness recalculation trigger
class FreshnessNotifier extends StateNotifier<AsyncValue<DateTime?>> {
  final FreshnessScheduler _scheduler;

  FreshnessNotifier(this._scheduler) : super(const AsyncValue.data(null));

  /// Trigger manual recalculation
  Future<void> recalculateNow() async {
    state = const AsyncValue.loading();
    try {
      await _scheduler.recalculateNow();
      state = AsyncValue.data(DateTime.now());
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  /// Get last run timestamp
  DateTime? get lastRun => _scheduler.lastRun;

  /// Check if scheduler is running
  bool get isRunning => _scheduler.isRunning;
}

/// Freshness notifier provider
final freshnessNotifierProvider =
    StateNotifierProvider<FreshnessNotifier, AsyncValue<DateTime?>>((ref) {
  final scheduler = ref.watch(freshnessSchedulerProvider);
  return FreshnessNotifier(scheduler);
});

/// Last freshness recalculation time provider
final lastFreshnessRecalculationProvider = Provider<DateTime?>((ref) {
  final scheduler = ref.watch(freshnessSchedulerProvider);
  return scheduler.lastRun;
});

/// Is scheduler running provider
final isSchedulerRunningProvider = Provider<bool>((ref) {
  final scheduler = ref.watch(freshnessSchedulerProvider);
  return scheduler.isRunning;
});
