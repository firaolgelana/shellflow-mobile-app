import 'package:google_sign_in/google_sign_in.dart';
import 'package:shell_flow_mobile_app/core/constants/auth_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:shell_flow_mobile_app/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDatasource {
  Future<User> signUpUser(User user);
  Future<User> signInWithEmailPassword({required String email, required String password});
  Future<User> signInWithPhone();
  Future<User> signInWithGoogle();
  Future<User> signOut();
  Future<User> verifyOtp({required String email, required String otp});
  Future<User?> getCurrentUser();
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final supabase.SupabaseClient supabaseClient;

  const AuthRemoteDatasourceImpl({
    required this.supabaseClient,
  });

  @override
  Future<User> signInWithEmailPassword({
    required String email,
    required String password,
  }) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final supabaseUser = response.user;

      if (supabaseUser == null) {
        throw Exception('Sign in failed');
      }

      return User(
        id: supabaseUser.id,
        email: supabaseUser.email ?? '',
        isEmailVerified: supabaseUser.emailConfirmedAt != null,
      );
    } catch (e) {
      throw Exception('Sign in error: $e');
    }
  }


  @override
  Future<User> signUpUser(User user) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: user.email,
        password: user.password ?? '',
        data: {
          'full_name': user.name,
        },
      );

      if (response.user == null) {
        throw const supabase.AuthException(
          'Registration failed, user is null',
        );
      }

      return _mapSupabaseUser(response.user!);
    } on supabase.AuthException catch (e) {
      throw Exception(e.message);
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize(
        serverClientId: AuthConstants.googleClientId,
      );

      final GoogleSignInAccount googleUser =
          await GoogleSignIn.instance.authenticate();

      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      final scopes = ['email', 'profile'];
      final authorization =
          await googleUser.authorizationClient.authorizeScopes(scopes);
      final accessToken = authorization.accessToken;

      if (idToken == null) {
        throw 'Required tokens are missing.';
      }

      final response = await supabaseClient.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) {
        throw 'Supabase sign-in failed.';
      }

      return _mapSupabaseUser(response.user!);
    } catch (e) {
      throw Exception("Google Sign-in failed: $e");
    }
  }

  @override
  Future<User> signInWithPhone() {
    // TODO: implement signInWithPhone
    throw UnimplementedError();
  }

@override
Future<User> signOut() async {
  try {
    await supabaseClient.auth.signOut();
    return const User(
      id: '',
      email: '',
      isEmailVerified: false,
    );
  } catch (e) {
    throw Exception('Sign out failed: $e');
  }
}


  // ✅ FIXED
  @override
  Future<User> verifyOtp({
    required String email,
    required String otp,
  }) async {
    final response = await supabaseClient.auth.verifyOTP(
      email: email,
      token: otp,
      type: supabase.OtpType.email,
    );

    if (response.user == null) {
      throw Exception('OTP verification failed');
    }

    return _mapSupabaseUser(response.user!);
  }

  @override
  Future<User?> getCurrentUser() async {
    final user = supabaseClient.auth.currentUser;
    if (user == null) return null;
    return _mapSupabaseUser(user);
  }


  // Helper mapper
  User _mapSupabaseUser(supabase.User user) {
    return User(
      id: user.id,
      email: user.email ?? '',
      name: user.userMetadata?['full_name'] ?? '',
      isEmailVerified: user.emailConfirmedAt != null, // ✅ map email verification

    );
  }
}
