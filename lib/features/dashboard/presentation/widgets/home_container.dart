import 'package:flutter/material.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/all_tasks.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/day_tasks.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/widgets/quick_actions.dart';

class HomeContainer extends StatefulWidget {
  const HomeContainer({super.key});

  @override
  State<HomeContainer> createState() => _HomeContainerState();
}

class _HomeContainerState extends State<HomeContainer> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        spacing: 10,
        children: [
        const SizedBox(height: 4,),
        const Text('Quick Actions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),),
        quickActions(),
        const Text("Here's what's happening with your tasks today.",
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),),
        dayTaskSummaryGrid(),
        const Text('All Tasks Info'),
        allTaskSummaryGrid()
      ],),
    );
  }
}