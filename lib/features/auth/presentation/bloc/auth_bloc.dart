import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/entities/user.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signout_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signup_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SigninUsecase _signinUsecase;
  final SignoutUsecase _signoutUsecase;
  final SignupUsecase _signupUsecase;
  final SigninWithGoogleUsecase _signinWithGoogleUsecase;

  AuthBloc({
    required SigninUsecase signinUsecase,
    required SignoutUsecase signoutUsecase,
    required SignupUsecase signupUsecase,
    required SigninWithGoogleUsecase signinWithGoogleUsecase,
  }) : _signinUsecase = signinUsecase,
       _signoutUsecase = signoutUsecase,
       _signupUsecase = signupUsecase,
       _signinWithGoogleUsecase = signinWithGoogleUsecase,
       super(InitialState()) {
    
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
  }

  
  void _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _signinWithGoogleUsecase(); 
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(SignedInState(user: user)), 
    );
  }

  
  void _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final user = User(email: event.email, password: event.password);
    final result = await _signinUsecase(user);
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(SignedInState(user: user)),
    );
  }

  
  void _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final user = User(email: event.email, password: event.password);
    final result = await _signupUsecase(user);
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(SignedInState(user: user)),
    );
  }

  
  void _onSignOut(SignOutEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final result = await _signoutUsecase();
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (_) => emit(InitialState()), 
    );
  }
}
