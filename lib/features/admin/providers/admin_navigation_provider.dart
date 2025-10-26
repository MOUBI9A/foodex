// Admin navigation state providers for page selection.
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/routes.dart';

// Current selected admin sidebar page
final adminSelectedPageProvider = StateProvider<String>((ref) => 'dashboard');

// Current selected route for navigation dropdown
final adminNavigationRouteProvider = StateProvider<String>((ref) => AppRouteNames.adminDashboard);
