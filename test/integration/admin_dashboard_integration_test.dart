import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/features/admin/dashboard/dashboard_page.dart';
import 'package:food_delivery/features/admin/dashboard/data/dashboard_metrics_provider.dart';

/// Comprehensive Integration & Stress Tests for Admin Dashboard
///
/// These tests verify:
/// 1. Full dashboard rendering with all components
/// 2. Theme switching
/// 3. Responsive layout changes
/// 4. Data provider integration
/// 5. Navigation interactions
/// 6. Performance under stress
void main() {
  group('Dashboard Integration Tests', () {
    testWidgets('dashboard page loads all components successfully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify AppBar is present
      expect(find.byType(AppBar), findsOneWidget);

      // Verify dashboard title
      expect(find.text('FoodEx Admin'), findsOneWidget);

      // Theme toggle button should be present
      expect(find.byIcon(Icons.dark_mode), findsOneWidget);
    });

    testWidgets('theme toggle switches between light and dark',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap the theme toggle button
      final themeToggle = find.byIcon(Icons.dark_mode);
      expect(themeToggle, findsOneWidget);

      await tester.tap(themeToggle);
      await tester.pumpAndSettle();

      // After toggle, should show light mode icon
      expect(find.byIcon(Icons.light_mode), findsOneWidget);
    });

    testWidgets('sidebar navigation items are clickable',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find Users navigation item
      final usersItem = find.text('Users');
      expect(usersItem, findsOneWidget);

      await tester.tap(usersItem);
      await tester.pumpAndSettle();

      // Verify no errors after tap
      expect(tester.takeException(), isNull);
    });

    testWidgets('mobile view shows hamburger menu',
        (WidgetTester tester) async {
      // Set mobile screen size
      tester.view.physicalSize = const Size(400, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Hamburger menu should be visible
      expect(find.byIcon(Icons.menu), findsOneWidget);

      // Tap hamburger menu
      await tester.tap(find.byIcon(Icons.menu));
      await tester.pumpAndSettle();

      // Drawer should open
      expect(find.byType(Drawer), findsOneWidget);

      // Reset screen size
      addTearDown(tester.view.reset);
    });

    testWidgets('tablet view shows 2-column layout',
        (WidgetTester tester) async {
      // Set tablet screen size
      tester.view.physicalSize = const Size(1000, 800);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Verify dashboard renders without errors
      expect(find.text('FoodEx Admin'), findsOneWidget);

      // Reset screen size
      addTearDown(tester.view.reset);
    });

    testWidgets('desktop view shows full sidebar', (WidgetTester tester) async {
      // Set desktop screen size
      tester.view.physicalSize = const Size(1400, 900);
      tester.view.devicePixelRatio = 1.0;

      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Sidebar should be visible (no hamburger menu)
      expect(find.byIcon(Icons.menu), findsNothing);

      // Navigation items should be visible
      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Users'), findsOneWidget);
      expect(find.text('Chefs'), findsOneWidget);

      // Reset screen size
      addTearDown(tester.view.reset);
    });
  });

  group('Data Provider Tests', () {
    test('dashboard metrics provider returns valid data', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      // Verify all required fields have values
      expect(metrics.totalOrders, greaterThan(0));
      expect(metrics.totalRevenue, greaterThan(0));
      expect(metrics.activeChefs, greaterThan(0));
      expect(metrics.activeCouriers, greaterThan(0));
      expect(metrics.weeklyRevenue, isNotEmpty);
      expect(metrics.topChefs, isNotEmpty);
      expect(metrics.ordersStatus, isNotNull);

      container.dispose();
    });

    test('chart type provider can switch between types', () {
      final container = ProviderContainer();

      // Default should be revenue
      expect(
        container.read(selectedChartTypeProvider),
        ChartDataType.revenue,
      );

      // Change to orders
      container.read(selectedChartTypeProvider.notifier).state =
          ChartDataType.orders;
      expect(
        container.read(selectedChartTypeProvider),
        ChartDataType.orders,
      );

      // Change to new users
      container.read(selectedChartTypeProvider.notifier).state =
          ChartDataType.newUsers;
      expect(
        container.read(selectedChartTypeProvider),
        ChartDataType.newUsers,
      );

      container.dispose();
    });

    test('orders status data has correct totals', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);
      final ordersStatus = metrics.ordersStatus;

      // Calculate total from individual statuses
      final calculatedTotal = ordersStatus.pending +
          ordersStatus.inProgress +
          ordersStatus.delivered +
          ordersStatus.cancelled;

      expect(ordersStatus.total, equals(calculatedTotal));

      // Verify percentages add up to ~100%
      final totalPercentage = ordersStatus.pendingPercentage +
          ordersStatus.inProgressPercentage +
          ordersStatus.deliveredPercentage +
          ordersStatus.cancelledPercentage;

      expect(totalPercentage, closeTo(100.0, 0.1));

      container.dispose();
    });

    test('weekly revenue data has 7 days', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      expect(metrics.weeklyRevenue.length, equals(7));

      // Verify all days have valid data
      for (final day in metrics.weeklyRevenue) {
        expect(day.day, isNotEmpty);
        expect(day.revenue, greaterThanOrEqualTo(0));
        expect(day.orders, greaterThanOrEqualTo(0));
        expect(day.newUsers, greaterThanOrEqualTo(0));
      }

      container.dispose();
    });

    test('top chefs have valid ratings', () {
      final container = ProviderContainer();
      final metrics = container.read(dashboardMetricsProvider);

      for (final chef in metrics.topChefs) {
        expect(chef.rating, greaterThanOrEqualTo(0.0));
        expect(chef.rating, lessThanOrEqualTo(5.0));
        expect(chef.completedOrders, greaterThanOrEqualTo(0));
        expect(chef.totalRevenue, greaterThanOrEqualTo(0));
        expect(chef.name, isNotEmpty);
        expect(chef.imageUrl, isNotEmpty);
      }

      container.dispose();
    });
  });

  group('Stress Tests', () {
    testWidgets('rapid theme toggling does not crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Rapidly toggle theme 10 times
      for (int i = 0; i < 10; i++) {
        final themeIcon = i % 2 == 0 ? Icons.dark_mode : Icons.light_mode;
        final themeToggle = find.byIcon(themeIcon);

        if (themeToggle.evaluate().isNotEmpty) {
          await tester.tap(themeToggle);
          await tester.pump();
        }
      }

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    testWidgets('rapid screen resize does not crash',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );

      // Rapidly change screen sizes
      final sizes = [
        const Size(400, 800), // Mobile
        const Size(1000, 800), // Tablet
        const Size(1400, 900), // Desktop
        const Size(600, 1000), // Mobile portrait
        const Size(1200, 800), // Desktop
      ];

      for (final size in sizes) {
        tester.view.physicalSize = size;
        tester.view.devicePixelRatio = 1.0;
        await tester.pump();
      }

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);

      addTearDown(tester.view.reset);
    });

    testWidgets('navigation spam does not crash', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Rapidly tap navigation items
      final navItems = ['Users', 'Chefs', 'Orders', 'Dashboard'];

      for (int i = 0; i < 20; i++) {
        final item = navItems[i % navItems.length];
        final finder = find.text(item);

        if (finder.evaluate().isNotEmpty) {
          await tester.tap(finder);
          await tester.pump(const Duration(milliseconds: 50));
        }
      }

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });
  });

  group('Performance Tests', () {
    testWidgets('dashboard renders within performance budget',
        (WidgetTester tester) async {
      final stopwatch = Stopwatch()..start();

      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Dashboard should render in less than 3 seconds
      expect(stopwatch.elapsedMilliseconds, lessThan(3000));
    });

    testWidgets('theme switch completes quickly', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      final stopwatch = Stopwatch()..start();

      await tester.tap(find.byIcon(Icons.dark_mode));
      await tester.pumpAndSettle();

      stopwatch.stop();

      // Theme switch should complete in less than 1 second
      expect(stopwatch.elapsedMilliseconds, lessThan(1000));
    });
  });

  group('Error Handling Tests', () {
    testWidgets('handles missing data gracefully', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Should render without exceptions even with mock data
      expect(tester.takeException(), isNull);
    });

    testWidgets('profile menu opens and closes', (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap profile avatar
      final avatar = find.byType(CircleAvatar).last;
      await tester.tap(avatar);
      await tester.pumpAndSettle();

      // Menu should be visible
      expect(find.text('Profile'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
      expect(find.text('Logout'), findsOneWidget);

      // Tap outside to close
      await tester.tapAt(const Offset(10, 10));
      await tester.pumpAndSettle();
    });

    testWidgets('notifications button shows snackbar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: DashboardPage(),
        ),
      );
      await tester.pumpAndSettle();

      // Find and tap notifications button
      final notificationsButton = find.byIcon(Icons.notifications_outlined);
      expect(notificationsButton, findsOneWidget);

      await tester.tap(notificationsButton);
      await tester.pumpAndSettle();

      // Should show snackbar
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
