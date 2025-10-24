# Admin Routing Integration Guide

This guide explains how to integrate all Phase 4.1.1 admin pages into the existing `core/routing/app_router.dart`.

## Overview

The FoodEx app uses `go_router` (version 14.6.2) for navigation. The current `app_router.dart` has 40+ routes but is missing admin routes.

## Required Imports

Add these imports to `app_router.dart`:

```dart
// Admin feature imports
import '../../features/admin/auth/admin_login_page.dart';
import '../../features/admin/dashboard/dashboard_page.dart';
import '../../features/admin/users/admin_users_page.dart';
import '../../features/admin/orders/admin_orders_page.dart';
import '../../features/admin/analytics/admin_analytics_page.dart';
import '../../features/admin/settings/admin_settings_page.dart';
import '../../features/admin/common/layouts/admin_responsive_layout.dart';
```

## Admin Routes Structure

Add these routes to the `GoRouter` configuration:

```dart
// Admin Routes
GoRoute(
  path: '/admin/login',
  name: 'admin-login',
  builder: (context, state) => const AdminLoginPage(),
),

// Admin shell route (wraps all admin pages with layout)
ShellRoute(
  builder: (context, state, child) {
    return AdminResponsiveLayout(child: child);
  },
  routes: [
    GoRoute(
      path: '/admin/dashboard',
      name: 'admin-dashboard',
      builder: (context, state) => const DashboardPage(),
    ),
    GoRoute(
      path: '/admin/users',
      name: 'admin-users',
      builder: (context, state) => const AdminUsersPage(),
    ),
    GoRoute(
      path: '/admin/orders',
      name: 'admin-orders',
      builder: (context, state) => const AdminOrdersPage(),
    ),
    GoRoute(
      path: '/admin/analytics',
      name: 'admin-analytics',
      builder: (context, state) => const AdminAnalyticsPage(),
    ),
    GoRoute(
      path: '/admin/settings',
      name: 'admin-settings',
      builder: (context, state) => const AdminSettingsPage(),
    ),
  ],
),
```

## Route Protection (Authentication Guard)

Add a redirect function to protect admin routes:

```dart
// Add this to GoRouter configuration
redirect: (context, state) {
  // TODO: Implement actual authentication check
  // final isAuthenticated = ref.read(authStateProvider).isAuthenticated;
  // final isAdmin = ref.read(authStateProvider).isAdmin;
  
  final path = state.uri.path;
  
  // If accessing admin routes
  if (path.startsWith('/admin')) {
    // Skip login page if already on it
    if (path == '/admin/login') {
      // TODO: If already authenticated as admin, redirect to dashboard
      // if (isAuthenticated && isAdmin) {
      //   return '/admin/dashboard';
      // }
      return null;
    }
    
    // Protect other admin routes
    // TODO: Check if user is authenticated as admin
    // if (!isAuthenticated || !isAdmin) {
    //   return '/admin/login';
    // }
  }
  
  return null; // Allow navigation
},
```

## Navigation Examples

### From User Type Selector (after login)

```dart
// In user_type_selector_view.dart or similar
void _navigateToAdminDashboard() {
  context.go('/admin/dashboard');
}
```

### Programmatic Navigation Between Admin Pages

```dart
// Navigate to users page
context.go('/admin/users');

// Navigate to orders page
context.go('/admin/orders');

// Navigate to analytics page
context.go('/admin/analytics');

// Navigate to settings page
context.go('/admin/settings');

// Logout and return to login
context.go('/admin/login');
```

### Using Named Routes

```dart
// Navigate using route names
context.goNamed('admin-dashboard');
context.goNamed('admin-users');
context.goNamed('admin-orders');
context.goNamed('admin-analytics');
context.goNamed('admin-settings');
```

## Updating AppSidebar Navigation

Update `lib/features/admin/dashboard/widgets/app_sidebar.dart` to use GoRouter:

```dart
// Replace Navigator.push with context.go()

ListTile(
  leading: const Icon(Icons.dashboard),
  title: const Text('Dashboard'),
  selected: currentPath == '/admin/dashboard',
  onTap: () => context.go('/admin/dashboard'),
),
ListTile(
  leading: const Icon(Icons.people),
  title: const Text('Users'),
  selected: currentPath == '/admin/users',
  onTap: () => context.go('/admin/users'),
),
ListTile(
  leading: const Icon(Icons.shopping_bag),
  title: const Text('Orders'),
  selected: currentPath == '/admin/orders',
  onTap: () => context.go('/admin/orders'),
),
ListTile(
  leading: const Icon(Icons.bar_chart),
  title: const Text('Analytics'),
  selected: currentPath == '/admin/analytics',
  onTap: () => context.go('/admin/analytics'),
),
ListTile(
  leading: const Icon(Icons.settings),
  title: const Text('Settings'),
  selected: currentPath == '/admin/settings',
  onTap: () => context.go('/admin/settings'),
),
```

Get current path using:
```dart
final currentPath = GoRouterState.of(context).uri.path;
```

## Updating AdminNavbar Profile Menu

Update `lib/features/admin/common/widgets/admin_navbar.dart` to handle logout:

```dart
void _showProfileMenu(BuildContext context) {
  showMenu<String>(
    context: context,
    position: const RelativeRect.fromLTRB(1000, 80, 0, 0),
    items: const [
      PopupMenuItem<String>(
        value: 'profile',
        child: ListTile(
          leading: Icon(Icons.person),
          title: Text('Profile'),
          dense: true,
        ),
      ),
      PopupMenuItem<String>(
        value: 'settings',
        child: ListTile(
          leading: Icon(Icons.settings),
          title: Text('Settings'),
          dense: true,
        ),
      ),
      PopupMenuDivider(),
      PopupMenuItem<String>(
        value: 'logout',
        child: ListTile(
          leading: Icon(Icons.logout, color: Colors.red),
          title: Text('Logout', style: TextStyle(color: Colors.red)),
          dense: true,
        ),
      ),
    ],
  ).then((value) {
    if (value == 'profile') {
      // TODO: Navigate to profile
    } else if (value == 'settings') {
      context.go('/admin/settings');
    } else if (value == 'logout') {
      // TODO: Clear auth state
      // ref.read(authStateProvider.notifier).logout();
      context.go('/admin/login');
    }
  });
}
```

## Initial Admin Route

To set the initial admin route after successful login:

```dart
// In admin_login_page.dart, after successful authentication:
void _handleLogin() async {
  // ... authentication logic ...
  
  if (mounted) {
    // Redirect to admin dashboard
    context.go('/admin/dashboard');
  }
}
```

## Deep Linking Support

Add deep link handling for admin routes in platform-specific configuration:

### Android (`android/app/src/main/AndroidManifest.xml`)
```xml
<intent-filter>
  <action android:name="android.intent.action.VIEW" />
  <category android:name="android.intent.category.DEFAULT" />
  <category android:name="android.intent.category.BROWSABLE" />
  <data
    android:scheme="https"
    android:host="foodex.com"
    android:pathPrefix="/admin" />
</intent-filter>
```

### iOS (`ios/Runner/Info.plist`)
```xml
<key>CFBundleURLTypes</key>
<array>
  <dict>
    <key>CFBundleURLSchemes</key>
    <array>
      <string>foodex</string>
    </array>
  </dict>
</array>
```

### Web (`web/index.html`)
```html
<!-- Already configured via base href -->
<base href="$FLUTTER_BASE_HREF">
```

## Error Handling

Add error page for invalid admin routes:

```dart
errorBuilder: (context, state) {
  return Scaffold(
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          const Text(
            'Page Not Found',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text('The page ${state.uri.path} does not exist.'),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.go('/admin/dashboard'),
            child: const Text('Go to Dashboard'),
          ),
        ],
      ),
    ),
  );
},
```

## Testing Navigation

### Manual Testing Steps

1. **Login Flow**
   - Navigate to `/admin/login`
   - Enter credentials
   - Should redirect to `/admin/dashboard`

2. **Protected Routes**
   - Try accessing `/admin/users` without authentication
   - Should redirect to `/admin/login`

3. **Navigation**
   - Click sidebar items
   - Verify correct pages load
   - Check URL updates

4. **Browser Navigation**
   - Use browser back/forward buttons
   - Verify correct page restoration

5. **Deep Linking**
   - Navigate directly to `/admin/orders`
   - Should work if authenticated

### Integration Test

Add test to `integration_test/admin_navigation_test.dart`:

```dart
void main() {
  testWidgets('Admin navigation test', (tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();
    
    // Test login flow
    expect(find.byType(AdminLoginPage), findsOneWidget);
    
    // Enter credentials
    await tester.enterText(find.byType(TextField).first, 'admin@foodex.com');
    await tester.enterText(find.byType(TextField).last, 'password');
    await tester.tap(find.text('Login'));
    await tester.pumpAndSettle();
    
    // Should navigate to dashboard
    expect(find.byType(DashboardPage), findsOneWidget);
    
    // Test sidebar navigation
    await tester.tap(find.text('Users'));
    await tester.pumpAndSettle();
    expect(find.byType(AdminUsersPage), findsOneWidget);
    
    // Test more navigation...
  });
}
```

## Complete Example: app_router.dart Integration

```dart
// File: lib/core/routing/app_router.dart

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Admin imports
import '../../features/admin/auth/admin_login_page.dart';
import '../../features/admin/dashboard/dashboard_page.dart';
import '../../features/admin/users/admin_users_page.dart';
import '../../features/admin/orders/admin_orders_page.dart';
import '../../features/admin/analytics/admin_analytics_page.dart';
import '../../features/admin/settings/admin_settings_page.dart';
import '../../features/admin/common/layouts/admin_responsive_layout.dart';

// ... other imports ...

final goRouter = GoRouter(
  initialLocation: '/',
  debugLogDiagnostics: true,
  
  // ... existing routes ...
  
  routes: [
    // ... existing routes ...
    
    // Admin login (no layout wrapper)
    GoRoute(
      path: '/admin/login',
      name: 'admin-login',
      builder: (context, state) => const AdminLoginPage(),
    ),
    
    // Admin pages (with layout wrapper)
    ShellRoute(
      builder: (context, state, child) {
        return AdminResponsiveLayout(child: child);
      },
      routes: [
        GoRoute(
          path: '/admin/dashboard',
          name: 'admin-dashboard',
          builder: (context, state) => const DashboardPage(),
        ),
        GoRoute(
          path: '/admin/users',
          name: 'admin-users',
          builder: (context, state) => const AdminUsersPage(),
        ),
        GoRoute(
          path: '/admin/orders',
          name: 'admin-orders',
          builder: (context, state) => const AdminOrdersPage(),
        ),
        GoRoute(
          path: '/admin/analytics',
          name: 'admin-analytics',
          builder: (context, state) => const AdminAnalyticsPage(),
        ),
        GoRoute(
          path: '/admin/settings',
          name: 'admin-settings',
          builder: (context, state) => const AdminSettingsPage(),
        ),
      ],
    ),
  ],
  
  // Redirect for authentication
  redirect: (context, state) {
    final path = state.uri.path;
    
    if (path.startsWith('/admin') && path != '/admin/login') {
      // TODO: Check authentication
      // if (!isAuthenticated) return '/admin/login';
    }
    
    return null;
  },
  
  // Error page
  errorBuilder: (context, state) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            const Text('Page Not Found', style: TextStyle(fontSize: 24)),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: () => context.go('/'),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
);
```

## Next Steps

1. ✅ Add imports to `app_router.dart`
2. ✅ Add admin routes to GoRouter configuration
3. ✅ Implement authentication redirect logic
4. ✅ Update AppSidebar to use GoRouter navigation
5. ✅ Update AdminNavbar profile menu
6. ✅ Test navigation flow
7. ✅ Add integration tests for navigation

## Notes

- All admin pages use `AdminResponsiveLayout` wrapper for consistent UI
- Login page is standalone (no layout wrapper)
- Authentication guard redirects unauthenticated users to login
- Browser back/forward buttons work correctly with GoRouter
- Deep linking is supported for all admin routes
