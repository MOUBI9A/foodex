import 'package:dio/dio.dart';
import '../../../core/utils/logger.dart';
import '../../models/dashboard_overview.dart';
import '../../models/revenue_point.dart';
import '../../models/system_health.dart';

/// Repository for fetching Admin Dashboard data.
/// Handles all API calls related to dashboard metrics and analytics.
class DashboardRepository {
  final Dio _dio;
  final Logger _logger = Logger('DashboardRepository');

  DashboardRepository({Dio? dio}) : _dio = dio ?? Dio();

  /// Fetch dashboard overview metrics
  /// GET /admin/dashboard/overview?start=...&end=...
  Future<DashboardOverview> fetchOverview({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      _logger.info('Fetching dashboard overview...');

      final queryParams = <String, dynamic>{};
      if (startDate != null) {
        queryParams['start'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        '/admin/dashboard/overview',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        _logger.info('Overview fetched successfully');
        return DashboardOverview.fromJson(response.data);
      }

      throw Exception('Failed to fetch overview: ${response.statusCode}');
    } catch (e) {
      _logger.error('Failed to fetch overview', error: e);
      rethrow;
    }
  }

  /// Fetch revenue data for chart
  /// GET /admin/dashboard/revenue?granularity=week&start=...&end=...
  Future<List<RevenuePoint>> fetchRevenue({
    String granularity = 'day', // day, week, month
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    try {
      _logger.info('Fetching revenue data with granularity: $granularity');

      final queryParams = <String, dynamic>{
        'granularity': granularity,
      };
      if (startDate != null) {
        queryParams['start'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end'] = endDate.toIso8601String();
      }

      final response = await _dio.get(
        '/admin/dashboard/revenue',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data as List;
        final points = data.map((json) => RevenuePoint.fromJson(json)).toList();
        _logger.info('Fetched ${points.length} revenue points');
        return points;
      }

      throw Exception('Failed to fetch revenue: ${response.statusCode}');
    } catch (e) {
      _logger.error('Failed to fetch revenue', error: e);
      rethrow;
    }
  }

  /// Fetch recent orders with filtering and pagination
  /// GET /admin/orders?status=&page=&pageSize=&start=&end=&q=
  Future<Map<String, dynamic>> fetchRecentOrders({
    String? status,
    int page = 1,
    int pageSize = 20,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) async {
    try {
      _logger.info('Fetching recent orders (page: $page, size: $pageSize)');

      final queryParams = <String, dynamic>{
        'page': page,
        'pageSize': pageSize,
      };
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (startDate != null) {
        queryParams['start'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end'] = endDate.toIso8601String();
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }

      final response = await _dio.get(
        '/admin/orders',
        queryParameters: queryParams,
      );

      if (response.statusCode == 200) {
        final data = response.data as Map<String, dynamic>;
        final total = data['total'] as int;
        final ordersJson = data['orders'] as List;

        // For now, return simplified data
        // TODO: Convert to OrderEntity when API contract is finalized
        _logger.info('Fetched ${ordersJson.length} orders (total: $total)');

        return {
          'total': total,
          'orders': ordersJson,
        };
      }

      throw Exception('Failed to fetch orders: ${response.statusCode}');
    } catch (e) {
      _logger.error('Failed to fetch orders', error: e);
      rethrow;
    }
  }

  /// Fetch system health status
  /// GET /admin/system/health
  Future<SystemHealth> fetchSystemHealth() async {
    try {
      _logger.info('Fetching system health...');

      final response = await _dio.get('/admin/system/health');

      if (response.statusCode == 200) {
        _logger.info('System health fetched successfully');
        return SystemHealth.fromJson(response.data);
      }

      throw Exception('Failed to fetch system health: ${response.statusCode}');
    } catch (e) {
      _logger.error('Failed to fetch system health', error: e);
      rethrow;
    }
  }

  /// Export orders to CSV
  /// GET /admin/orders/export?status=&start=&end=&q=
  Future<String> exportOrdersCSV({
    String? status,
    DateTime? startDate,
    DateTime? endDate,
    String? searchQuery,
  }) async {
    try {
      _logger.info('Exporting orders to CSV...');

      final queryParams = <String, dynamic>{};
      if (status != null && status.isNotEmpty) {
        queryParams['status'] = status;
      }
      if (startDate != null) {
        queryParams['start'] = startDate.toIso8601String();
      }
      if (endDate != null) {
        queryParams['end'] = endDate.toIso8601String();
      }
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['q'] = searchQuery;
      }

      final response = await _dio.get(
        '/admin/orders/export',
        queryParameters: queryParams,
        options: Options(responseType: ResponseType.plain),
      );

      if (response.statusCode == 200) {
        _logger.info('Orders exported successfully');
        return response.data as String;
      }

      throw Exception('Failed to export orders: ${response.statusCode}');
    } catch (e) {
      _logger.error('Failed to export orders', error: e);
      rethrow;
    }
  }
}
