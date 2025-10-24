import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// Import views (will be organized in presentation layer)
import '../../presentation/pages/login/welcome_view.dart';
import '../../presentation/pages/login/login_view.dart';
import '../../presentation/pages/login/sing_up_view.dart';
import '../../presentation/pages/login/otp_view.dart';
import '../../presentation/pages/login/rest_password_view.dart';
import '../../presentation/pages/login/new_password_view.dart';
import '../../presentation/pages/on_boarding/startup_view.dart';
import '../../presentation/pages/on_boarding/on_boarding_view.dart';
import '../../presentation/pages/main_tabview/main_tabview.dart';
import '../../presentation/pages/home/home_view.dart';
import '../../presentation/pages/menu/menu_view.dart';
import '../../presentation/pages/menu/item_details_view.dart';
import '../../presentation/pages/offer/offer_view.dart';
import '../../presentation/pages/more/more_view.dart';
import '../../presentation/pages/profile/profile_view.dart';
import '../../presentation/pages/more/my_order_view.dart';
import '../../presentation/pages/more/notification_view.dart';
import '../../presentation/pages/more/payment_details_view.dart';
import '../../presentation/pages/more/inbox_view.dart';
import '../../presentation/pages/more/add_card_view.dart';
import '../../presentation/pages/more/change_address_view.dart';
import '../../presentation/pages/more/about_us_view.dart';
import '../../presentation/pages/more/checkout_view.dart';
import '../../presentation/pages/more/help_support_view.dart';
import '../../presentation/pages/more/order_detail_view.dart';
import '../../presentation/pages/wallet/wallet_view.dart';
// import '../../presentation/pages/admin/admin_home_view.dart'; // File doesn't exist
// import '../../presentation/pages/chef/chef_home_view.dart'; // Temporarily commented
import '../../presentation/pages/chef/chef_main_tabview.dart';
import '../../presentation/pages/chef/chef_orders_view.dart';
import '../../presentation/pages/chef/chef_menu_view.dart';
import '../../presentation/pages/chef/chef_earnings_view.dart';
import '../../presentation/pages/chef/chef_profile_view.dart';
import '../../presentation/pages/driver/driver_home_view.dart';
import '../../presentation/pages/driver/driver_orders_view.dart';
import '../../presentation/pages/driver/driver_earnings_view.dart';
import '../../presentation/pages/driver/driver_profile_view.dart';
import '../../presentation/pages/user_type_selector_view.dart';
import '../../presentation/pages/cart/cart_view.dart';
import '../../presentation/pages/cart/empty_cart_view.dart';
import '../../presentation/pages/search/search_view.dart';
import '../../presentation/pages/order/order_success_view.dart';
import '../utils/logger.dart';

// Admin imports
import '../../features/admin/common/layouts/admin_layout.dart';
import '../../features/admin/auth/admin_login_page.dart';
import '../../features/admin/dashboard/dashboard_page.dart';
import '../../features/admin/users/admin_users_page.dart';
import '../../features/admin/chefs/chefs_screen.dart';
import '../../features/admin/orders/admin_orders_page.dart';
import '../../features/admin/couriers/couriers_screen.dart';
import '../../features/admin/analytics/admin_analytics_page.dart';
import '../../features/admin/settings/admin_settings_page.dart';
import '../../features/admin/logs/logs_screen.dart';

/// Application Routes
class AppRoutes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String signUp = '/sign-up';
  static const String otp = '/otp';
  static const String resetPassword = '/reset-password';
  static const String newPassword = '/new-password';
  static const String startup = '/startup';
  static const String onboarding = '/onboarding';
  static const String userTypeSelector = '/user-type';

  static const String main = '/main';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String offers = '/offers';
  static const String profile = '/profile';
  static const String more = '/more';

  // Wallet
  static const String wallet = '/wallet';

  // More section routes
  static const String myOrders = '/my-orders';
  static const String notifications = '/notifications';
  static const String paymentDetails = '/payment-details';
  static const String inbox = '/inbox';
  static const String addCard = '/add-card';
  static const String changeAddress = '/change-address';
  static const String aboutUs = '/about-us';
  static const String checkout = '/checkout';
  static const String helpSupport = '/help-support';

  // Detail routes with parameters
  static const String menuItemDetail = '/menu-item/:id';
  static const String orderDetail = '/order/:id';

  // Cart & Order routes
  static const String cart = '/cart';
  static const String emptyCart = '/empty-cart';
  static const String search = '/search';
  static const String orderSuccess = '/order-success';

  // Chef routes
  static const String chefHome = '/chef-home';
  static const String chefOrders = '/chef-orders';
  static const String chefMenu = '/chef-menu';
  static const String chefEarnings = '/chef-earnings';
  static const String chefProfile = '/chef-profile';

  // Driver routes
  static const String driverHome = '/driver-home';
  static const String driverOrders = '/driver-orders';
  static const String driverEarnings = '/driver-earnings';
  static const String driverProfile = '/driver-profile';

  // Admin routes
  static const String adminLogin = '/admin/login';
  static const String admin = '/admin';
  static const String adminDashboard = '/admin/dashboard';
  static const String adminUsers = '/admin/users';
  static const String adminChefs = '/admin/chefs';
  static const String adminOrders = '/admin/orders';
  static const String adminCouriers = '/admin/couriers';
  static const String adminAnalytics = '/admin/analytics';
  static const String adminSettings = '/admin/settings';
  static const String adminLogs = '/admin/logs';
}

/// Professional Router Configuration
class AppRouter {
  static final _logger = Logger('AppRouter');

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.welcome,
    debugLogDiagnostics: true,

    // Error handling
    errorBuilder: (context, state) {
      _logger.error('Navigation error: ${state.error}');
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 80, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Page not found',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                state.error?.toString() ?? 'Unknown error',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: () => context.go(AppRoutes.welcome),
                child: const Text('Go to Home'),
              ),
            ],
          ),
        ),
      );
    },

    // Route configuration
    routes: [
      // ========== Authentication Routes ==========
      GoRoute(
        path: AppRoutes.startup,
        name: 'startup',
        builder: (context, state) => const StartupView(),
      ),

      GoRoute(
        path: AppRoutes.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnBoardingView(),
      ),

      GoRoute(
        path: AppRoutes.welcome,
        name: 'welcome',
        builder: (context, state) => const WelcomeView(),
      ),

      GoRoute(
        path: AppRoutes.userTypeSelector,
        name: 'userTypeSelector',
        builder: (context, state) => const UserTypeSelectorView(),
      ),

      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        builder: (context, state) => const LoginView(),
      ),

      GoRoute(
        path: AppRoutes.signUp,
        name: 'signUp',
        builder: (context, state) => const SignUpView(),
      ),

      GoRoute(
        path: AppRoutes.otp,
        name: 'otp',
        builder: (context, state) {
          final email = state.extra as String? ?? '';
          return OTPView(email: email);
        },
      ),

      GoRoute(
        path: AppRoutes.resetPassword,
        name: 'resetPassword',
        builder: (context, state) => const ResetPasswordView(),
      ),

      GoRoute(
        path: AppRoutes.newPassword,
        name: 'newPassword',
        builder: (context, state) {
          final nObj = state.extra as Map? ?? {};
          return NewPasswordView(nObj: nObj);
        },
      ),

      // ========== Main App Routes ==========
      GoRoute(
        path: AppRoutes.main,
        name: 'main',
        builder: (context, state) => const MainTabView(),
      ),

      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        builder: (context, state) => const HomeView(),
      ),

      GoRoute(
        path: AppRoutes.menu,
        name: 'menu',
        builder: (context, state) => const MenuView(),
      ),

      GoRoute(
        path: AppRoutes.offers,
        name: 'offers',
        builder: (context, state) => const OfferView(),
      ),

      GoRoute(
        path: AppRoutes.profile,
        name: 'profile',
        builder: (context, state) => const ProfileView(),
      ),

      GoRoute(
        path: AppRoutes.wallet,
        name: 'wallet',
        builder: (context, state) => const WalletView(),
      ),

      // ========== More Section Routes ==========
      GoRoute(
        path: AppRoutes.more,
        name: 'more',
        builder: (context, state) => const MoreView(),
      ),

      GoRoute(
        path: AppRoutes.myOrders,
        name: 'myOrders',
        builder: (context, state) => const MyOrderView(),
      ),

      GoRoute(
        path: AppRoutes.notifications,
        name: 'notifications',
        builder: (context, state) => const NotificationsView(),
      ),

      GoRoute(
        path: AppRoutes.paymentDetails,
        name: 'paymentDetails',
        builder: (context, state) => const PaymentDetailsView(),
      ),

      GoRoute(
        path: AppRoutes.inbox,
        name: 'inbox',
        builder: (context, state) => const InboxView(),
      ),

      GoRoute(
        path: AppRoutes.addCard,
        name: 'addCard',
        builder: (context, state) => const AddCardView(),
      ),

      GoRoute(
        path: AppRoutes.changeAddress,
        name: 'changeAddress',
        builder: (context, state) => const ChangeAddressView(),
      ),

      GoRoute(
        path: AppRoutes.aboutUs,
        name: 'aboutUs',
        builder: (context, state) => const AboutUsView(),
      ),

      GoRoute(
        path: AppRoutes.checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutView(),
      ),

      GoRoute(
        path: AppRoutes.helpSupport,
        name: 'helpSupport',
        builder: (context, state) => const HelpSupportView(),
      ),

      // ========== Detail Routes with Parameters ==========
      GoRoute(
        path: AppRoutes.menuItemDetail,
        name: 'menuItemDetail',
        builder: (context, state) {
          // ItemDetailsView doesn't take parameters currently
          return const ItemDetailsView();
        },
      ),

      GoRoute(
        path: AppRoutes.orderDetail,
        name: 'orderDetail',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '0';
          return OrderDetailView(orderId: id);
        },
      ),

      // ========== Cart & Search Routes ==========
      GoRoute(
        path: AppRoutes.cart,
        name: 'cart',
        builder: (context, state) => const CartView(),
      ),

      GoRoute(
        path: AppRoutes.emptyCart,
        name: 'emptyCart',
        builder: (context, state) => const EmptyCartView(),
      ),

      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        builder: (context, state) => const SearchView(),
      ),

      GoRoute(
        path: AppRoutes.orderSuccess,
        name: 'orderSuccess',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return OrderSuccessView(
            orderId: extra['orderId'] ?? '#0000',
            totalAmount: extra['totalAmount'] ?? 0.0,
            estimatedDeliveryTime:
                extra['estimatedDeliveryTime'] ?? '30-45 min',
          );
        },
      ),

      // ========== Chef Routes ==========
      GoRoute(
        path: AppRoutes.chefHome,
        name: 'chefHome',
        builder: (context, state) =>
            const ChefMainTabView(), // Temporary: Using TabView instead
      ),

      GoRoute(
        path: AppRoutes.chefOrders,
        name: 'chefOrders',
        builder: (context, state) => const ChefOrdersView(),
      ),

      GoRoute(
        path: AppRoutes.chefMenu,
        name: 'chefMenu',
        builder: (context, state) => const ChefMenuView(),
      ),

      GoRoute(
        path: AppRoutes.chefEarnings,
        name: 'chefEarnings',
        builder: (context, state) => const ChefEarningsView(),
      ),

      GoRoute(
        path: AppRoutes.chefProfile,
        name: 'chefProfile',
        builder: (context, state) => const ChefProfileView(),
      ),

      // ========== Driver Routes ==========
      GoRoute(
        path: AppRoutes.driverHome,
        name: 'driverHome',
        builder: (context, state) => const DriverHomeView(),
      ),

      GoRoute(
        path: AppRoutes.driverOrders,
        name: 'driverOrders',
        builder: (context, state) => const DriverOrdersView(),
      ),

      GoRoute(
        path: AppRoutes.driverEarnings,
        name: 'driverEarnings',
        builder: (context, state) => const DriverEarningsView(),
      ),

      GoRoute(
        path: AppRoutes.driverProfile,
        name: 'driverProfile',
        builder: (context, state) => const DriverProfileView(),
      ),

      // ========== Admin Routes ==========
      // Admin login (standalone, no layout wrapper)
      GoRoute(
        path: AppRoutes.adminLogin,
        name: 'adminLogin',
        builder: (context, state) => const AdminLoginPage(),
      ),

      // Admin redirect route
      GoRoute(
        path: AppRoutes.admin,
        name: 'admin',
        redirect: (context, state) => AppRoutes.adminDashboard,
      ),

      // Admin shell route (wraps all admin pages with AdminLayout)
      ShellRoute(
        builder: (context, state, child) {
          return AdminLayout(child: child);
        },
        routes: [
          GoRoute(
            path: AppRoutes.adminDashboard,
            name: 'adminDashboard',
            builder: (context, state) => const DashboardPage(),
          ),
          GoRoute(
            path: AppRoutes.adminUsers,
            name: 'adminUsers',
            builder: (context, state) => const AdminUsersPage(),
          ),
          GoRoute(
            path: AppRoutes.adminChefs,
            name: 'adminChefs',
            builder: (context, state) => const ChefsScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminOrders,
            name: 'adminOrders',
            builder: (context, state) => const AdminOrdersPage(),
          ),
          GoRoute(
            path: AppRoutes.adminCouriers,
            name: 'adminCouriers',
            builder: (context, state) => const CouriersScreen(),
          ),
          GoRoute(
            path: AppRoutes.adminAnalytics,
            name: 'adminAnalytics',
            builder: (context, state) => const AdminAnalyticsPage(),
          ),
          GoRoute(
            path: AppRoutes.adminSettings,
            name: 'adminSettings',
            builder: (context, state) => const AdminSettingsPage(),
          ),
          GoRoute(
            path: AppRoutes.adminLogs,
            name: 'adminLogs',
            builder: (context, state) => const LogsScreen(),
          ),
        ],
      ),
    ],

    // Navigation observers
    observers: [
      RouteObserver(),
    ],

    // Redirect logic (e.g., authentication guard)
    // redirect: (context, state) {
    //   final isLoggedIn = /* check auth state */;
    //   final isLoggingIn = state.matchedLocation == AppRoutes.login;
    //
    //   if (!isLoggedIn && !isLoggingIn) {
    //     return AppRoutes.login;
    //   }
    //
    //   if (isLoggedIn && isLoggingIn) {
    //     return AppRoutes.main;
    //   }
    //
    //   return null;
    // },
  );
}

/// Custom route observer for logging
class RouteObserver extends NavigatorObserver {
  final _logger = Logger('RouteObserver');

  @override
  void didPush(Route route, Route? previousRoute) {
    _logger.info('Pushed: ${route.settings.name}');
  }

  @override
  void didPop(Route route, Route? previousRoute) {
    _logger.info('Popped: ${route.settings.name}');
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _logger.info(
        'Replaced: ${oldRoute?.settings.name} -> ${newRoute?.settings.name}');
  }
}
