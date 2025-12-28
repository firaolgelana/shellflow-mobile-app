import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/pages/sign_in_page.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/pages/sign_up_page.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/pages/home_page.dart';

class AppRoutes {
  static const signIn = '/sign-in';
  static const signUp = '/sign-up';
  static const homePageRoutes = '/home_page';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInPage());

      case signUp:
        return MaterialPageRoute(builder: (_) => const SignUpPage());
      case homePageRoutes:
        return MaterialPageRoute(builder: (_) => const HomePage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
