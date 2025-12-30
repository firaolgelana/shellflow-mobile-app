import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // 1. Add Bloc import
import 'package:shell_flow_mobile_app/core/routes/app_routes.dart';
import 'package:shell_flow_mobile_app/features/auth/presentation/bloc/auth_bloc.dart'; // 2. Add AuthBloc import
import 'package:shell_flow_mobile_app/injection_container.dart'; // 3. Add injection import

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 4. Initialize all dependencies (Supabase, Repositories, Usecases, Bloc)
  // This replaces the manual Supabase.initialize call
  await initDependencies();

  runApp(
    // 5. Wrap the app in MultiBlocProvider
    MultiBlocProvider(
      providers: [
        BlocProvider(
          // 6. Use 'sl' to get the AuthBloc from GetIt
          create: (_) => sl<AuthBloc>(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      // The initial route will now have access to AuthBloc
      initialRoute: AppRoutes.signIn, 
      onGenerateRoute: AppRoutes.generateRoute,
    );
  }
}