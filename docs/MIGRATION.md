# FOODEx Architecture Migration Guide

**Last Updated:** October 26, 2025  
**Migration Version:** Phase 3 — GoRouter + Feature-First Structure

---

## Overview

FOODEx has migrated from a mixed structure to a **feature-first, offline-first architecture** using:
- **GoRouter** for declarative routing
- **Riverpod** for state management  
- **Hive** for offline-first local persistence  
- **Feature modules** for scalable organization

---

## New Project Structure

```
lib/
├── core/                           # Shared app-wide utilities
│   ├── constants/
│   │   ├── routes.dart            # ✨ GoRouter configuration & route names
│   │   └── globs.dart             # App-wide constants
│   ├── network/                   # API service layer
│   ├── services/
│   │   └── local_db_service.dart  # Hive initialization & adapters
│   ├── theme/                     # Design tokens (AppColors, AppSpacing, etc.)
│   └── utils/                     # Extensions, helpers, locators
│
├── data/                          # Data layer
│   ├── models/                    # Hive models with adapters
│   ├── repositories/              # Repository interfaces & implementations
│   └── mock/                      # Seed JSON files
│
├── features/                      # ✨ Feature modules (scalable)
│   ├── customer/
│   │   ├── screens/              # Customer-specific screens
│   │   ├── widgets/              # Customer-specific widgets
│   │   └── providers/            # Customer Riverpod providers
│   ├── chef/
│   │   ├── screens/              # Chef screens (Inventory, etc.)
│   │   ├── widgets/              # Chef-specific widgets
│   │   └── providers/            # Chef Riverpod providers
│   └── admin/
│       ├── screens/              # Admin dashboard (web-first)
│       └── providers/
│
├── presentation/                  # Shared presentation layer
│   ├── pages/                    # App shells & legacy screens
│   │   ├── main_tabview/         # Customer bottom nav shell
│   │   ├── chef/                 # Chef bottom nav shell
│   │   ├── driver/               # Driver bottom nav shell
│   │   ├── more/                 # More tab screens
│   │   ├── home/                 # Home screen
│   │   └── ...
│   └── widgets/                  # Shared reusable widgets
│
└── main.dart                      # ✨ App entry with GoRouter + ProviderScope
```

---

## What Changed

### ✅ Added

1. **`lib/core/constants/routes.dart`**
   - Central GoRouter configuration
   - Type-safe route names via `AppRouteNames`
   - Declarative route definitions

2. **Feature Modules** (`lib/features/*`)
   - Customer: recommendations, taste profile
   - Chef: inventory with freshness engine
   - Admin: dashboard with metrics

3. **Riverpod Providers**
   - State management for ingredients, dishes, recommendations, admin
   - Async operations with proper loading/error states

4. **Offline-First with Hive**
   - `LocalDbService.init()` in main.dart
   - Registered adapters for all models
   - Seed data from `lib/mock/*.json`

### ⚠️ Deprecated

**`lib/view/*` folder** is now **deprecated** and should not be used:
- All screens have equivalents in `lib/presentation/pages/*` or `lib/features/*`
- No active imports reference `view/*`
- Will be removed in a future release

**Migration:** If you have custom code in `view/*`, move it to the appropriate location:
- Feature-specific screens → `lib/features/{feature}/screens/`
- Shared screens → `lib/presentation/pages/`
- Widgets → `lib/features/{feature}/widgets/` or `lib/presentation/widgets/`

### 🔄 Changed

1. **Navigation**
   - **Before:** `Navigator.push(context, MaterialPageRoute(...))`
   - **After:** `context.push(AppRouteNames.routeName)` or `context.go(AppRouteNames.routeName)`

2. **Main App Entry**
   - **Before:** `MyApp` with `MaterialApp` and `onGenerateRoute`
   - **After:** `FoodExApp` with `MaterialApp.router` and `goRouter`

3. **State Management**
   - **Before:** StatefulWidget with local state
   - **After:** ConsumerWidget/ConsumerStatefulWidget with Riverpod providers

---

## How to Add New Features

### 1. Create Feature Module

```
lib/features/your_feature/
├── screens/
│   └── your_screen.dart
├── widgets/
│   └── your_widget.dart
└── providers/
    └── your_provider.dart
```

### 2. Define Route

Edit `lib/core/constants/routes.dart`:

```dart
class AppRouteNames {
  // ... existing routes
  static const yourFeature = '/your-feature';
}

final GoRouter goRouter = GoRouter(
  routes: [
    // ... existing routes
    GoRoute(
      path: AppRouteNames.yourFeature,
      name: 'yourFeature',
      builder: (context, state) => const YourScreen(),
    ),
  ],
);
```

### 3. Navigate

```dart
// Push new screen (can go back)
context.push(AppRouteNames.yourFeature);

// Replace current screen (can't go back)
context.go(AppRouteNames.yourFeature);

// Pop current screen
context.pop();

// Push with parameters
context.pushNamed(
  'yourFeature',
  pathParameters: {'id': '123'},
  queryParameters: {'filter': 'active'},
);
```

### 4. Create Riverpod Provider

```dart
// lib/features/your_feature/providers/your_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

final yourProvider = FutureProvider<YourData>((ref) async {
  // Fetch or compute data
  return await yourRepository.getData();
});

// Or for mutable state:
final yourNotifierProvider = 
  AsyncNotifierProvider<YourNotifier, YourState>(YourNotifier.new);

class YourNotifier extends AsyncNotifier<YourState> {
  @override
  Future<YourState> build() async {
    // Initialize
  }

  Future<void> yourMethod() async {
    // Update state
    state = AsyncValue.data(newState);
  }
}
```

### 5. Consume in Widget

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

class YourScreen extends ConsumerWidget {
  const YourScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(yourProvider);

    return dataAsync.when(
      data: (data) => YourContent(data: data),
      loading: () => const CircularProgressIndicator(),
      error: (err, stack) => Text('Error: $err'),
    );
  }
}
```

---

## Navigation Patterns

### User Type Selection Flow

```
UserTypeSelectorView
  ↓ (context.go)
  ├─→ Customer: MainTabView (AppRouteNames.customerHome)
  ├─→ Chef: ChefMainTabView (AppRouteNames.chef)
  ├─→ Driver: DriverMainTabView (AppRouteNames.driver)
  └─→ Admin: AdminDashboardScreen (AppRouteNames.adminDashboard)
```

### Customer Flow

```
MainTabView (bottom nav)
  ├─ Home Tab
  ├─ Offers Tab
  ├─ Profile Tab
  └─ More Tab
      ├─→ Taste Profile (context.push → AppRouteNames.customerTasteProfile)
      └─→ Recommendations (context.push → AppRouteNames.customerRecommendations)
```

### Chef Flow

```
ChefMainTabView (bottom nav)
  ├─ Home Tab
  │   └─→ Inventory (context.push → AppRouteNames.chefInventory)
  ├─ Menu Tab
  ├─ Orders Tab
  ├─ Earnings Tab
  └─ Profile Tab
```

---

## Testing with GoRouter

### Widget Tests

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:food_delivery/main.dart';

void main() {
  testWidgets('App loads with GoRouter', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: FoodExApp()));
    await tester.pumpAndSettle(); // Wait for router

    expect(find.text('Customer'), findsOneWidget);
  });
}
```

### Navigation Tests

```dart
testWidgets('Navigate to taste profile', (tester) async {
  await tester.pumpWidget(const ProviderScope(child: FoodExApp()));
  await tester.pumpAndSettle();

  // Tap Customer
  await tester.tap(find.text('Customer'));
  await tester.pumpAndSettle();

  // Navigate to More tab
  await tester.tap(find.byIcon(Icons.more_horiz));
  await tester.pumpAndSettle();

  // Tap Taste Profile
  await tester.tap(find.text('Taste Profile'));
  await tester.pumpAndSettle();

  expect(find.text('Your Taste Preferences'), findsOneWidget);
});
```

---

## Best Practices

### 1. Feature Isolation
- Keep feature code in `lib/features/{feature}/`
- Shared code goes in `lib/core/` or `lib/presentation/`
- Data models and repos in `lib/data/`

### 2. State Management
- Use Riverpod providers for business logic
- Keep UI widgets simple and declarative
- Avoid StatefulWidget unless managing local UI state only

### 3. Routing
- Always use named routes via `AppRouteNames`
- Use `context.go()` for shell/tab navigation
- Use `context.push()` for modal/detail screens

### 4. Testing
- Mock providers using `ProviderScope(overrides: [...])`
- Use fake notifiers for widget interaction tests
- Mock path_provider for Hive-based tests

### 5. Offline-First
- Seed data on first run via `LocalDbService`
- Use Hive boxes for all persistent data
- Repositories handle sync logic (fetch → cache → return)

---

## Migration Checklist

- [x] GoRouter configured in `lib/core/constants/routes.dart`
- [x] Main app wrapped in `ProviderScope`
- [x] Hive initialized in main.dart
- [x] Key screens converted to GoRouter (UserTypeSelector, More, Chef Inventory)
- [x] Feature modules created (customer, chef, admin)
- [x] Riverpod providers implemented
- [x] Tests updated and passing
- [ ] Deprecation warnings added to `lib/view/*` (if keeping temporarily)
- [ ] All legacy Navigator calls converted (incremental)
- [ ] Documentation complete (this file)

---

## FAQ

**Q: Can I still use `Navigator.push()` for dialogs/modals?**  
A: Yes! GoRouter is for screen-level navigation. Use `Navigator.push()` or `showDialog()` for overlays.

**Q: What about deep linking?**  
A: GoRouter handles it automatically. Define paths like `/chef/inventory/:id` and access via `state.pathParameters['id']`.

**Q: How do I pass data between screens?**  
A: Use route parameters, query parameters, or Riverpod providers. Avoid passing large objects directly.

**Q: Where do I put complex business logic?**  
A: In Riverpod providers or repository methods, not in widgets.

**Q: What if I need to access a provider outside a widget?**  
A: Use `ProviderContainer` in services or use `ref.read()` in provider methods.

---

## Support

For questions or issues:
1. Check existing patterns in `lib/features/`
2. Review test examples in `test/widget/` and `test/unit/`
3. Consult Flutter/Riverpod/GoRouter official docs

**Happy coding! 🚀**
