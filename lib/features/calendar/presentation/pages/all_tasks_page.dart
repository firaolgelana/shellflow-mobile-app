import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../injection_container.dart'; 
import 'package:shell_flow_mobile_app/features/calendar/presentation/bloc/calendar_bloc.dart';
import 'package:shell_flow_mobile_app/features/calendar/domain/entities/calendar_task.dart';

class AllTasksPage extends StatelessWidget {
  const AllTasksPage({super.key});

  @override
  Widget build(BuildContext context) {

    return BlocProvider(
      // Fetch tasks when page loads
      create: (context) => sl<CalendarBloc>()..add(LoadAllTasksEvent()),
      child: Scaffold(
        appBar: AppBar(title: const Text('All Tasks')),
        body: BlocBuilder<CalendarBloc, CalendarState>(
          builder: (context, state) {
            
            // Handle Loading
            if (state is CalendarLoading) {
              return const Center(child: CircularProgressIndicator());
            } 
            
            // Handle Error
            else if (state is CalendarError) {
              return Center(child: Text('Error: ${state.message}'));
            } 
            
            // Handle Loaded Data
            else if (state is CalendarLoaded) {
              final tasks = state.tasks;
              
              if (tasks.isEmpty) {
                return const Center(child: Text("No tasks found."));
              }

              return ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: tasks.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final task = tasks[index];
                  return _buildTaskTile(context, task);
                },
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

Widget _buildTaskTile(BuildContext context, CalendarTask task) {
    // 1. Determine states
    final isChecked = task.status == TaskStatus.completed;
    final isOverdue = task.status == TaskStatus.overdue;

    return ListTile(
      // Change background color if overdue to alert user
      tileColor: isOverdue ? Colors.red : null, 
      
      title: Text(
        task.title,
        style: TextStyle(
          // Strike through if completed, normal if overdue
          decoration: isChecked ? TextDecoration.lineThrough : null,
          // Grey if completed, Red-ish if overdue, Black otherwise
          color: isChecked 
              ? Colors.grey 
              : (isOverdue ? Colors.red[900] : Colors.black),
          fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      subtitle: Text(task.description),
      
      // 2. LOGIC: Checkbox vs Icon
      trailing: isOverdue
          ? _buildOverdueIcon(context, task) // Show Icon
          : Checkbox(                        // Show Checkbox
              value: isChecked,
              activeColor: Colors.green,
              onChanged: (bool? value) {
                if (value != null) {
                  final newStatus = value ? TaskStatus.completed : TaskStatus.pending;
                  final updatedTask = task.copyWith(status: newStatus);
                  context.read<CalendarBloc>().add(UpdateTaskEvent(updatedTask));
                }
              },
            ),
            
      // Optional: Allow tapping the tile to resolve overdue status manually?
      onTap: isOverdue 
        ? () {
            // Logic to handle overdue task click (e.g., show dialog to reschedule or complete)
            _showOverdueOptions(context, task);
          } 
        : null,
    );
  }

  // Helper widget for the Overdue Icon
  Widget _buildOverdueIcon(BuildContext context, CalendarTask task) {
    return const Tooltip(
      message: "This task is Overdue!",
      child: Icon(
        Icons.warning_rounded, // or Icons.error_outline
        color: Colors.red,
        size: 28,
      ),
    );
  }

  // Optional: A helper to handle what happens when you click an overdue task
  void _showOverdueOptions(BuildContext context, CalendarTask task) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Overdue Task"),
        content: Text("What do you want to do with '${task.title}'?"),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              // Mark as Completed
              final updatedTask = task.copyWith(status: TaskStatus.completed);
              context.read<CalendarBloc>().add(UpdateTaskEvent(updatedTask));
            },
            child: const Text("Mark Completed"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}