import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/drawer_widget.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/home_container.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/nav_bar_widget.dart';
class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const Center(child: HomeContainer()),
    const Center(child: Text('User Page')),
    const Center(child: Text('Chat Page')),
    const Center(child: Text('Calender Page')),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: drawerWidget()
      ),
      appBar: AppBar(
        title: const Text('ShellFlow'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.black,
        actions: [
          IconButton(onPressed: (){}, icon: const Icon(Icons.notification_add_outlined)),
          IconButton(onPressed: (){}, icon: const Icon(Icons.search))
        ],
        
      ),

      // 👇 Page content changes based on selected tab
      body: _pages[_selectedIndex],

      // 👇 Modern bottom navigation
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
