// Logger - Lightweight logger to keep logs consistent and disable in release.
import 'package:flutter/foundation.dart';

class Log {
  static void d(String message, {Object? data}) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[DEBUG] $message${data != null ? ' | $data' : ''}');
    }
  }

  static void e(String message, {Object? error, StackTrace? stackTrace}) {
    if (kDebugMode) {
      // ignore: avoid_print
      print('[ERROR] $message');
      if (error != null) {
        // ignore: avoid_print
        print('> $error');
      }
      if (stackTrace != null) {
        // ignore: avoid_print
        print(stackTrace);
      }
    }
  }
}
