import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Core
import 'package:shell_flow_mobile_app/core/constants/auth_constants.dart';
import 'package:shell_flow_mobile_app/core/network/network_info.dart';

// Auth Feature Imports
import 'package:shell_flow_mobile_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/get_current_user_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signout_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/bloc/auth_bloc.dart';

// --- CALENDAR FEATURE IMPORTS ---
import 'package:shell_flow_mobile_app/features/calendar/data/datasources/calendar_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/create_task_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/delete_task_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/get_all_tasks_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/get_tasks_by_range_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/usecases/update_task_usecase.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/bloc/calendar_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // 1. Initialize External (Supabase)
  final supabase = await Supabase.initialize(
    url: AuthConstants.supabaseUrl,
    anonKey: AuthConstants.supabaseAnonKey,
  );

  sl.registerLazySingleton(() => supabase.client);

  // Core Network Info
  sl.registerLazySingleton(() => InternetConnectionChecker.instance);
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // 2. Register Features
  _initAuth();
  _initCalendar(); // <--- ADD THIS
}

void _initAuth() {
  // Datasource
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDatasource: sl(),
      networkInfo: sl(),
    ),
  );

  // Usecases
  sl.registerLazySingleton(() => SigninUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignupUsecase(repository: sl()));
  sl.registerLazySingleton(() => SignoutUsecase(repository: sl()));
  sl.registerLazySingleton(() => SigninWithGoogleUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetCurrentUserUsecase(repository: sl()));
  sl.registerLazySingleton(() => VerifyOtpUsecase(repository: sl()));

  // Bloc
  sl.registerFactory(
    () => AuthBloc(
      signinUsecase: sl(),
      signupUsecase: sl(),
      signoutUsecase: sl(),
      signinWithGoogleUsecase: sl(),
      verifyOtpUsecase: sl(),
      getCurrentUserUsecase: sl(),
    ),
  );
}

// -----------------------------------------------------------------------------
// CALENDAR DEPENDENCY REGISTRATION
// -----------------------------------------------------------------------------
void _initCalendar() {
  // 1. Data Layer
  // Register the Datasource (Implementation)
  sl.registerLazySingleton<CalendarRemoteDatasource>(
    () => CalendarRemoteDatasourceImpl(sl()), // Injects SupabaseClient
  );

  // Register the Repository (Implementation)
  sl.registerLazySingleton<CalendarRepository>(
    () => CalendarRepositoryImpl(
      remoteDatasource: sl(), // Injects CalendarRemoteDatasource
      networkInfo: sl(),      // Injects NetworkInfo
    ),
  );

  // 2. Domain Layer (Use Cases)
  sl.registerLazySingleton(() => CreateTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetTasksByRangeUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetAllTasksUsecase(repository: sl())); // Included since Bloc needs it

  // 3. Presentation Layer (Bloc)
  // Use registerFactory so a new Bloc is created every time the page opens
  sl.registerFactory(
    () => CalendarBloc(
      createTask: sl(),
      updateTask: sl(),
      deleteTask: sl(),
      getTasksByRange: sl(),
      getAllTasks: sl(),
    ),
  );
}