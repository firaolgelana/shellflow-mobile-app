import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

// Entities
import 'package:shell_flow_mobile_app/features/settings/domain/entities/user_setting.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/account.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/notifications.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/preference.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/privacy.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/entities/security.dart';

// Use Cases (Matching your provided structure)
import 'package:shell_flow_mobile_app/features/settings/domain/usecases/get_setting_usecase.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/usecases/preference_usecase.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/usecases/notification_usecase.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/usecases/privacy_usecase.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/usecases/security_usecase.dart';
import 'package:shell_flow_mobile_app/features/settings/domain/usecases/account_usecase.dart';

part 'settings_event.dart';
part 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  final GetSettingUsecase getSettingUseCase;
  final PreferenceUsecase updatePreferenceUseCase;
  final NotificationUsecase updateNotificationUseCase;
  final PrivacyUsecase updatePrivacyUseCase;
  final SecurityUsecase updateSecurityUseCase;
  final AccountUsecase accountUseCase; // Assuming this handles Update/Delete

  SettingsBloc({
    required this.getSettingUseCase,
    required this.updatePreferenceUseCase,
    required this.updateNotificationUseCase,
    required this.updatePrivacyUseCase,
    required this.updateSecurityUseCase,
    required this.accountUseCase,
  }) : super(SettingsInitial()) {
    
    on<LoadSettingsEvent>(_onLoadSettings);
    on<UpdatePreferenceEvent>(_onUpdatePreference);
    on<UpdateNotificationEvent>(_onUpdateNotification);
    on<UpdatePrivacyEvent>(_onUpdatePrivacy);
    on<UpdateSecurityEvent>(_onUpdateSecurity);
    on<UpdateAccountEvent>(_onUpdateAccount);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

  // --- 1. Load All Settings ---
  Future<void> _onLoadSettings(
    LoadSettingsEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading());
    // Assuming GetSettingUseCase takes NoParams or UserId (handled in Repo)
    final result = await getSettingUseCase();
    
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (userSetting) => emit(SettingsLoaded(userSetting)),
    );
  }

  // --- 2. Update Preference (Theme/Lang) ---
  Future<void> _onUpdatePreference(
    UpdatePreferenceEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSetting = (state as SettingsLoaded).userSetting;
      
      // Optimistic Update: Update UI immediately
      final updatedUserSetting = currentSetting.copyWith(preference: event.preference);
      emit(SettingsLoaded(updatedUserSetting));

      final result = await updatePreferenceUseCase(event.preference);
      
      result.fold(
        (failure) {
           // Revert change on error
           emit(SettingsError(failure.message));
           add(LoadSettingsEvent()); // Reload actual data
        }, 
        (_) => null, // Success, do nothing as UI is already updated
      );
    }
  }

  // --- 3. Update Notifications ---
  Future<void> _onUpdateNotification(
    UpdateNotificationEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSetting = (state as SettingsLoaded).userSetting;
      
      // Optimistic Update
      final updatedUserSetting = currentSetting.copyWith(notifications: event.notificationSettings);
      emit(SettingsLoaded(updatedUserSetting));

      final result = await updateNotificationUseCase(event.notificationSettings);
      
      result.fold(
        (failure) {
           emit(SettingsError(failure.message));
           add(LoadSettingsEvent());
        }, 
        (_) => null,
      );
    }
  }

  // --- 4. Update Privacy ---
  Future<void> _onUpdatePrivacy(
    UpdatePrivacyEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSetting = (state as SettingsLoaded).userSetting;
      
      // Optimistic Update
      final updatedUserSetting = currentSetting.copyWith(privacy: event.privacy);
      emit(SettingsLoaded(updatedUserSetting));

      final result = await updatePrivacyUseCase(event.privacy);
      
      result.fold(
        (failure) {
           emit(SettingsError(failure.message));
           add(LoadSettingsEvent());
        }, 
        (_) => null,
      );
    }
  }

  // --- 5. Update Security ---
  Future<void> _onUpdateSecurity(
    UpdateSecurityEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      final currentSetting = (state as SettingsLoaded).userSetting;
      
      final updatedUserSetting = currentSetting.copyWith(security: event.security);
      emit(SettingsLoaded(updatedUserSetting));

      final result = await updateSecurityUseCase(event.security);
      
      result.fold(
        (failure) {
           emit(SettingsError(failure.message));
           add(LoadSettingsEvent());
        }, 
        (_) => null,
      );
    }
  }

  // --- 6. Update Account ---
  Future<void> _onUpdateAccount(
    UpdateAccountEvent event,
    Emitter<SettingsState> emit,
  ) async {
    if (state is SettingsLoaded) {
      // Note: For account updates (like email/plan), we might not want optimistic updates
      // if the server does validation. We can emit loading if needed.
      
      final result = await accountUseCase(); // Assuming method name
      
      result.fold(
        (failure) => emit(SettingsError(failure.message)),
        (updatedAccount) {
           // Update the state with the result from server
           final current = (state as SettingsLoaded).userSetting;
           emit(SettingsLoaded(current.copyWith(account: updatedAccount)));
        }, 
      );
    }
  }

  // --- 7. Delete Account ---
  Future<void> _onDeleteAccount(
    DeleteAccountEvent event,
    Emitter<SettingsState> emit,
  ) async {
    emit(SettingsLoading()); // Show spinner for critical action
    
    final result = await accountUseCase(); // Assuming method name
    
    result.fold(
      (failure) => emit(SettingsError(failure.message)),
      (_) => emit(AccountDeletedSuccess()), // Navigate to Login Screen
    );
  }
}