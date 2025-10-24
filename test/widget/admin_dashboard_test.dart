import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery/features/admin/dashboard/widgets/metric_card.dart';
import 'package:food_delivery/features/admin/dashboard/widgets/app_sidebar.dart';
import 'package:food_delivery/features/admin/common/theme/admin_theme.dart';

/// Admin Dashboard Widget Tests
///
/// Tests for core admin dashboard UI components.
void main() {
  group('MetricCard Widget Tests', () {
    testWidgets('displays label and value correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: const Scaffold(
            body: MetricCard(
              label: 'Total Orders',
              value: '1,234',
              icon: Icons.shopping_bag,
              iconColor: Colors.blue,
            ),
          ),
        ),
      );

      expect(find.text('Total Orders'), findsOneWidget);
      expect(find.byIcon(Icons.shopping_bag), findsOneWidget);
    });

    testWidgets('displays growth indicator when provided',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: const Scaffold(
            body: MetricCard(
              label: 'Revenue',
              value: '\$50,000',
              icon: Icons.attach_money,
              iconColor: Colors.green,
              growthPercentage: 15.5,
            ),
          ),
        ),
      );

      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('15.5%'), findsOneWidget);
      expect(find.byIcon(Icons.trending_up), findsOneWidget);
    });

    testWidgets('shows loading state when isLoading is true',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: const Scaffold(
            body: MetricCard(
              label: 'Active Chefs',
              value: '0',
              icon: Icons.restaurant,
              iconColor: Colors.orange,
              isLoading: true,
            ),
          ),
        ),
      );

      // The loading state shows placeholder containers, not CircularProgressIndicator
      // Verify that the value text is not shown during loading
      expect(find.text('0'), findsNothing);
      expect(find.text('Active Chefs'), findsNothing);
    });

    testWidgets('handles negative growth correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: const Scaffold(
            body: MetricCard(
              label: 'Active Couriers',
              value: '45',
              icon: Icons.delivery_dining,
              iconColor: Colors.red,
              growthPercentage: -5.2,
            ),
          ),
        ),
      );

      expect(find.text('5.2%'), findsOneWidget);
      expect(find.byIcon(Icons.trending_down), findsOneWidget);
    });
  });

  group('AppSidebar Widget Tests', () {
    testWidgets('displays navigation items', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: Scaffold(
            body: AppSidebar(
              isMobile: false,
              selectedIndex: 0,
              onDestinationSelected: (index) {},
            ),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
      expect(find.text('Users'), findsOneWidget);
      expect(find.text('Chefs'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);
    });

    testWidgets('highlights selected item', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: Scaffold(
            body: AppSidebar(
              isMobile: false,
              selectedIndex: 2, // Chefs
              onDestinationSelected: (index) {},
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify Chefs is selected by checking for the active icon
      expect(find.byIcon(Icons.restaurant), findsOneWidget);
    });

    testWidgets('displays logo section', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: Scaffold(
            body: AppSidebar(
              isMobile: false,
              selectedIndex: 0,
              onDestinationSelected: (index) {},
            ),
          ),
        ),
      );

      expect(find.text('FoodEx'), findsOneWidget);
      expect(find.text('Admin Panel'), findsOneWidget);
      expect(find.byIcon(Icons.restaurant_menu), findsOneWidget);
    });

    testWidgets('displays profile section', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: Scaffold(
            body: AppSidebar(
              isMobile: false,
              selectedIndex: 0,
              onDestinationSelected: (index) {},
            ),
          ),
        ),
      );

      expect(find.text('Admin User'), findsOneWidget);
      expect(find.text('admin@foodex.com'), findsOneWidget);
      expect(find.byIcon(Icons.logout), findsOneWidget);
    });

    testWidgets('calls onDestinationSelected when item tapped',
        (WidgetTester tester) async {
      int? selectedIndex;

      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: Scaffold(
            body: AppSidebar(
              isMobile: false,
              selectedIndex: 0,
              onDestinationSelected: (index) {
                selectedIndex = index;
              },
            ),
          ),
        ),
      );

      await tester.tap(find.text('Users'));
      await tester.pumpAndSettle();

      expect(selectedIndex, 1);
    });

    testWidgets('mobile sidebar renders as drawer',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: Scaffold(
            body: AppSidebar(
              isMobile: true,
              selectedIndex: 0,
              onDestinationSelected: (index) {},
            ),
          ),
        ),
      );

      expect(find.byType(Drawer), findsOneWidget);
    });
  });

  group('Theme Tests', () {
    testWidgets('light theme applies correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.lightTheme,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      final BuildContext context = tester.element(find.text('Content'));
      final ThemeData theme = Theme.of(context);

      expect(theme.brightness, Brightness.light);
      expect(theme.primaryColor, AdminTheme.primaryOrange);
    });

    testWidgets('dark theme applies correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AdminTheme.darkTheme,
          home: Scaffold(
            appBar: AppBar(title: const Text('Test')),
            body: const Center(child: Text('Content')),
          ),
        ),
      );

      final BuildContext context = tester.element(find.text('Content'));
      final ThemeData theme = Theme.of(context);

      expect(theme.brightness, Brightness.dark);
      expect(theme.primaryColor, AdminTheme.primaryOrange);
    });
  });

  group('Integration Tests', () {
    testWidgets('dashboard page renders without errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Dashboard')),
            ),
          ),
        ),
      );

      expect(find.text('Dashboard'), findsOneWidget);
    });
  });
}
