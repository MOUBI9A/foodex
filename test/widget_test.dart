// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:food_delivery/main.dart';
import 'package:food_delivery/core/locator.dart';
import 'package:food_delivery/presentation/pages/user_type_selector_view.dart';

void main() {
  // Setup services for testing
  setUpAll(() {
    setUpLocator();
  });

  testWidgets('FoodEx App Widget Test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(defaultHome: UserTypeSelectorView()));

    // Verify that the user type selector loads with correct text
    expect(find.text('Customer'), findsOneWidget);
    expect(find.text('Home Chef'), findsOneWidget);
    expect(find.text('Courier'), findsOneWidget);
    expect(
        find.text(
            'Community-driven food marketplace\nConnect with local home chefs'),
        findsOneWidget);
  });
}
