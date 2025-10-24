import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../config/app_config.dart';
import '../errors/failures.dart';
import '../utils/logger.dart';

/// HTTP Methods
enum HttpMethod { get, post, put, patch, delete }

/// Professional API Client with interceptors, retry logic, and error handling
class ApiClient {
  final http.Client _client;
  final Logger _logger = Logger('ApiClient');

  String? _authToken;

  ApiClient({http.Client? client}) : _client = client ?? http.Client();

  /// Set authentication token
  void setAuthToken(String token) {
    _authToken = token;
  }

  /// Clear authentication token
  void clearAuthToken() {
    _authToken = null;
  }

  /// Build headers
  Map<String, String> _buildHeaders({Map<String, String>? additionalHeaders}) {
    final headers = <String, String>{
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'X-App-Version': AppConfig.appVersion,
      'X-Platform': Platform.isAndroid
          ? 'android'
          : Platform.isIOS
              ? 'ios'
              : 'web',
    };

    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }

    if (additionalHeaders != null) {
      headers.addAll(additionalHeaders);
    }

    return headers;
  }

  /// Make HTTP request with retry logic
  Future<http.Response> _makeRequest({
    required HttpMethod method,
    required String endpoint,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
    int retryCount = 0,
    int maxRetries = 3,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final requestHeaders = _buildHeaders(additionalHeaders: headers);

    _logger.debug(
      '${method.name.toUpperCase()} $url\n'
      'Headers: $requestHeaders\n'
      'Body: ${body != null ? jsonEncode(body) : 'null'}',
    );

    try {
      http.Response response;
      final timeout = Duration(seconds: AppConfig.connectionTimeout);

      switch (method) {
        case HttpMethod.get:
          response =
              await _client.get(url, headers: requestHeaders).timeout(timeout);
          break;
        case HttpMethod.post:
          response = await _client
              .post(
                url,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
          break;
        case HttpMethod.put:
          response = await _client
              .put(
                url,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
          break;
        case HttpMethod.patch:
          response = await _client
              .patch(
                url,
                headers: requestHeaders,
                body: body != null ? jsonEncode(body) : null,
              )
              .timeout(timeout);
          break;
        case HttpMethod.delete:
          response = await _client
              .delete(url, headers: requestHeaders)
              .timeout(timeout);
          break;
      }

      _logger.debug(
        'Response ${response.statusCode}\n'
        'Body: ${response.body}',
      );

      return response;
    } on SocketException {
      _logger.error('SocketException: No internet connection');
      throw NetworkException.noInternet();
    } on TimeoutException {
      if (retryCount < maxRetries) {
        _logger.warning('Timeout, retrying... (${retryCount + 1}/$maxRetries)');
        await Future.delayed(Duration(seconds: (retryCount + 1) * 2));
        return _makeRequest(
          method: method,
          endpoint: endpoint,
          body: body,
          headers: headers,
          retryCount: retryCount + 1,
          maxRetries: maxRetries,
        );
      }
      _logger.error('TimeoutException after $maxRetries retries');
      throw NetworkException.timeout();
    } catch (e) {
      _logger.error('Unexpected error: $e');
      throw ServerException(
        message: 'An unexpected error occurred',
        error: e,
      );
    }
  }

  /// Handle response and convert to typed result
  Future<T> _handleResponse<T>(
    http.Response response,
    T Function(Map<String, dynamic>) fromJson,
  ) async {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body);
        if (data is Map<String, dynamic>) {
          return fromJson(data);
        } else if (data is List && data.isEmpty) {
          return fromJson({});
        }
        throw const ServerException(
          message: 'Invalid response format',
        );
      } catch (e) {
        _logger.error('JSON parsing error: $e');
        throw ServerException(
          message: 'Failed to parse response',
          error: e,
        );
      }
    } else {
      _handleError(response);
    }
  }

  /// Handle error responses
  Never _handleError(http.Response response) {
    String message = 'An error occurred';

    try {
      final data = jsonDecode(response.body);
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? data['error'] ?? message;
      }
    } catch (e) {
      message = response.body.isNotEmpty ? response.body : message;
    }

    throw ServerException.fromResponse(response.statusCode, message);
  }

  // ==================== HTTP METHODS ====================

  /// GET request
  Future<T> get<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    final response = await _makeRequest(
      method: HttpMethod.get,
      endpoint: endpoint,
      headers: headers,
    );
    return _handleResponse(response, fromJson);
  }

  /// POST request
  Future<T> post<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _makeRequest(
      method: HttpMethod.post,
      endpoint: endpoint,
      body: body,
      headers: headers,
    );
    return _handleResponse(response, fromJson);
  }

  /// PUT request
  Future<T> put<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _makeRequest(
      method: HttpMethod.put,
      endpoint: endpoint,
      body: body,
      headers: headers,
    );
    return _handleResponse(response, fromJson);
  }

  /// PATCH request
  Future<T> patch<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, dynamic>? body,
    Map<String, String>? headers,
  }) async {
    final response = await _makeRequest(
      method: HttpMethod.patch,
      endpoint: endpoint,
      body: body,
      headers: headers,
    );
    return _handleResponse(response, fromJson);
  }

  /// DELETE request
  Future<T> delete<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    final response = await _makeRequest(
      method: HttpMethod.delete,
      endpoint: endpoint,
      headers: headers,
    );
    return _handleResponse(response, fromJson);
  }

  /// GET request returning list
  Future<List<T>> getList<T>({
    required String endpoint,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? headers,
  }) async {
    final response = await _makeRequest(
      method: HttpMethod.get,
      endpoint: endpoint,
      headers: headers,
    );

    if (response.statusCode >= 200 && response.statusCode < 300) {
      try {
        final data = jsonDecode(response.body);
        if (data is List) {
          return data
              .map((item) => fromJson(item as Map<String, dynamic>))
              .toList();
        } else if (data is Map<String, dynamic> && data.containsKey('data')) {
          final list = data['data'] as List;
          return list
              .map((item) => fromJson(item as Map<String, dynamic>))
              .toList();
        }
        throw const ServerException(message: 'Invalid list response format');
      } catch (e) {
        _logger.error('JSON parsing error: $e');
        throw ServerException(message: 'Failed to parse response', error: e);
      }
    } else {
      _handleError(response);
    }
  }

  /// Upload file (multipart)
  Future<T> uploadFile<T>({
    required String endpoint,
    required File file,
    required String fieldName,
    required T Function(Map<String, dynamic>) fromJson,
    Map<String, String>? fields,
    Map<String, String>? headers,
  }) async {
    final url = Uri.parse('${AppConfig.baseUrl}$endpoint');
    final request = http.MultipartRequest('POST', url);

    request.headers.addAll(_buildHeaders(additionalHeaders: headers));

    if (fields != null) {
      request.fields.addAll(fields);
    }

    request.files.add(await http.MultipartFile.fromPath(fieldName, file.path));

    _logger.debug('Uploading file to $url');

    try {
      final streamedResponse = await request.send().timeout(
            Duration(seconds: AppConfig.sendTimeout),
          );
      final response = await http.Response.fromStream(streamedResponse);

      _logger.debug('Upload response ${response.statusCode}');

      return _handleResponse(response, fromJson);
    } on SocketException {
      throw NetworkException.noInternet();
    } on TimeoutException {
      throw NetworkException.timeout();
    } catch (e) {
      _logger.error('Upload error: $e');
      throw ServerException(message: 'File upload failed', error: e);
    }
  }

  /// Dispose client
  void dispose() {
    _client.close();
  }
}
