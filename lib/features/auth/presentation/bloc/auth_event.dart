part of 'auth_bloc.dart';

// 1. Extend Equatable
sealed class AuthEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class AppStartedEvent extends AuthEvent {}

class SignInWithEmailEvent extends AuthEvent {
  final String email;
  final String password;

  SignInWithEmailEvent({required this.email, required this.password});

  // 2. Add props for comparison
  @override
  List<Object?> get props => [email, password];
}

class SignUpEvent extends AuthEvent {
  final String name;
  final String email;
  final String password;

  SignUpEvent({
    required this.name,
    required this.email,
    required this.password,
  });

  @override
  List<Object?> get props => [name, email, password];
}

class SignInWithGoogleEvent extends AuthEvent {}

class SignOutEvent extends AuthEvent {}

class GetUserEvent extends AuthEvent {}