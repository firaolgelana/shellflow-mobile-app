import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shell_flow_mobile_app/core/network/network_info.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shell_flow_mobile_app/core/constants/auth_constants.dart';
import 'package:shell_flow_mobile_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signout_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

// sl stands for Service Locator
final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Initialize External (Supabase)
  final supabase = await Supabase.initialize(
    url: AuthConstants.supabaseUrl,
    anonKey: AuthConstants.supabaseAnonKey,
  );

  // Register Supabase Client as a singleton so it can be used everywhere
  sl.registerLazySingleton(() => supabase.client);

  // 2. Register Auth Feature
  _initAuth();
}

void _initAuth() {
  // --- Data Layer ---
  
  // Datasource: Needs SupabaseClient
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(supabaseClient: sl()),
  );

  // Repository: Needs Datasource
  // Note: We register the implementation against the abstract class
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );

    // ADD THESE TWO LINES HERE:
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));


  // --- Domain Layer (Usecases) ---
  // Each usecase needs the Repository
  sl.registerLazySingleton(() => SigninUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignupUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignoutUsecase(repository: sl()));
  sl.registerLazySingleton(() => SigninWithGoogleUsecase(repository: sl()));

  // --- Presentation Layer (Bloc) ---
  // Bloc needs all the usecases
  // We use registerFactory because Blocs should usually be closed/recreated
  sl.registerFactory(
    () => AuthBloc(
      signinUsecase: sl(),
      signupUsecase: sl(),
      signoutUsecase: sl(),
      signinWithGoogleUsecase: sl(),
    ),
  );
}