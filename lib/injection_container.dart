import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shell_flow_mobile_app/features/dashboard/data/datasources/dashboard_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/dashboard/data/repositories/dashboard_repository_impl.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/repositories/dashboard_repository.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_daily_task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_dashboard_summary.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_recent_social_activities.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_task_statics.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_unread_notification_count.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/usecases/get_weekly_progress_usecase.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:shell_flow_mobile_app/features/profile/data/datasources/profile_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/repositories/profile_repository.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/usecases/get_profile_usecase.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/usecases/update_profile_usecase.dart';
import 'package:shell_flow_mobile_app/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:shell_flow_mobile_app/features/social/data/datasources/social_remote_datasource.dart';
import 'package:shell_flow_mobile_app/features/social/data/repositories/social_repository_impl.dart';
import 'package:shell_flow_mobile_app/features/social/domain/repositories/social_repository.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/add_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/delete_comment.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_friends_list.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_pending_requests.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_shared_task_details.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_social_feed.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_social_user_profile.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/get_task_comments.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/handle_connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/remove_friend.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/search_users.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/send_connection_request.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/share_task_to_feed.dart';
import 'package:shell_flow_mobile_app/features/social/domain/usecases/toggle_like_task.dart';
import 'package:shell_flow_mobile_app/features/social/presentation/bloc/social_bloc.dart';
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
  _initCalendar();
  _initSocial();
  _initProfile();
  _initDashboard();
}

void _initAuth() {
  // Datasource
  sl.registerLazySingleton<AuthRemoteDatasource>(
    () => AuthRemoteDatasourceImpl(supabaseClient: sl()),
  );

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(remoteDatasource: sl(), networkInfo: sl()),
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

//dashboard
void _initDashboard() {
  // Datasource
  sl.registerLazySingleton<DashboardRemoteDatasource>(
    () => DashboardRemoteDatasourceImpl(supabase: sl()),
  );

  // Repository
  sl.registerLazySingleton<DashboardRepository>(
    () => DashboardRepositoryImpl(remoteDatasource: sl(), networkInfo: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetDailyTaskStatics(repository: sl()));
  sl.registerLazySingleton(() => GetDashboardSummary(repository: sl()));
  sl.registerLazySingleton(() => GetRecentSocialActivities(repository: sl()));
  sl.registerLazySingleton(() => GetTaskStatics(repository: sl()));
  sl.registerLazySingleton(() => GetUnreadNotificationCount(repository: sl()));
  sl.registerLazySingleton(() => GetWeeklyProgressUsecase(repository: sl()));

  // Bloc
  sl.registerFactory(
    () => DashboardBloc(
      getDashboardSummary: sl(),
      getUnreadNotificationCount: sl(),
      getDailyTaskStatistics: sl(),
      getTaskStatistics: sl(),
      getRecentSocialActivities: sl(),
      getWeeklyProgress: sl(),
    ),
  );
}
//profile

void _initProfile() {
  // Datasource
  sl.registerLazySingleton<ProfileRemoteDatasource>(
    () => ProfileRemoteDatasourceImpl(supabase: sl()),
  );

  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(remoteDatasource: sl(), networkInfo: sl()),
  );

  // Usecases
  sl.registerLazySingleton(() => GetProfileUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateProfileUsecase(repository: sl()));
  // Bloc
  sl.registerFactory(() => ProfileBloc(getProfile: sl(), updateProfile: sl()));
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
      networkInfo: sl(), // Injects NetworkInfo
    ),
  );

  // 2. Domain Layer (Use Cases)
  sl.registerLazySingleton(() => CreateTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => UpdateTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => DeleteTaskUsecase(repository: sl()));
  sl.registerLazySingleton(() => GetTasksByRangeUsecase(repository: sl()));
  sl.registerLazySingleton(
    () => GetAllTasksUsecase(repository: sl()),
  ); // Included since Bloc needs it

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

//social dependency injection

void _initSocial() {
  // 1. Data Layer
  // Register the Datasource (Implementation)
  sl.registerLazySingleton<SocialRemoteDatasource>(
    () => SocialRemoteDatasourceImpl(supabase: sl()), // Injects SupabaseClient
  );

  // Register the Repository (Implementation)
  sl.registerLazySingleton<SocialRepository>(
    () => SocialRepositoryImpl(
      remoteDatasource: sl(), // Injects CalendarRemoteDatasource
      networkInfo: sl(), // Injects NetworkInfo
    ),
  );

  // 2. Domain Layer (Use Cases)
  sl.registerLazySingleton(() => AddComment(repository: sl()));
  sl.registerLazySingleton(() => DeleteComment(repository: sl()));
  sl.registerLazySingleton(() => GetFriendsList(repository: sl()));
  sl.registerLazySingleton(() => GetPendingRequests(repository: sl()));
  sl.registerLazySingleton(() => GetSharedTaskDetails(repository: sl()));
  sl.registerLazySingleton(() => GetSocialFeed(repository: sl()));
  sl.registerLazySingleton(() => GetSocialUserProfile(repository: sl()));
  sl.registerLazySingleton(() => GetTaskComments(repository: sl()));
  sl.registerLazySingleton(() => HandleConnectionRequest(repository: sl()));
  sl.registerLazySingleton(() => RemoveFriend(repository: sl()));
  sl.registerLazySingleton(() => SearchUsers(repository: sl()));
  sl.registerLazySingleton(() => SendConnectionRequest(repository: sl()));
  sl.registerLazySingleton(() => ShareTaskToFeed(repository: sl()));
  sl.registerLazySingleton(() => ToggleLikeTask(repository: sl()));

  // 3. Presentation Layer (Bloc)
  // Use registerFactory so a new Bloc is created every time the page opens
  sl.registerFactory(
    () => SocialBloc(
      addComment: sl(),
      deleteComment: sl(),
      getFriendsList: sl(),
      getPendingRequests: sl(),
      getSharedTaskDetails: sl(),
      getSocialFeed: sl(),
      getSocialUserProfile: sl(),
      getTaskComments: sl(),
      handleConnectionRequest: sl(),
      removeFriend: sl(),
      searchUsers: sl(),
      sendConnectionRequest: sl(),
      shareTaskToFeed: sl(),
      toggleLikeTask: sl(),
    ),
  );
}
