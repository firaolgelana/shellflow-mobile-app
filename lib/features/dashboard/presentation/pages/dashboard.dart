import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/pages/calendar_page.dart';
import 'package:shell_flow_mobile_app/features/chat/presentation/pages/chat_page.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/pages/home_page.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/nav_bar_widget.dart';
import 'package:shell_flow_mobile_app/features/social/presentation/pages/social_page.dart';
import 'package:shell_flow_mobile_app/injection_container.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: HomePage()),
    const Center(child: SocialPage()),
    const Center(child: ChatPage()),
    BlocProvider(
      create: (context) => sl<CalendarBloc>()..add(LoadAllTasksEvent()),
      child: const CalendarPage(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: navBarWidget(
        selectedIndex: _selectedIndex,
        onSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
      ),
    );
  }
}
