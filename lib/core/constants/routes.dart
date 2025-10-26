// Centralized GoRouter routes and route names for FOODEx.
// Usage: import goRouter into MaterialApp.router (see main.dart).

import 'package:go_router/go_router.dart';

// Shells and screens
import 'package:food_delivery/presentation/pages/user_type_selector_view.dart';
import 'package:food_delivery/presentation/pages/main_tabview/main_tabview.dart';
import 'package:food_delivery/presentation/pages/chef/chef_main_tabview.dart';
import 'package:food_delivery/features/admin/screens/admin_dashboard_screen.dart';
import 'package:food_delivery/features/admin/screens/admin_panel_with_selector.dart';
import 'package:food_delivery/features/customer/screens/recommendations_screen.dart';
import 'package:food_delivery/features/customer/screens/taste_profile_form.dart';
import 'package:food_delivery/features/customer/screens/customer_ingredients_preferences_screen.dart';
import 'package:food_delivery/features/customer/screens/order_tracking_screen.dart';
import 'package:food_delivery/features/chef/screens/inventory_screen.dart';
import 'package:food_delivery/features/chef/screens/chef_orders_screen.dart';
import 'package:food_delivery/features/courier/screens/courier_home_screen.dart';
import 'package:food_delivery/features/admin/screens/admin_deliveries_screen.dart';
import 'package:food_delivery/presentation/pages/splash/splash_view.dart';

class AppRouteNames {
  AppRouteNames._();
  static const splash = '/';
  static const root = '/';
  static const selectUser = '/select-user';

  // Customer
  static const customer = '/customer';
  static const customerHome = '/customer/home';
  static const customerTasteProfile = '/customer/taste-profile';
  static const customerRecommendations = '/customer/recommendations';
  static const customerIngredientPreferences = '/customer/ingredient-preferences';
  static const customerOrderTracking = '/customer/tracking';

  // Chef
  static const chef = '/chef';
  static const chefInventory = '/chef/inventory';
  static const chefOrdersBoard = '/chef/orders-board';

  // Driver
  static const driver = '/driver';

  // Admin (web-first)
  static const adminDashboard = '/admin/dashboard';
  static const adminPanel = '/admin/panel';
  static const adminDeliveries = '/admin/deliveries';
}

// Single GoRouter instance.
final GoRouter goRouter = GoRouter(
  initialLocation: AppRouteNames.splash,
  routes: <RouteBase>[
    GoRoute(
      path: AppRouteNames.splash,
      name: 'splash',
      builder: (context, state) => const SplashView(),
    ),
    GoRoute(
      path: AppRouteNames.selectUser,
      name: 'selectUser',
      builder: (context, state) => const UserTypeSelectorView(),
    ),
    // Customer
    GoRoute(
      path: AppRouteNames.customerHome,
      name: 'customerHome',
      builder: (context, state) => const MainTabView(),
    ),
    GoRoute(
      path: AppRouteNames.customerTasteProfile,
      name: 'customerTasteProfile',
      builder: (context, state) => const TasteProfileForm(),
    ),
    GoRoute(
      path: AppRouteNames.customerRecommendations,
      name: 'customerRecommendations',
      builder: (context, state) => const RecommendationsScreen(),
    ),
    GoRoute(
      path: AppRouteNames.customerIngredientPreferences,
      name: 'customerIngredientPreferences',
      builder: (context, state) => const CustomerIngredientsPreferencesScreen(),
    ),
    GoRoute(
      path: AppRouteNames.customerOrderTracking,
      name: 'customerOrderTracking',
      builder: (context, state) => const OrderTrackingScreen(),
    ),

    // Chef
    GoRoute(
      path: AppRouteNames.chef,
      name: 'chef',
      builder: (context, state) => const ChefMainTabView(),
    ),
    GoRoute(
      path: AppRouteNames.chefInventory,
      name: 'chefInventory',
      builder: (context, state) => const InventoryScreen(),
    ),
    GoRoute(
      path: AppRouteNames.chefOrdersBoard,
      name: 'chefOrdersBoard',
      builder: (context, state) => const ChefOrdersScreen(),
    ),

    // Driver
    GoRoute(
      path: AppRouteNames.driver,
      name: 'driver',
      builder: (context, state) => const CourierHomeScreen(),
    ),

    // Admin
    GoRoute(
      path: AppRouteNames.adminDashboard,
      name: 'adminDashboard',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: AppRouteNames.adminPanel,
      name: 'adminPanel',
      builder: (context, state) => const AdminPanelWithSelector(),
    ),
    GoRoute(
      path: AppRouteNames.adminDeliveries,
      name: 'adminDeliveries',
      builder: (context, state) => const AdminDeliveriesScreen(),
    ),
  ],
);
