// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:food_delivery/main.dart';
import 'package:food_delivery/core/utils/locator.dart';
import 'test_helpers/mock_path_provider.dart';

void main() {
  // Setup services for testing
  setUpAll(() async {
    setUpLocator();
    await setUpMockPathProvider();
  });

  testWidgets('FoodEx App Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ProviderScope(child: FoodExApp()));

    // Allow router to settle
    await tester.pumpAndSettle();

    // Verify that the user type selector loads with correct text
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Home Chef'), findsOneWidget);
    expect(find.text('Courier'), findsOneWidget);
    expect(
        find.text('Your local home-chef marketplace'), findsOneWidget);
  });
}
