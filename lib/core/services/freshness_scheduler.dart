import 'dart:async';
import 'ingredient_service.dart';

/// Scheduler for periodic freshness recalculation
/// Runs daily or on-demand to update ingredient freshness scores
class FreshnessScheduler {
  final IngredientService _ingredientService;
  Timer? _timer;
  bool _isRunning = false;
  DateTime? _lastRun;

  /// Interval for freshness recalculation (default: 24 hours)
  /// Can be overridden via environment variable for testing
  Duration get interval {
    // For testing, allow shorter intervals via environment variable
    final envHours = int.tryParse(
      const String.fromEnvironment('FRESHNESS_INTERVAL_HOURS',
          defaultValue: '24'),
    );
    return Duration(hours: envHours ?? 24);
  }

  FreshnessScheduler(this._ingredientService);

  /// Start the scheduler
  void start() {
    if (_isRunning) {
      print('FreshnessScheduler: Already running');
      return;
    }

    _isRunning = true;
    print(
        'FreshnessScheduler: Started with interval ${interval.inHours} hours');

    // Run immediately on start
    _runRecalculation();

    // Schedule periodic runs
    _timer = Timer.periodic(interval, (_) {
      _runRecalculation();
    });
  }

  /// Stop the scheduler
  void stop() {
    if (!_isRunning) return;

    _timer?.cancel();
    _timer = null;
    _isRunning = false;
    print('FreshnessScheduler: Stopped');
  }

  /// Run freshness recalculation manually
  Future<void> recalculateNow() async {
    print('FreshnessScheduler: Manual recalculation triggered');
    await _runRecalculation();
  }

  Future<void> _runRecalculation() async {
    try {
      print('FreshnessScheduler: Running freshness recalculation...');
      final startTime = DateTime.now();

      await _ingredientService.recalculateAllFreshness();

      _lastRun = DateTime.now();
      final duration = _lastRun!.difference(startTime);
      print('FreshnessScheduler: Completed in ${duration.inMilliseconds}ms');
    } catch (e, stackTrace) {
      print('FreshnessScheduler: Error during recalculation: $e');
      print('Stack trace: $stackTrace');
    }
  }

  /// Get the last run timestamp
  DateTime? get lastRun => _lastRun;

  /// Check if scheduler is running
  bool get isRunning => _isRunning;

  /// Dispose the scheduler
  void dispose() {
    stop();
  }
}
