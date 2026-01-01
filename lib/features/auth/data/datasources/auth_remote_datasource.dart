import 'package:google_sign_in/google_sign_in.dart';
import 'package:shell_flow_mobile_app/core/constants/auth_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import 'package:shell_flow_mobile_app/features/auth/domain/entities/user.dart';

abstract class AuthRemoteDatasource {
  Future<User> signUpUser(User user);
  Future<User> signInUser(User user);
  Future<User> signInWithPhone();
  Future<User> signInWithGoogle();
  Future<User> signOut();
  Future<User> verifyOTP({required String email, required String token});
}

class AuthRemoteDatasourceImpl implements AuthRemoteDatasource {
  final supabase.SupabaseClient supabaseClient;
  const AuthRemoteDatasourceImpl({required this.supabaseClient});
  @override
  Future<User> signInUser(User user) {
    // TODO: implement signInUser
    throw UnimplementedError();
  }

  @override
  Future<User> signUpUser(User user) async {
    try {
      // 1. Supabase Auth Sign Up
      final response = await supabaseClient.auth.signUp(
        email: user.email,
        password:
            user.password ?? '', // Assumes password is in your User entity
        data: {
          'full_name': user.name, // Storing name in metadata
        },
      );

      if (response.user == null) {
        throw const supabase.AuthException('Registration failed, user is null');
      }

      // 2. Map the Supabase response back to your User entity
      return _mapSupabaseUser(response.user!);
    } on supabase.AuthException catch (e) {
      // Handle Supabase specific errors (e.g., user already exists)
      throw Exception(e.message);
    } catch (e) {
      throw Exception("An unexpected error occurred: $e");
    }
  }

  @override
  Future<User> signInWithGoogle() async {
    try {
      // 1. Initialize (Required in v7+)
      // Use your Web Client ID from Google Cloud Console as serverClientId
      await GoogleSignIn.instance.initialize(
        serverClientId: AuthConstants.googleClientId,
      );

      // 2. Step 1: Authentication (Identity)
      // This triggers the native account selector
      final GoogleSignInAccount googleUser = await GoogleSignIn.instance
          .authenticate();

      // 3. Step 2: Obtain ID Token (Identity)
      final googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;

      // 4. Step 3: Obtain Access Token (Authorization)
      // Access tokens are now handled by the authorizationClient in v7+
      final scopes = ['email', 'profile'];
      final authorization = await googleUser.authorizationClient
          .authorizeScopes(scopes);
      final accessToken = authorization.accessToken;

      if (idToken == null) {
        throw 'Required tokens (ID or Access) are missing.';
      }

      // 5. Connect to Supabase
      final response = await supabaseClient.auth.signInWithIdToken(
        provider: supabase.OAuthProvider.google,
        idToken: idToken,
        accessToken: accessToken,
      );

      if (response.user == null) throw 'Supabase sign-in failed.';

      return _mapSupabaseUser(response.user!);
    } catch (e) {
      throw Exception("Google Sign-in failed: $e");
    }
  }

  // Helper method to convert Supabase User to your Entity
  User _mapSupabaseUser(supabase.User user) {
    return User(
      id: user.id,
      email: user.email ?? '',
      // Supabase automatically gets the name from Google and puts it in metadata
      name: user.userMetadata?['full_name'] ?? '',
    );
  }

  @override
  Future<User> signInWithPhone() {
    // TODO: implement signInWithPhone
    throw UnimplementedError();
  }

  @override
  Future<User> signOut() {
    // TODO: implement signOut
    throw UnimplementedError();
  }

  @override
  Future<User> verifyOTP({required String email, required String token}) async {
    final response = await supabaseClient.auth.verifyOTP(
      email: email,
      token: token,
      type: supabase.OtpType.signup,
    );
    if (response.user == null) throw Exception("Verification failed");
    return _mapSupabaseUser(response.user!);
  }
}
