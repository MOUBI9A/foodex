// MockDataProvider reads seed JSON files from lib/mock.
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class MockDataProvider {
  static Future<Map<String, dynamic>> load(String name) async {
    final str = await rootBundle.loadString('lib/mock/$name');
    return json.decode(str) as Map<String, dynamic>;
  }
}
