import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/pages/otp_page.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/pages/all_tasks_page.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/pages/dashboard.dart';
import 'package:shell_flow_mobile_app/features/profile/presentation/pages/profile_page.dart';

class AppRoutes {
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const homePageRoutes = '/dashboard';
  static const profile = '/profile';
  static const otpPage = '/otp-page';
  static const allTaskPage = '/all-task-page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());

      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());

      case homePageRoutes:
        return MaterialPageRoute(builder: (_) => const Dashboard());

      case profile:
        return MaterialPageRoute(builder: (_) => const ProfilePage());

      case otpPage:
        final email = settings.arguments as String?;
        if (email == null) {
          throw Exception('Email is required for OTP page');
        }
        return MaterialPageRoute(builder: (_) => OtpPage(email: email));
      case allTaskPage:
        return MaterialPageRoute(builder: (_) => const AllTasksPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
