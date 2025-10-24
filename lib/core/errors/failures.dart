/// Base class for all application failures
abstract class Failure {
  final String message;
  final int? code;
  final dynamic error;

  const Failure({
    required this.message,
    this.code,
    this.error,
  });

  @override
  String toString() => 'Failure(message: $message, code: $code)';
}

/// Server-related failures
class ServerFailure extends Failure {
  const ServerFailure({
    required super.message,
    super.code,
    super.error,
  });

  factory ServerFailure.fromException(dynamic error) {
    if (error is ServerException) {
      return ServerFailure(
        message: error.message,
        code: error.statusCode,
        error: error,
      );
    }
    return const ServerFailure(
      message: 'An unexpected server error occurred',
    );
  }
}

/// Network-related failures
class NetworkFailure extends Failure {
  const NetworkFailure({
    required super.message,
    super.code,
    super.error,
  });

  factory NetworkFailure.noInternet() {
    return const NetworkFailure(
      message: 'No internet connection. Please check your network',
      code: -1,
    );
  }

  factory NetworkFailure.timeout() {
    return const NetworkFailure(
      message: 'Connection timeout. Please try again',
      code: -2,
    );
  }
}

/// Cache-related failures
class CacheFailure extends Failure {
  const CacheFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// Validation failures
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// Authentication failures
class AuthFailure extends Failure {
  const AuthFailure({
    required super.message,
    super.code,
    super.error,
  });

  factory AuthFailure.invalidCredentials() {
    return const AuthFailure(
      message: 'Invalid email or password',
      code: 401,
    );
  }

  factory AuthFailure.unauthorized() {
    return const AuthFailure(
      message: 'Session expired. Please login again',
      code: 401,
    );
  }

  factory AuthFailure.userNotFound() {
    return const AuthFailure(
      message: 'User not found',
      code: 404,
    );
  }
}

/// Permission failures
class PermissionFailure extends Failure {
  const PermissionFailure({
    required super.message,
    super.code,
    super.error,
  });
}

/// General application failure
class GeneralFailure extends Failure {
  const GeneralFailure({
    required super.message,
    super.code,
    super.error,
  });
}

// ==================== EXCEPTIONS ====================

/// Base exception class
abstract class AppException implements Exception {
  final String message;
  final int? statusCode;
  final dynamic error;

  const AppException({
    required this.message,
    this.statusCode,
    this.error,
  });

  @override
  String toString() =>
      'AppException(message: $message, statusCode: $statusCode)';
}

/// Server exception
class ServerException extends AppException {
  const ServerException({
    required super.message,
    super.statusCode,
    super.error,
  });

  factory ServerException.fromResponse(int statusCode, String? message) {
    switch (statusCode) {
      case 400:
        return ServerException(
          message: message ?? 'Bad request',
          statusCode: statusCode,
        );
      case 401:
        return ServerException(
          message: message ?? 'Unauthorized',
          statusCode: statusCode,
        );
      case 403:
        return ServerException(
          message: message ?? 'Forbidden',
          statusCode: statusCode,
        );
      case 404:
        return ServerException(
          message: message ?? 'Not found',
          statusCode: statusCode,
        );
      case 500:
        return ServerException(
          message: message ?? 'Internal server error',
          statusCode: statusCode,
        );
      case 503:
        return ServerException(
          message: message ?? 'Service unavailable',
          statusCode: statusCode,
        );
      default:
        return ServerException(
          message: message ?? 'An error occurred',
          statusCode: statusCode,
        );
    }
  }
}

/// Network exception
class NetworkException extends AppException {
  const NetworkException({
    required super.message,
    super.statusCode,
    super.error,
  });

  factory NetworkException.noInternet() {
    return const NetworkException(
      message: 'No internet connection',
      statusCode: -1,
    );
  }

  factory NetworkException.timeout() {
    return const NetworkException(
      message: 'Connection timeout',
      statusCode: -2,
    );
  }
}

/// Cache exception
class CacheException extends AppException {
  const CacheException({
    required super.message,
    super.statusCode,
    super.error,
  });
}

/// Validation exception
class ValidationException extends AppException {
  final Map<String, String>? errors;

  const ValidationException({
    required super.message,
    this.errors,
    super.statusCode,
    super.error,
  });
}

/// Auth exception
class AuthException extends AppException {
  const AuthException({
    required super.message,
    super.statusCode,
    super.error,
  });
}

/// Permission exception
class PermissionException extends AppException {
  const PermissionException({
    required super.message,
    super.statusCode,
    super.error,
  });
}
