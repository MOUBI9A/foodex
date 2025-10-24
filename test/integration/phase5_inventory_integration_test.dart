import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/features/chef/inventory/inventory_screen.dart';
import 'package:food_delivery/features/admin/dashboard/admin_dashboard_screen.dart';
import 'package:food_delivery/features/test_navigation_screen.dart';

/// Phase 5 Integration Tests
/// Tests for Chef Inventory Management and Admin Analytics Dashboard
void main() {
  group('Phase 5: Smart Inventory System - Integration Tests', () {
    testWidgets('Test Navigation Screen renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TestNavigationScreen(),
          ),
        ),
      );

      // Verify screen title
      expect(find.text('FoodEx - Feature Navigation'), findsOneWidget);
      expect(find.text('🎯 Phase 5: Smart Inventory System'), findsOneWidget);

      // Verify chef inventory button
      expect(find.text('👨‍🍳 Chef Inventory Management'), findsOneWidget);
      expect(find.text('Open Inventory'), findsOneWidget);

      // Verify admin dashboard button
      expect(find.text('📊 Admin Analytics Dashboard'), findsOneWidget);
      expect(find.text('Open Dashboard'), findsOneWidget);
    });

    testWidgets('Navigation to Chef Inventory Screen works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TestNavigationScreen(),
          ),
        ),
      );

      // Tap on the Open Inventory button
      await tester.tap(find.text('Open Inventory'));
      await tester.pumpAndSettle();

      // Verify navigation to Chef Inventory Screen
      expect(find.text('Chef Inventory'), findsOneWidget);
      expect(find.byType(ChefInventoryScreen), findsOneWidget);
    });

    testWidgets('Navigation to Admin Dashboard Screen works',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TestNavigationScreen(),
          ),
        ),
      );

      // Tap on the Open Dashboard button
      await tester.tap(find.text('Open Dashboard'));
      await tester.pumpAndSettle();

      // Verify navigation to Admin Dashboard Screen
      expect(find.text('Admin Dashboard'), findsOneWidget);
      expect(find.byType(AdminDashboardScreen), findsOneWidget);
    });

    testWidgets('Chef Inventory Screen renders without errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: ChefInventoryScreen(chefId: 'chef_001'),
          ),
        ),
      );

      // Allow async providers to load
      await tester.pump();

      // Verify screen renders without errors
      expect(find.byType(ChefInventoryScreen), findsOneWidget);
      expect(find.text('Chef Inventory'), findsOneWidget);
    });

    testWidgets('Admin Dashboard Screen renders without errors',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: AdminDashboardScreen(chefId: 'chef_001'),
          ),
        ),
      );

      // Allow async providers to load
      await tester.pump();

      // Verify screen renders without errors
      expect(find.byType(AdminDashboardScreen), findsOneWidget);
      expect(find.text('Admin Dashboard'), findsOneWidget);
    });

    test('ChefInventoryScreen constructor accepts chefId', () {
      const screen = ChefInventoryScreen(chefId: 'test_chef_123');
      expect(screen.chefId, equals('test_chef_123'));
    });

    test('AdminDashboardScreen constructor accepts chefId', () {
      const screen = AdminDashboardScreen(chefId: 'test_chef_456');
      expect(screen.chefId, equals('test_chef_456'));
    });
  });

  group('E2E Flow Tests', () {
    testWidgets('Complete flow: Navigation -> Inventory -> Back',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TestNavigationScreen(),
          ),
        ),
      );

      // 1. Start at Test Navigation Screen
      expect(find.text('FoodEx - Feature Navigation'), findsOneWidget);

      // 2. Navigate to Inventory
      await tester.tap(find.text('Open Inventory'));
      await tester.pumpAndSettle();
      expect(find.text('Chef Inventory'), findsOneWidget);

      // 3. Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('FoodEx - Feature Navigation'), findsOneWidget);
    });

    testWidgets('Complete flow: Navigation -> Dashboard -> Back',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: TestNavigationScreen(),
          ),
        ),
      );

      // 1. Start at Test Navigation Screen
      expect(find.text('FoodEx - Feature Navigation'), findsOneWidget);

      // 2. Navigate to Dashboard
      await tester.tap(find.text('Open Dashboard'));
      await tester.pumpAndSettle();
      expect(find.text('Admin Dashboard'), findsOneWidget);

      // 3. Go back
      await tester.tap(find.byType(BackButton));
      await tester.pumpAndSettle();
      expect(find.text('FoodEx - Feature Navigation'), findsOneWidget);
    });
  });
}
