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

Widget _buildTaskTile(BuildContext context, CalendarTask task) {
    final isChecked = task.status == TaskStatus.completed;
    final isOverdue = task.status == TaskStatus.overdue;

    return ListTile(
      // Visual styling
      tileColor: isOverdue ? Colors.red.withOpacity(0.05) : null,
      title: Text(
        task.title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis, // Truncate title too if needed
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
          color: isChecked 
              ? Colors.grey 
              : (isOverdue ? Colors.red[900] : Colors.black),
          fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
        ),
      ),
      
      // --- TRUNCATE DESCRIPTION HERE ---
      subtitle: task.description.isNotEmpty
          ? Text(
              task.description,
              maxLines: 1, // Limit to 1 line
              overflow: TextOverflow.ellipsis, // Show "..."
              style: const TextStyle(color: Colors.grey),
            )
          : null,

      // Trailing logic
      trailing: isOverdue
          ? _buildOverdueIcon(context, task)
          : Checkbox(
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

      // --- ON TAP: Show Full Details (For ALL tasks) ---
      onTap: () {
        _showTaskDetailsBottomSheet(context, task);
      },
    );
  }

  // --- NEW DETAIL VIEW ---
  void _showTaskDetailsBottomSheet(BuildContext context, CalendarTask task) {
    final isOverdue = task.status == TaskStatus.overdue;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Shrink to fit content
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 22, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                  if (isOverdue)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red[100],
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        "OVERDUE",
                        style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Full Description
              const Text(
                "Description:",
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                task.description.isEmpty ? "No description provided." : task.description,
                style: const TextStyle(fontSize: 16, height: 1.5),
              ),
              
              const SizedBox(height: 24),
              
              // Actions
              if (isOverdue) ...[
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () {
                      Navigator.pop(ctx); // Close popup
                      // Mark as Completed
                      final updatedTask = task.copyWith(status: TaskStatus.completed);
                      context.read<CalendarBloc>().add(UpdateTaskEvent(updatedTask));
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Mark as Completed"),
                  ),
                ),
                const SizedBox(height: 8),
              ],
              
              // Close Button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("Close"),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}