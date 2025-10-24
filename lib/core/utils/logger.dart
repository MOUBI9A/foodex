import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import '../config/app_config.dart';

/// Log levels
enum LogLevel {
  debug,
  info,
  warning,
  error,
  critical,
}

/// Professional logger with different levels and environment-aware logging
class Logger {
  final String className;

  Logger(this.className);

  /// Check if should log based on environment
  bool _shouldLog(LogLevel level) {
    if (!AppConfig.enableLogging) return false;

    // In production, only log warnings and above
    if (AppConfig.environment == Environment.production) {
      return level.index >= LogLevel.warning.index;
    }

    return true;
  }

  /// Format log message
  String _formatMessage(LogLevel level, String message) {
    final timestamp = DateTime.now().toIso8601String();
    final levelStr = level.name.toUpperCase().padRight(8);
    return '[$timestamp] $levelStr [$className] $message';
  }

  /// Log with color (for debug console)
  void _log(LogLevel level, String message,
      {Object? error, StackTrace? stackTrace}) {
    if (!_shouldLog(level)) return;

    final formattedMessage = _formatMessage(level, message);

    if (kDebugMode) {
      // Use dart:developer log in debug mode
      developer.log(
        message,
        name: className,
        time: DateTime.now(),
        level: _getLogLevelValue(level),
        error: error,
        stackTrace: stackTrace,
      );
    } else {
      // Use print in release mode (will be stripped if not logging)
      debugPrint(formattedMessage);
      if (error != null) {
        debugPrint('Error: $error');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }

  /// Get numeric log level for dart:developer
  int _getLogLevelValue(LogLevel level) {
    switch (level) {
      case LogLevel.debug:
        return 500;
      case LogLevel.info:
        return 800;
      case LogLevel.warning:
        return 900;
      case LogLevel.error:
        return 1000;
      case LogLevel.critical:
        return 1200;
    }
  }

  /// Debug log
  void debug(String message) {
    _log(LogLevel.debug, message);
  }

  /// Info log
  void info(String message) {
    _log(LogLevel.info, message);
  }

  /// Warning log
  void warning(String message) {
    _log(LogLevel.warning, message);
  }

  /// Error log
  void error(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.error, message, error: error, stackTrace: stackTrace);
  }

  /// Critical log
  void critical(String message, {Object? error, StackTrace? stackTrace}) {
    _log(LogLevel.critical, message, error: error, stackTrace: stackTrace);
  }
}
