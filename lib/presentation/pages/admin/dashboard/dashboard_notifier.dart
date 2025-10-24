import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../data/models/dashboard_overview.dart';
import '../../../../data/models/revenue_point.dart';
import '../../../../data/models/system_health.dart';
import '../../../../data/repositories/admin/dashboard_repository.dart';
import '../../../../core/utils/logger.dart';

/// State for Admin Dashboard
class DashboardState {
  final DashboardOverview? overview;
  final List<RevenuePoint> revenueData;
  final Map<String, dynamic>? ordersData;
  final SystemHealth? systemHealth;
  final bool isLoading;
  final String? error;
  final DateTime startDate;
  final DateTime endDate;
  final String revenueGranularity;
  final int currentPage;
  final String? orderStatus;
  final String? searchQuery;

  DashboardState({
    this.overview,
    this.revenueData = const [],
    this.ordersData,
    this.systemHealth,
    this.isLoading = false,
    this.error,
    DateTime? startDate,
    DateTime? endDate,
    this.revenueGranularity = 'day',
    this.currentPage = 1,
    this.orderStatus,
    this.searchQuery,
  })  : startDate = startDate ?? _getDefaultStartDate(),
        endDate = endDate ?? _getDefaultEndDate();

  static DateTime _getDefaultStartDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day - 7);
  }

  static DateTime _getDefaultEndDate() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  DashboardState copyWith({
    DashboardOverview? overview,
    List<RevenuePoint>? revenueData,
    Map<String, dynamic>? ordersData,
    SystemHealth? systemHealth,
    bool? isLoading,
    String? error,
    DateTime? startDate,
    DateTime? endDate,
    String? revenueGranularity,
    int? currentPage,
    String? orderStatus,
    String? searchQuery,
    bool clearError = false,
  }) {
    return DashboardState(
      overview: overview ?? this.overview,
      revenueData: revenueData ?? this.revenueData,
      ordersData: ordersData ?? this.ordersData,
      systemHealth: systemHealth ?? this.systemHealth,
      isLoading: isLoading ?? this.isLoading,
      error: clearError ? null : (error ?? this.error),
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      revenueGranularity: revenueGranularity ?? this.revenueGranularity,
      currentPage: currentPage ?? this.currentPage,
      orderStatus: orderStatus ?? this.orderStatus,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

/// Provider for DashboardRepository
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  return DashboardRepository();
});

/// Notifier for Admin Dashboard
class DashboardNotifier extends StateNotifier<DashboardState> {
  final DashboardRepository _repository;
  final Logger _logger = Logger('DashboardNotifier');

  DashboardNotifier(this._repository) : super(DashboardState()) {
    // Initialize with default date range (last 7 days)
    final now = DateTime.now();
    final endDate = DateTime(now.year, now.month, now.day);
    final startDate = endDate.subtract(const Duration(days: 7));

    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
    );

    _logger.info('DashboardNotifier initialized');
    loadAllData();
  }

  /// Load all dashboard data
  Future<void> loadAllData() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      await Future.wait([
        _loadOverview(),
        _loadRevenue(),
        _loadOrders(),
        _loadSystemHealth(),
      ]);

      state = state.copyWith(isLoading: false);
      _logger.info('All dashboard data loaded successfully');
    } catch (e) {
      _logger.error('Failed to load dashboard data', error: e);
      state = state.copyWith(
        isLoading: false,
        error: 'Failed to load dashboard data: $e',
      );
    }
  }

  /// Load overview metrics
  Future<void> _loadOverview() async {
    try {
      final overview = await _repository.fetchOverview(
        startDate: state.startDate,
        endDate: state.endDate,
      );
      state = state.copyWith(overview: overview);
    } catch (e) {
      _logger.error('Failed to load overview', error: e);
      rethrow;
    }
  }

  /// Load revenue data
  Future<void> _loadRevenue() async {
    try {
      final revenueData = await _repository.fetchRevenue(
        granularity: state.revenueGranularity,
        startDate: state.startDate,
        endDate: state.endDate,
      );
      state = state.copyWith(revenueData: revenueData);
    } catch (e) {
      _logger.error('Failed to load revenue', error: e);
      rethrow;
    }
  }

  /// Load orders
  Future<void> _loadOrders() async {
    try {
      final ordersData = await _repository.fetchRecentOrders(
        status: state.orderStatus,
        page: state.currentPage,
        pageSize: 20,
        startDate: state.startDate,
        endDate: state.endDate,
        searchQuery: state.searchQuery,
      );
      state = state.copyWith(ordersData: ordersData);
    } catch (e) {
      _logger.error('Failed to load orders', error: e);
      rethrow;
    }
  }

  /// Load system health
  Future<void> _loadSystemHealth() async {
    try {
      final health = await _repository.fetchSystemHealth();
      state = state.copyWith(systemHealth: health);
    } catch (e) {
      _logger.error('Failed to load system health', error: e);
      rethrow;
    }
  }

  /// Update date range and reload data
  void updateDateRange(DateTime startDate, DateTime endDate) {
    _logger.info('Updating date range: $startDate to $endDate');
    state = state.copyWith(
      startDate: startDate,
      endDate: endDate,
      currentPage: 1, // Reset to first page
    );
    loadAllData();
  }

  /// Update revenue granularity and reload
  void updateRevenueGranularity(String granularity) {
    _logger.info('Updating revenue granularity: $granularity');
    state = state.copyWith(revenueGranularity: granularity);
    _loadRevenue();
  }

  /// Update order filters and reload
  void updateOrderFilters({
    String? status,
    String? searchQuery,
  }) {
    _logger.info('Updating order filters: status=$status, query=$searchQuery');
    state = state.copyWith(
      orderStatus: status,
      searchQuery: searchQuery,
      currentPage: 1, // Reset to first page
    );
    _loadOrders();
  }

  /// Go to specific page
  void goToPage(int page) {
    if (page < 1) return;

    _logger.info('Navigating to page: $page');
    state = state.copyWith(currentPage: page);
    _loadOrders();
  }

  /// Export orders to CSV
  Future<String> exportOrders() async {
    try {
      _logger.info('Exporting orders...');
      final csvData = await _repository.exportOrdersCSV(
        status: state.orderStatus,
        startDate: state.startDate,
        endDate: state.endDate,
        searchQuery: state.searchQuery,
      );
      _logger.info('Orders exported successfully');
      return csvData;
    } catch (e) {
      _logger.error('Failed to export orders', error: e);
      state = state.copyWith(error: 'Failed to export orders: $e');
      rethrow;
    }
  }

  /// Refresh all data (for pull-to-refresh)
  Future<void> refresh() async {
    _logger.info('Refreshing dashboard data...');
    await loadAllData();
  }

  /// Clear error message
  void clearError() {
    state = state.copyWith(clearError: true);
  }
}

/// Provider for DashboardNotifier
final dashboardNotifierProvider =
    StateNotifierProvider<DashboardNotifier, DashboardState>((ref) {
  final repository = ref.watch(dashboardRepositoryProvider);
  return DashboardNotifier(repository);
});
