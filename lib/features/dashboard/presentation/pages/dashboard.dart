import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/calendar/presentation/pages/calendar_page.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/pages/home_page.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/nav_bar_widget.dart';
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: HomePage()),
    const Center(child: Text('User Page')),
    const Center(child: Text('Chat Page')),
    const Center(child: CalendarPage()),
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
