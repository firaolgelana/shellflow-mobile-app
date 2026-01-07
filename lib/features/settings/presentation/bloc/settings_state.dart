part of 'settings_bloc.dart';

abstract class SettingsState extends Equatable {
  const SettingsState();
  
  @override
  List<Object?> get props => [];
}

class SettingsInitial extends SettingsState {}

class SettingsLoading extends SettingsState {}

class SettingsLoaded extends SettingsState {
  final UserSetting userSetting;

  const SettingsLoaded(this.userSetting);

  @override
  List<Object?> get props => [userSetting];
}

class SettingsError extends SettingsState {
  final String message;

  const SettingsError(this.message);

  @override
  List<Object?> get props => [message];
}

/// Optional: Emitted when account is successfully deleted
class AccountDeletedSuccess extends SettingsState {}