import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/entities/user.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signin_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signin_with_google_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signout_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:shell_flow_mobile_app/features/auth/domain/usecases/get_current_user_usecase.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SigninUsecase _signinUsecase;
  final SignoutUsecase _signoutUsecase;
  final SignupUsecase _signupUsecase;
  final SigninWithGoogleUsecase _signinWithGoogleUsecase;
  final VerifyOtpUsecase _verifyOtpUsecase;
  final GetCurrentUserUsecase _getCurrentUserUsecase;

  AuthBloc({
    required SigninUsecase signinUsecase,
    required SignoutUsecase signoutUsecase,
    required SignupUsecase signupUsecase,
    required SigninWithGoogleUsecase signinWithGoogleUsecase,
    required VerifyOtpUsecase verifyOtpUsecase,
    required GetCurrentUserUsecase getCurrentUserUsecase,
  })  : _signinUsecase = signinUsecase,
        _signoutUsecase = signoutUsecase,
        _signupUsecase = signupUsecase,
        _signinWithGoogleUsecase = signinWithGoogleUsecase,
        _verifyOtpUsecase = verifyOtpUsecase,
        _getCurrentUserUsecase = getCurrentUserUsecase,
        super(InitialState()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignInWithEmailEvent>(_onSignInWithEmail);
    on<SignUpEvent>(_onSignUp);
    on<SignOutEvent>(_onSignOut);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<GetCurrentUserEvent>(_onGetCurrentUser);
    on<AppStartedEvent>(_onAppStarted);
  }

  void _onSignInWithGoogle(
    SignInWithGoogleEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await _signinWithGoogleUsecase();
      result.fold(
        (failure) => emit(AuthErrorState(message: failure.message)),
        (user) => emit(SignedInState(user: user)),
      );
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void _onSignInWithEmail(
    SignInWithEmailEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    final result = await _signinUsecase(email: event.email, password: event.password);
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) => emit(SignedInState(user: user)),
    );
  }

  void _onSignUp(SignUpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    final user = User(email: event.email, password: event.password, name: event.name);
    final result = await _signupUsecase(user);
    result.fold(
      (failure) => emit(AuthErrorState(message: failure.message)),
      (user) {
        // ✅ Check if verification is required
        if (!user.isEmailVerified) {
          emit(VerificationRequiredState(email: user.email??''));
        } else {
          emit(SignedInState(user: user));
        }
      },
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

  void _onVerifyOtp(VerifyOtpEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());
    try {
      final result =
          await _verifyOtpUsecase(email: event.email, otp: event.otp);
      result.fold(
        (failure) => emit(AuthErrorState(message: failure.message)),
        (user) => emit(SignedInState(user: user)),
      );
    } catch (e) {
      emit(AuthErrorState(message: e.toString()));
    }
  }

  void _onGetCurrentUser(
    GetCurrentUserEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoadingState());
    try {
      final result = await _getCurrentUserUsecase();
      result.fold(
        (failure) => emit(UnAuthenticatedState()),
        (user) => emit(AuthenticatedState(user)),
      );
    } catch (e) {
      emit(UnAuthenticatedState());
    }
  }

  void _onAppStarted(AppStartedEvent event, Emitter<AuthState> emit) async {
    emit(AuthLoadingState());

    final result = await _getCurrentUserUsecase();

    result.fold(
      (failure) {
        if (failure.message == "Verification Required") {
          emit(UnAuthenticatedState());
        } else {
          emit(UnAuthenticatedState());
        }
      },
      (user) => emit(AuthenticatedState(user)),
    );
  }
}
