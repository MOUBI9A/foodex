// ApiService abstraction supporting MockMode and RealMode (Dio).
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:dio/dio.dart';
import '../constants/app_constants.dart';

enum ApiMode { mock, real }

abstract class ApiService {
  ApiMode get mode;
  Future<Map<String, dynamic>> getJson(String path);
}

class MockApiService implements ApiService {
  @override
  final ApiMode mode = ApiMode.mock;

  // Reads a JSON file from lib/mock/path.json
  @override
  Future<Map<String, dynamic>> getJson(String path) async {
    final data = await rootBundle.loadString('lib/mock/$path.json');
    return json.decode(data) as Map<String, dynamic>;
  }
}

class RealApiService implements ApiService {
  @override
  final ApiMode mode = ApiMode.real;
  final Dio _dio;

  RealApiService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(
    baseUrl: AppConstants.baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));

  @override
  Future<Map<String, dynamic>> getJson(String path) async {
    if (kDebugMode) {
      // Not enabled by default. Switch AppConstants.enableMockBackend when ready.
    }
    final res = await _dio.get(path);
    return res.data as Map<String, dynamic>;
  }
}
