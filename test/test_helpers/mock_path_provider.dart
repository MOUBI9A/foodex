import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Mocks the path_provider plugin on the test VM so calls like
/// getApplicationDocumentsDirectory() return a valid temp directory path.
Future<void> setUpMockPathProvider() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('plugins.flutter.io/path_provider');
  final tempDir = await Directory.systemTemp.createTemp('foodex_test_');

  channel.setMockMethodCallHandler((MethodCall call) async {
    switch (call.method) {
      case 'getApplicationDocumentsDirectory':
        return tempDir.path;
      case 'getTemporaryDirectory':
        return tempDir.path;
      case 'getApplicationSupportDirectory':
        return tempDir.path;
      case 'getLibraryDirectory':
        return tempDir.path;
      case 'getDownloadsDirectory':
        return tempDir.path;
    }
    return tempDir.path;
  });
}
