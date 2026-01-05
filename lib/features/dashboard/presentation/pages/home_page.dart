import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shell_flow_mobile_app/injection_container.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:shell_flow_mobile_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/all_tasks.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/day_tasks.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/drawer_widget.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/quick_actions.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    // We provide the Bloc here so it's available to the subtree
    return BlocProvider(
      create: (context) {
        final userId = Supabase.instance.client.auth.currentUser?.id;
        // Trigger the fetch immediately upon creation
        return sl<DashboardBloc>()..add(FetchDashboardData(userId ?? ''));
      },
      child: Scaffold(
        // Pass context to drawer to access Bloc if needed (e.g. for Logout)
        drawer: Drawer(child: drawerWidget(context)), 
        
        appBar: AppBar(
          title: const Text('ShellFlow'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          actions: [
            // Notification Icon with Badge
            BlocBuilder<DashboardBloc, DashboardState>(
              builder: (context, state) {
                int count = 0;
                if (state is DashboardLoaded) {
                  count = state.data.unreadNotificationCount;
                }
                return Stack(
                  children: [
                    IconButton(
                      onPressed: () {}, 
                      icon: const Icon(Icons.notifications_outlined),
                    ),
                    if (count > 0)
                      Positioned(
                        right: 8,
                        top: 8,
                        child: CircleAvatar(
                          radius: 8,
                          backgroundColor: Colors.red,
                          child: Text(
                            '$count',
                            style: const TextStyle(fontSize: 10, color: Colors.white),
                          ),
                        ),
                      )
                  ],
                );
              },
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.search))
          ],
        ),
        
        // Main Body with State Management
        body: BlocBuilder<DashboardBloc, DashboardState>(
          builder: (context, state) {
            if (state is DashboardLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is DashboardFailure) {
              return Center(child: Text('Error: ${state.message}'));
            } else if (state is DashboardLoaded) {
              final data = state.data;
              
              return SingleChildScrollView(
                child: Column(
                  // Use specific Spacing or SizedBox, 'spacing' property is for Wrap/Flex in newer Flutter
                  children: [
                    const SizedBox(height: 10),
                    
                    const Text(
                      'Quick Actions',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                    const SizedBox(height: 10),
                    
                    quickActions(),
                    
                    const SizedBox(height: 20),
                    const Text(
                      "Here's what's happening with your tasks today.",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    ),
                    
                    // PASS DATA: Daily Stats
                    dayTaskSummaryGrid(data.todayStats),
                    
                    const SizedBox(height: 20),
                    const Text(
                      'All Tasks Info',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    
                    // PASS DATA: Overall Stats
                    allTaskSummaryGrid(data.overallStats),
                    
                    const SizedBox(height: 20),
                  ],
                ),
              );
            }
            return const SizedBox.shrink(); // Initial state
          },
        ),
      ),
    );
  }
}