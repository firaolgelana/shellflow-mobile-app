part of 'social_bloc.dart';

sealed class SocialState extends Equatable {
  const SocialState();
  
  @override
  List<Object> get props => [];
}

final class SocialInitial extends SocialState {}
