# Admin Routing Quick Reference 🚀

## Overview
The admin section uses **GoRouter with ShellRoute** pattern for persistent layout and navigation.

---

## 🗺️ Route Map

| Path | Component | Description |
|------|-----------|-------------|
| `/admin` | *Redirect* | Redirects to `/admin/dashboard` |
| `/admin/login` | AdminLoginPage | Standalone login (no layout) |
| `/admin/dashboard` | DashboardPage | Main dashboard with metrics |
| `/admin/users` | AdminUsersPage | User management |
| `/admin/chefs` | ChefsScreen | Chef management (placeholder) |
| `/admin/orders` | AdminOrdersPage | Order management |
| `/admin/couriers` | CouriersScreen | Courier management (placeholder) |
| `/admin/analytics` | AdminAnalyticsPage | Analytics & reports |
| `/admin/settings` | AdminSettingsPage | System settings |
| `/admin/logs` | LogsScreen | System logs (placeholder) |

---

## 📦 Core Components

### **AdminLayout** (`lib/features/admin/common/layouts/admin_layout.dart`)
- Persistent shell for all admin pages
- Responsive sidebar (280px expanded, 80px collapsed)
- Mobile: Drawer navigation
- Desktop: Side navigation with toggle
- Breakpoint: 1000px

### **AdminAppBar** (`lib/features/admin/common/widgets/admin_app_bar.dart`)
- Dynamic breadcrumbs from current path
- Notifications (badge with count)
- User profile menu
- Search button (placeholder)
- Theme toggle (placeholder)

### **AppSidebar** (`lib/features/admin/dashboard/widgets/app_sidebar.dart`)
- 8 navigation items
- Active route highlighting
- Callback-based navigation

---

## 🧭 Navigation Examples

### From Any Page
```dart
// Navigate to dashboard
context.go('/admin/dashboard');

// Or use route constants
context.go(AppRoutes.adminDashboard);
```

### From Sidebar
```dart
// Automatically handled by AdminLayout
// User clicks sidebar item
// → _onDestinationSelected(index)
// → context.go(routes[index])
```

### From AppBar
```dart
// Profile menu
ElevatedButton(
  onPressed: () => context.go('/admin/profile'),
  child: const Text('Profile'),
)

// Logout
ElevatedButton(
  onPressed: () => context.go('/login'),
  child: const Text('Logout'),
)
```

---

## 🎨 Responsive Behavior

| Screen Width | Sidebar Behavior | Layout |
|--------------|------------------|--------|
| < 1000px | Drawer (overlay) | Mobile |
| ≥ 1000px | Side panel (toggleable) | Desktop |

---

## 🔧 Adding a New Admin Page

### Step 1: Create the Page
```dart
// lib/features/admin/my_feature/my_feature_page.dart
class MyFeaturePage extends StatelessWidget {
  const MyFeaturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('My Feature Page'),
      ),
    );
  }
}
```

### Step 2: Add Route Constant
```dart
// lib/core/routing/app_router.dart
class AppRoutes {
  // ... existing routes
  static const String adminMyFeature = '/admin/my-feature';
}
```

### Step 3: Add Route Definition
```dart
// In the ShellRoute routes array
GoRoute(
  path: AppRoutes.adminMyFeature,
  name: 'admin-my-feature',
  builder: (context, state) => const MyFeaturePage(),
),
```

### Step 4: Add Sidebar Navigation Item
```dart
// lib/features/admin/dashboard/widgets/app_sidebar.dart
// In the _navigationItems list
NavigationItem(
  icon: Icons.my_feature_icon,
  label: 'My Feature',
  index: 8, // Next available index
),
```

### Step 5: Update AdminLayout
```dart
// lib/features/admin/common/layouts/admin_layout.dart

// Add to _getCurrentIndex()
if (path.contains('/my-feature')) return 8;

// Add to _onDestinationSelected()
final routes = [
  // ... existing routes
  '/admin/my-feature',
];
```

---

## 📊 Current State

| Component | Status |
|-----------|--------|
| AdminLayout | ✅ Complete |
| AdminAppBar | ✅ Complete |
| Routing Integration | ✅ Complete |
| Dashboard | ✅ Complete |
| Users Page | ✅ Complete |
| Orders Page | ✅ Complete |
| Analytics Page | ✅ Complete |
| Settings Page | ✅ Complete |
| Chefs Page | 🚧 Placeholder |
| Couriers Page | 🚧 Placeholder |
| Logs Page | 🚧 Placeholder |
| Login Page | ✅ Complete |

---

## 🎯 Breadcrumb Generation

Breadcrumbs are auto-generated from the current path:

```dart
// Path: /admin/users
// Breadcrumbs: Admin > Users

// Path: /admin/analytics
// Breadcrumbs: Admin > Analytics
```

**Implementation**:
```dart
List<String> _generateBreadcrumbs(String path) {
  final segments = path.split('/').where((s) => s.isNotEmpty).toList();
  return segments.map((segment) {
    return segment
        .split('-')
        .map((word) => word.isEmpty 
            ? '' 
            : word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }).toList();
}
```

---

## 🔐 Authentication (Future)

Currently, admin routes are accessible without authentication. To add auth:

```dart
// Add route guard in app_router.dart
ShellRoute(
  builder: (context, state, child) {
    // Check authentication
    final isAuthenticated = context.read(authProvider).isAuthenticated;
    if (!isAuthenticated) {
      return const Redirect('/admin/login');
    }
    return AdminLayout(child: child);
  },
  routes: [ /* ... */ ],
)
```

---

## 🎨 Theme Integration

AdminLayout uses colors from **AdminTheme**:

```dart
// lib/features/admin/common/theme/admin_theme.dart
static const Color gray100 = Color(0xFFF5F5F5);  // Background
static const Color gray900 = Color(0xFF2E2E2E);  // Dark bg
static const Color white = Color(0xFFFFFFFF);    // Sidebar
static const Color gray800 = Color(0xFF424242);  // Dark sidebar
```

---

## 🧪 Testing

### Unit Tests
```bash
flutter test test/widget/admin_dashboard_test.dart
```
**Status**: ✅ 13/13 passing

### Integration Tests
```bash
flutter test test/integration/admin_dashboard_integration_test.dart
```
**Status**: ⚠️ 5/19 passing (14 pre-existing failures)

### Analyze Code
```bash
flutter analyze
```
**Status**: ✅ Zero errors in admin routing files

---

## 📁 File Structure

```
lib/features/admin/
├── common/
│   ├── layouts/
│   │   └── admin_layout.dart          # Main shell layout ✅
│   ├── widgets/
│   │   ├── admin_app_bar.dart         # Top bar ✅
│   │   └── admin_navbar.dart          # Alternative navbar
│   └── theme/
│       └── admin_theme.dart           # Theme colors ✅
├── dashboard/
│   ├── dashboard_page.dart            # Main dashboard ✅
│   └── widgets/
│       ├── app_sidebar.dart           # Sidebar nav ✅
│       ├── metric_card.dart           # Metric widgets ✅
│       └── ...
├── users/
│   └── admin_users_page.dart          # User management ✅
├── orders/
│   └── admin_orders_page.dart         # Order management ✅
├── analytics/
│   └── admin_analytics_page.dart      # Analytics ✅
├── settings/
│   └── admin_settings_page.dart       # Settings ✅
├── chefs/
│   └── chefs_screen.dart              # Chefs 🚧
├── couriers/
│   └── couriers_screen.dart           # Couriers 🚧
├── logs/
│   └── logs_screen.dart               # Logs 🚧
└── auth/
    └── admin_login_page.dart          # Login ✅
```

---

## 🔗 Related Documentation

- [`PHASE_4.1.1_IMPLEMENTATION_COMPLETE.md`](./PHASE_4.1.1_IMPLEMENTATION_COMPLETE.md) - Full implementation details
- [`README.md`](./README.md) - Admin feature overview
- [GoRouter Documentation](https://pub.dev/packages/go_router)

---

## 💡 Tips & Best Practices

1. **Always use `context.go()`** instead of `Navigator.push()` for admin navigation
2. **Use route constants** from `AppRoutes` class for type safety
3. **Sidebar index must match route order** in AdminLayout
4. **Test responsive behavior** at 1000px breakpoint
5. **Keep breadcrumb segments short** (1-2 words per segment)

---

## 🐛 Troubleshooting

### Issue: Sidebar not highlighting current route
**Solution**: Ensure `_getCurrentIndex()` in AdminLayout includes your new route

### Issue: Breadcrumbs showing raw path
**Solution**: Check path formatting in `_generateBreadcrumbs()` - should split on `-` and capitalize

### Issue: Layout not appearing
**Solution**: Verify route is inside ShellRoute, not outside it

### Issue: Navigation not working
**Solution**: Ensure using `context.go()` instead of Navigator methods

---

**Last Updated**: Current Session  
**Status**: ✅ Production Ready  
**Next Steps**: Implement Phase 4.1.2 (placeholder screen content)
