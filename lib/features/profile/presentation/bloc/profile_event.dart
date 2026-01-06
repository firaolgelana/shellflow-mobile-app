part of 'profile_bloc.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class GetUserProfileEvent extends ProfileEvent {
  final UserProfile profile; // Contains the ID needed to fetch

  const GetUserProfileEvent({required this.profile});

  @override
  List<Object> get props => [profile];
}

class UpdateUserProfileEvent extends ProfileEvent {
  final UserProfile profile; // Contains the updated data

  const UpdateUserProfileEvent({required this.profile});

  @override
  List<Object> get props => [profile];
}