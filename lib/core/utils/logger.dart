import 'dart:developer' as developer;

class Logger {
  static const String _prefix = 'FoodEx';

  static void info(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? _prefix,
      level: 800, // Info level
    );
  }

  static void warning(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? _prefix,
      level: 900, // Warning level
    );
  }

  static void error(String message, {String? tag, Object? error}) {
    developer.log(
      message,
      name: tag ?? _prefix,
      level: 1000, // Error level
      error: error,
    );
  }

  static void debug(String message, {String? tag}) {
    developer.log(
      message,
      name: tag ?? _prefix,
      level: 700, // Debug level
    );
  }
}
