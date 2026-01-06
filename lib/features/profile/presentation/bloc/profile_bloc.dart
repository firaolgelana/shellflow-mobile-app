import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/entities/user_profile.dart';
import 'package:shell_flow_mobile_app/features/profile/domain/usecases/get_profile_usecase.dart'; 
import 'package:shell_flow_mobile_app/features/profile/domain/usecases/update_profile_usecase.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUsecase getProfile;
  final UpdateProfileUsecase updateProfile;

  ProfileBloc({
    required this.getProfile,
    required this.updateProfile,
  }) : super(ProfileInitial()) {
    
    // Register Event Handlers
    on<GetUserProfileEvent>(_onGetProfile);
    on<UpdateUserProfileEvent>(_onUpdateProfile);
  }

  Future<void> _onGetProfile(
    GetUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());
    
    // Call the use case
    final result = await getProfile(event.profile);

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (profile) => emit(ProfileLoaded(profile: profile)),
    );
  }

  Future<void> _onUpdateProfile(
    UpdateUserProfileEvent event,
    Emitter<ProfileState> emit,
  ) async {
    emit(ProfileLoading());

    // Call the use case
    final result = await updateProfile(event.profile);

    result.fold(
      (failure) => emit(ProfileError(message: failure.message)),
      (updatedProfile) {
        // Emit loaded with the NEW data so the UI updates immediately
        emit(ProfileLoaded(profile: updatedProfile));
      },
    );
  }
}