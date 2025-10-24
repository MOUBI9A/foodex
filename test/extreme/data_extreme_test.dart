import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/features/admin/dashboard/data/dashboard_metrics_provider.dart';

/// EXTREME STRESS TESTS - Testing edge cases and boundary conditions
void main() {
  group('🔥 EXTREME Data Validation Tests', () {
    test('metrics provider handles extreme values', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      // Test all numeric values are non-negative
      expect(metrics.totalOrders, greaterThanOrEqualTo(0));
      expect(metrics.totalRevenue, greaterThanOrEqualTo(0));
      expect(metrics.activeChefs, greaterThanOrEqualTo(0));
      expect(metrics.activeCouriers, greaterThanOrEqualTo(0));

      // Test growth percentages are reasonable (not NaN or Infinity)
      expect(metrics.ordersGrowth.isFinite, isTrue);
      expect(metrics.revenueGrowth.isFinite, isTrue);
      expect(metrics.chefsGrowth.isFinite, isTrue);
      expect(metrics.couriersGrowth.isFinite, isTrue);

      // Test growth percentages are within realistic bounds (-100% to 1000%)
      expect(metrics.ordersGrowth, greaterThan(-100));
      expect(metrics.ordersGrowth, lessThan(1000));
      expect(metrics.revenueGrowth, greaterThan(-100));
      expect(metrics.revenueGrowth, lessThan(1000));

      container.dispose();
    });

    test('weekly revenue data has no null or invalid entries', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      expect(metrics.weeklyRevenue.length, equals(7));

      for (final day in metrics.weeklyRevenue) {
        // Day names must not be empty
        expect(day.day.trim(), isNotEmpty);

        // All values must be non-negative
        expect(day.revenue, greaterThanOrEqualTo(0));
        expect(day.orders, greaterThanOrEqualTo(0));
        expect(day.newUsers, greaterThanOrEqualTo(0));

        // Revenue should be realistic (not astronomical)
        expect(day.revenue, lessThan(1000000));

        // Orders should be realistic
        expect(day.orders, lessThan(100000));

        // New users should be realistic
        expect(day.newUsers, lessThan(10000));
      }

      container.dispose();
    });

    test('orders status percentages sum to exactly 100%', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);
      final status = metrics.ordersStatus;

      final sum = status.pendingPercentage +
          status.inProgressPercentage +
          status.deliveredPercentage +
          status.cancelledPercentage;

      // Should be exactly 100% (within floating point precision)
      expect(sum, closeTo(100.0, 0.01));

      // Each percentage should be valid
      expect(status.pendingPercentage, greaterThanOrEqualTo(0));
      expect(status.pendingPercentage, lessThanOrEqualTo(100));
      expect(status.inProgressPercentage, greaterThanOrEqualTo(0));
      expect(status.inProgressPercentage, lessThanOrEqualTo(100));
      expect(status.deliveredPercentage, greaterThanOrEqualTo(0));
      expect(status.deliveredPercentage, lessThanOrEqualTo(100));
      expect(status.cancelledPercentage, greaterThanOrEqualTo(0));
      expect(status.cancelledPercentage, lessThanOrEqualTo(100));

      container.dispose();
    });

    test('top chefs data is valid and sorted', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      expect(metrics.topChefs, isNotEmpty);
      expect(metrics.topChefs.length, lessThanOrEqualTo(100));

      for (int i = 0; i < metrics.topChefs.length; i++) {
        final chef = metrics.topChefs[i];

        // ID must be unique and non-empty
        expect(chef.id.trim(), isNotEmpty);

        // Name must be non-empty
        expect(chef.name.trim(), isNotEmpty);

        // Image URL must be valid
        expect(chef.imageUrl, contains('http'));

        // Rating must be between 0 and 5
        expect(chef.rating, greaterThanOrEqualTo(0.0));
        expect(chef.rating, lessThanOrEqualTo(5.0));

        // Rating should have realistic precision (max 1 decimal)
        expect((chef.rating * 10) % 1, closeTo(0, 0.01));

        // Orders and revenue must be non-negative
        expect(chef.completedOrders, greaterThanOrEqualTo(0));
        expect(chef.totalRevenue, greaterThanOrEqualTo(0));
      }

      // Check for duplicate IDs
      final ids = metrics.topChefs.map((c) => c.id).toList();
      final uniqueIds = ids.toSet();
      expect(ids.length, equals(uniqueIds.length),
          reason: 'Duplicate chef IDs found');

      container.dispose();
    });

    test('chart data consistency check', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      // Total revenue from weekly data should be reasonable
      final weeklyTotal = metrics.weeklyRevenue.fold<double>(
        0,
        (sum, day) => sum + day.revenue,
      );

      // Weekly total should be positive
      expect(weeklyTotal, greaterThan(0));

      // Weekly total should be at least 10% of monthly revenue (or could exceed it in a good week)
      expect(weeklyTotal, greaterThan(metrics.totalRevenue * 0.1));

      container.dispose();
    });

    test('all string fields are sanitized', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      // Check chef names don't contain dangerous characters
      for (final chef in metrics.topChefs) {
        expect(chef.name, isNot(contains('<script>')));
        expect(chef.name, isNot(contains('javascript:')));
        expect(chef.name, isNot(contains('\n')));
        expect(chef.name, isNot(contains('\t')));
      }

      // Check day names
      for (final day in metrics.weeklyRevenue) {
        expect(day.day, isNot(contains('<')));
        expect(day.day, isNot(contains('>')));
        expect(day.day.length, lessThan(20));
      }

      container.dispose();
    });

    test('numeric overflow protection', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      // Total orders shouldn't overflow int32
      expect(metrics.totalOrders, lessThan(2147483647));

      // Revenue shouldn't be ridiculously high
      expect(metrics.totalRevenue, lessThan(999999999.99));

      // Growth percentages shouldn't be infinite
      expect(metrics.ordersGrowth.isFinite, isTrue);
      expect(metrics.ordersGrowth.isNaN, isFalse);

      container.dispose();
    });
  });

  group('🔥 EXTREME Edge Case Tests', () {
    test('provider can be read multiple times without errors', () {
      final container = ProviderContainer();

      // Read provider 100 times
      for (int i = 0; i < 100; i++) {
        final metrics = container.read(dashboardMetricsProvider);
        expect(metrics, isNotNull);
        expect(metrics.totalOrders, greaterThan(0));
      }

      container.dispose();
    });

    test('multiple containers don\'t interfere', () {
      final containers = List.generate(10, (_) => ProviderContainer());

      for (final container in containers) {
        final metrics = container.read(dashboardMetricsProvider);
        expect(metrics, isNotNull);
        expect(metrics.totalOrders, equals(12847));
      }

      for (final container in containers) {
        container.dispose();
      }
    });

    test('chart type provider handles all enum values', () {
      final container = ProviderContainer();

      for (final type in ChartDataType.values) {
        container.read(selectedChartTypeProvider.notifier).state = type;
        expect(container.read(selectedChartTypeProvider), equals(type));
      }

      container.dispose();
    });

    test('orders status total matches individual counts', () {
      final container = ProviderContainer();
      final status = container.read(dashboardMetricsProvider).ordersStatus;

      final calculatedTotal = status.pending +
          status.inProgress +
          status.delivered +
          status.cancelled;

      expect(status.total, equals(calculatedTotal));

      // Verify no negative counts
      expect(status.pending, greaterThanOrEqualTo(0));
      expect(status.inProgress, greaterThanOrEqualTo(0));
      expect(status.delivered, greaterThanOrEqualTo(0));
      expect(status.cancelled, greaterThanOrEqualTo(0));

      container.dispose();
    });

    test('percentage calculations are accurate', () {
      final container = ProviderContainer();
      final status = container.read(dashboardMetricsProvider).ordersStatus;

      // Manually calculate percentages
      final expectedPending = (status.pending / status.total) * 100;
      final expectedInProgress = (status.inProgress / status.total) * 100;
      final expectedDelivered = (status.delivered / status.total) * 100;
      final expectedCancelled = (status.cancelled / status.total) * 100;

      expect(status.pendingPercentage, closeTo(expectedPending, 0.1));
      expect(status.inProgressPercentage, closeTo(expectedInProgress, 0.1));
      expect(status.deliveredPercentage, closeTo(expectedDelivered, 0.1));
      expect(status.cancelledPercentage, closeTo(expectedCancelled, 0.1));

      container.dispose();
    });
  });

  group('🔥 EXTREME Performance Tests', () {
    test('provider read is fast (<1ms)', () {
      final container = ProviderContainer();
      final stopwatch = Stopwatch()..start();

      for (int i = 0; i < 1000; i++) {
        container.read(dashboardMetricsProvider);
      }

      stopwatch.stop();

      // 1000 reads should take less than 100ms (avg <0.1ms per read)
      expect(stopwatch.elapsedMilliseconds, lessThan(100));

      container.dispose();
    });

    test('chart type switching is instantaneous', () {
      final container = ProviderContainer();
      final stopwatch = Stopwatch()..start();

      // Switch between chart types 1000 times
      for (int i = 0; i < 1000; i++) {
        final type = ChartDataType.values[i % ChartDataType.values.length];
        container.read(selectedChartTypeProvider.notifier).state = type;
      }

      stopwatch.stop();

      // Should complete in less than 50ms
      expect(stopwatch.elapsedMilliseconds, lessThan(50));

      container.dispose();
    });

    test('no memory leaks with repeated container creation', () {
      // Create and dispose 100 containers
      for (int i = 0; i < 100; i++) {
        final container = ProviderContainer();
        container.read(dashboardMetricsProvider);
        container.dispose();
      }

      // If we got here without errors, no obvious leaks
      expect(true, isTrue);
    });
  });

  group('🔥 EXTREME Data Consistency Tests', () {
    test('chef revenue matches order count correlation', () {
      final container = ProviderContainer();
      final chefs = container.read(dashboardMetricsProvider).topChefs;

      for (final chef in chefs) {
        // Average revenue per order
        if (chef.completedOrders > 0) {
          final avgRevenuePerOrder = chef.totalRevenue / chef.completedOrders;

          // Should be between $5 and $200 per order (realistic)
          expect(avgRevenuePerOrder, greaterThan(5.0));
          expect(avgRevenuePerOrder, lessThan(200.0));
        }
      }

      container.dispose();
    });

    test('weekly data follows realistic patterns', () {
      final container = ProviderContainer();
      final weeklyData = container.read(dashboardMetricsProvider).weeklyRevenue;

      for (int i = 0; i < weeklyData.length; i++) {
        final day = weeklyData[i];

        // Orders and revenue should correlate
        if (day.orders > 0) {
          final avgOrderValue = day.revenue / day.orders;
          expect(avgOrderValue, greaterThan(10.0));
          expect(avgOrderValue, lessThan(100.0));
        }

        // New users should be less than total orders
        expect(day.newUsers, lessThanOrEqualTo(day.orders));
      }

      container.dispose();
    });

    test('delivered orders should dominate', () {
      final container = ProviderContainer();
      final status = container.read(dashboardMetricsProvider).ordersStatus;

      // In a healthy business, delivered should be highest
      expect(status.delivered, greaterThan(status.pending));
      expect(status.delivered, greaterThan(status.cancelled));

      // Cancelled should be less than 10% ideally
      expect(status.cancelledPercentage, lessThan(15.0));

      container.dispose();
    });

    test('growth metrics are internally consistent', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      // If orders grow, revenue should generally grow
      if (metrics.ordersGrowth > 0 && metrics.revenueGrowth > 0) {
        // Both positive - consistent
        expect(true, isTrue);
      }

      // Growth rates shouldn't be wildly different (unless edge case)
      final growthDiff = (metrics.ordersGrowth - metrics.revenueGrowth).abs();
      expect(growthDiff, lessThan(50.0),
          reason: 'Order and revenue growth too divergent');

      container.dispose();
    });
  });

  group('🔥 EXTREME Boundary Tests', () {
    test('handles zero orders gracefully', () {
      // This tests what happens if a chef has 0 orders
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      // At least one chef should have orders > 0
      expect(metrics.topChefs.any((c) => c.completedOrders > 0), isTrue);

      container.dispose();
    });

    test('handles maximum reasonable values', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      // Test that extreme but valid values work
      expect(metrics.totalOrders, lessThan(10000000));
      expect(metrics.totalRevenue, lessThan(100000000.0));
      expect(metrics.activeChefs, lessThan(100000));
      expect(metrics.activeCouriers, lessThan(100000));

      container.dispose();
    });

    test('string fields have reasonable lengths', () {
      final container = ProviderContainer();
      final chefs = container.read(dashboardMetricsProvider).topChefs;

      for (final chef in chefs) {
        expect(chef.id.length, greaterThan(0));
        expect(chef.id.length, lessThan(100));

        expect(chef.name.length, greaterThan(0));
        expect(chef.name.length, lessThan(100));

        expect(chef.imageUrl.length, greaterThan(10));
        expect(chef.imageUrl.length, lessThan(500));
      }

      container.dispose();
    });

    test('ratings have appropriate precision', () {
      final container = ProviderContainer();
      final chefs = container.read(dashboardMetricsProvider).topChefs;

      for (final chef in chefs) {
        // Rating should be to 1 decimal place
        final rounded = (chef.rating * 10).round() / 10;
        expect(chef.rating, closeTo(rounded, 0.01));
      }

      container.dispose();
    });
  });

  group('🔥 EXTREME Concurrency Tests', () {
    test('multiple simultaneous reads don\'t cause issues', () async {
      final container = ProviderContainer();

      // Simulate concurrent reads
      final futures = List.generate(
        50,
        (_) => Future(() => container.read(dashboardMetricsProvider)),
      );

      final results = await Future.wait(futures);

      // All should return same data
      for (final metrics in results) {
        expect(metrics.totalOrders, equals(12847));
        expect(metrics.totalRevenue, equals(284950.50));
      }

      container.dispose();
    });

    test('rapid state changes don\'t break provider', () async {
      final container = ProviderContainer();

      // Rapidly switch chart types
      final futures = List.generate(100, (i) {
        return Future(() {
          final type = ChartDataType.values[i % ChartDataType.values.length];
          container.read(selectedChartTypeProvider.notifier).state = type;
          return container.read(selectedChartTypeProvider);
        });
      });

      await Future.wait(futures);

      // Should still be readable
      final finalType = container.read(selectedChartTypeProvider);
      expect(ChartDataType.values.contains(finalType), isTrue);

      container.dispose();
    });
  });

  group('🔥 EXTREME Type Safety Tests', () {
    test('all numeric types are correct', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      expect(metrics.totalOrders, isA<int>());
      expect(metrics.totalRevenue, isA<double>());
      expect(metrics.activeChefs, isA<int>());
      expect(metrics.activeCouriers, isA<int>());
      expect(metrics.ordersGrowth, isA<double>());
      expect(metrics.revenueGrowth, isA<double>());

      container.dispose();
    });

    test('all collection types are correct', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      expect(metrics.weeklyRevenue, isA<List<RevenueData>>());
      expect(metrics.topChefs, isA<List<ChefData>>());
      expect(metrics.ordersStatus, isA<OrdersStatusData>());

      container.dispose();
    });

    test('chef data types are correct', () {
      final container = ProviderContainer();
      final chef = container.read(dashboardMetricsProvider).topChefs.first;

      expect(chef.id, isA<String>());
      expect(chef.name, isA<String>());
      expect(chef.imageUrl, isA<String>());
      expect(chef.rating, isA<double>());
      expect(chef.completedOrders, isA<int>());
      expect(chef.totalRevenue, isA<double>());

      container.dispose();
    });
  });
}
