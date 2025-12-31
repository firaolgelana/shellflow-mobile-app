import 'package:flutter/material.dart';
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
    return Scaffold(
          drawer: Drawer(
          child: drawerWidget(context)
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
      body: SingleChildScrollView(
        child: Column(
          spacing: 10,
          children: [
          const SizedBox(height: 4,),
          const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),),
          quickActions(),
          const Text("Here's what's happening with your tasks today.",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
          dayTaskSummaryGrid(),
          const Text('All Tasks Info', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),),
          allTaskSummaryGrid()
        ],),
      ),
    );
  }
}