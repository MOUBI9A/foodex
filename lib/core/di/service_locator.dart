import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Core
import '../network/api_client.dart';
import '../utils/logger.dart';

// Data sources (to be implemented)
// import '../data/datasources/auth_remote_datasource.dart';
// import '../data/datasources/auth_local_datasource.dart';
// import '../data/datasources/restaurant_remote_datasource.dart';
// import '../data/datasources/order_remote_datasource.dart';

// Repositories (to be implemented)
// import '../data/repositories/auth_repository_impl.dart';
// import '../data/repositories/restaurant_repository_impl.dart';
// import '../data/repositories/order_repository_impl.dart';

// Domain repositories
// import '../domain/repositories/auth_repository.dart';
// import '../domain/repositories/restaurant_repository.dart';
// import '../domain/repositories/order_repository.dart';

final serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  final logger = Logger('ServiceLocator');
  logger.info('Initializing dependency injection...');

  // ============================================================================
  // External Dependencies
  // ============================================================================

  // Shared Preferences
  final sharedPreferences = await SharedPreferences.getInstance();
  serviceLocator.registerLazySingleton<SharedPreferences>(
    () => sharedPreferences,
  );

  // HTTP Client
  serviceLocator.registerLazySingleton<http.Client>(
    () => http.Client(),
  );

  // ============================================================================
  // Core
  // ============================================================================

  // Logger
  serviceLocator.registerLazySingleton<Logger>(
    () => Logger('App'),
  );

  // API Client
  serviceLocator.registerLazySingleton<ApiClient>(
    () => ApiClient(
      client: serviceLocator<http.Client>(),
    ),
  ); // ============================================================================
  // Data Sources
  // ============================================================================

  // TODO: Register data sources when implemented
  // Auth Data Sources
  // serviceLocator.registerLazySingleton<AuthRemoteDataSource>(
  //   () => AuthRemoteDataSourceImpl(apiClient: serviceLocator()),
  // );

  // serviceLocator.registerLazySingleton<AuthLocalDataSource>(
  //   () => AuthLocalDataSourceImpl(sharedPreferences: serviceLocator()),
  // );

  // Restaurant Data Sources
  // serviceLocator.registerLazySingleton<RestaurantRemoteDataSource>(
  //   () => RestaurantRemoteDataSourceImpl(apiClient: serviceLocator()),
  // );

  // Order Data Sources
  // serviceLocator.registerLazySingleton<OrderRemoteDataSource>(
  //   () => OrderRemoteDataSourceImpl(apiClient: serviceLocator()),
  // );

  // ============================================================================
  // Repositories
  // ============================================================================

  // TODO: Register repositories when implemented
  // serviceLocator.registerLazySingleton<AuthRepository>(
  //   () => AuthRepositoryImpl(
  //     remoteDataSource: serviceLocator(),
  //     localDataSource: serviceLocator(),
  //   ),
  // );

  // serviceLocator.registerLazySingleton<RestaurantRepository>(
  //   () => RestaurantRepositoryImpl(
  //     remoteDataSource: serviceLocator(),
  //   ),
  // );

  // serviceLocator.registerLazySingleton<OrderRepository>(
  //   () => OrderRepositoryImpl(
  //     remoteDataSource: serviceLocator(),
  //   ),
  // );

  // ============================================================================
  // Use Cases (if using use case pattern)
  // ============================================================================

  // TODO: Register use cases
  // serviceLocator.registerLazySingleton(() => SignInUseCase(serviceLocator()));
  // serviceLocator.registerLazySingleton(() => SignUpUseCase(serviceLocator()));
  // serviceLocator.registerLazySingleton(() => GetRestaurantsUseCase(serviceLocator()));
  // serviceLocator.registerLazySingleton(() => CreateOrderUseCase(serviceLocator()));

  logger.info('✅ Dependency injection setup complete');
}

/// Helper function to reset service locator (useful for testing)
Future<void> resetServiceLocator() async {
  await serviceLocator.reset();
}
