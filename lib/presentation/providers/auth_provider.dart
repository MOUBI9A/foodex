import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../core/utils/logger.dart';

final _logger = Logger('AuthProvider');

/// Authentication state
class AuthState {
  final UserEntity? user;
  final bool isLoading;
  final bool isAuthenticated;
  final String? error;

  const AuthState({
    this.user,
    this.isLoading = false,
    this.isAuthenticated = false,
    this.error,
  });

  AuthState copyWith({
    UserEntity? user,
    bool? isLoading,
    bool? isAuthenticated,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      error: error,
    );
  }
}

/// Auth provider
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _authRepository;

  AuthNotifier(this._authRepository) : super(const AuthState()) {
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    state = state.copyWith(isLoading: true);

    final isAuthenticated = await _authRepository.isAuthenticated();
    if (isAuthenticated) {
      final result = await _authRepository.getCurrentUser();
      result.fold(
        (failure) {
          _logger.error('Failed to get current user: ${failure.message}');
          state = state.copyWith(
            isLoading: false,
            isAuthenticated: false,
          );
        },
        (user) {
          state = state.copyWith(
            user: user,
            isLoading: false,
            isAuthenticated: user != null,
          );
        },
      );
    } else {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authRepository.signIn(
      email: email,
      password: password,
    );

    return result.fold(
      (failure) {
        _logger.error('Sign in failed: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (user) {
        _logger.info('Sign in successful for user: ${user.email}');
        state = state.copyWith(
          user: user,
          isLoading: false,
          isAuthenticated: true,
          error: null,
        );
        return true;
      },
    );
  }

  Future<bool> signUp({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authRepository.signUp(
      email: email,
      password: password,
      name: name,
      role: role,
    );

    return result.fold(
      (failure) {
        _logger.error('Sign up failed: ${failure.message}');
        state = state.copyWith(
          isLoading: false,
          error: failure.message,
        );
        return false;
      },
      (user) {
        _logger.info('Sign up successful for user: ${user.email}');
        state = state.copyWith(
          user: user,
          isLoading: false,
          isAuthenticated: true,
          error: null,
        );
        return true;
      },
    );
  }

  Future<void> signOut() async {
    state = state.copyWith(isLoading: true);

    final result = await _authRepository.signOut();

    result.fold(
      (failure) {
        _logger.error('Sign out failed: ${failure.message}');
        state = state.copyWith(isLoading: false);
      },
      (_) {
        _logger.info('Sign out successful');
        state = const AuthState();
      },
    );
  }

  Future<bool> sendOTP(String email) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authRepository.sendOTP(email: email);

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  Future<bool> verifyOTP({
    required String email,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authRepository.verifyOTP(
      email: email,
      code: code,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (isValid) {
        state = state.copyWith(isLoading: false);
        return isValid;
      },
    );
  }

  Future<bool> resetPassword({
    required String email,
    required String newPassword,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final result = await _authRepository.resetPassword(
      email: email,
      newPassword: newPassword,
      code: code,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (_) {
        state = state.copyWith(isLoading: false);
        return true;
      },
    );
  }

  Future<bool> updateProfile({
    String? name,
    String? phone,
    String? profileImage,
  }) async {
    if (state.user == null) return false;

    state = state.copyWith(isLoading: true, error: null);

    final result = await _authRepository.updateProfile(
      userId: state.user!.id,
      name: name,
      phone: phone,
      profileImage: profileImage,
    );

    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (updatedUser) {
        state = state.copyWith(
          user: updatedUser,
          isLoading: false,
        );
        return true;
      },
    );
  }
}

/// Provider for auth state
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  // This will be injected via dependency injection
  throw UnimplementedError('AuthRepository not provided');
});

/// Convenience providers
final currentUserProvider = Provider<UserEntity?>((ref) {
  return ref.watch(authProvider).user;
});

final isAuthenticatedProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isAuthenticated;
});

final isLoadingProvider = Provider<bool>((ref) {
  return ref.watch(authProvider).isLoading;
});
