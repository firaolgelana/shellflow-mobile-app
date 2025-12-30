import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/core/constants/auth_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; 
import 'package:shell_flow_mobile_app/core/routes/app_routes.dart';


Future<void> main() async {
  
  WidgetsFlutterBinding.ensureInitialized();

  
  await Supabase.initialize(
    url: AuthConstants.supabaseUrl,
    anonKey: AuthConstants.supabaseAnonKey,              
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: AppRoutes.signIn,
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}