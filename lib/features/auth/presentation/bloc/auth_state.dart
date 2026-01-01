part of 'auth_bloc.dart';

// 1. Extend Equatable
abstract class AuthState extends Equatable {
  @override
  List<Object?> get props => [];
}

class InitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthErrorState extends AuthState {
  final String message;
  AuthErrorState({required this.message});

  @override
  List<Object?> get props => [message];
}
class VerificationRequiredState extends AuthState {
  final String email;
  VerificationRequiredState({required this.email});
}


class SignedOutState extends AuthState {}

class SignedInState extends AuthState {
  final User user;
  SignedInState({required this.user});

  @override
  List<Object?> get props => [user];
}

// If user object is the same, this won't trigger a rebuild
class AuthenticatedState extends AuthState {
  final User user;
  AuthenticatedState(this.user);

  @override
  List<Object?> get props => [user];
}

class UnAuthenticatedState extends AuthState {}