import 'package:dartz/dartz.dart';
import '../../core/errors/failures.dart';
import '../entities/user_entity.dart';

abstract class AuthRepository {
  /// Sign in with email and password
  Future<Either<Failure, UserEntity>> signIn({
    required String email,
    required String password,
  });

  /// Sign up with email, password and name
  Future<Either<Failure, UserEntity>> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  });

  /// Sign out current user
  Future<Either<Failure, void>> signOut();

  /// Get current user
  Future<Either<Failure, UserEntity?>> getCurrentUser();

  /// Send OTP for verification
  Future<Either<Failure, void>> sendOTP({
    required String email,
  });

  /// Verify OTP
  Future<Either<Failure, bool>> verifyOTP({
    required String email,
    required String code,
  });

  /// Reset password
  Future<Either<Failure, void>> resetPassword({
    required String email,
    required String newPassword,
    required String code,
  });

  /// Update user profile
  Future<Either<Failure, UserEntity>> updateProfile({
    required String userId,
    String? name,
    String? phone,
    String? profileImage,
  });

  /// Change password
  Future<Either<Failure, void>> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });

  /// Check if user is authenticated
  Future<bool> isAuthenticated();

  /// Get stored auth token
  Future<String?> getAuthToken();

  /// Save auth token
  Future<void> saveAuthToken(String token);

  /// Clear auth token
  Future<void> clearAuthToken();
}
