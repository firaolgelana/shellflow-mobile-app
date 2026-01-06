import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:shell_flow_mobile_app/features/dashboard/domain/entities/upcoming_task.dart';
import 'package:shell_flow_mobile_app/features/dashboard/presentation/bloc/dashboard_bloc.dart';

Widget upcomingTasksList(BuildContext context, List<UpcomingTask> tasks) { 
  
  if (tasks.isEmpty) {
    return const Card(
      elevation: 0, 
      color: Color(0xFFF5F5F5),
      child: Padding(
        padding: EdgeInsets.all(16.0),
        child: Center(
          child: Text(
            "No upcoming tasks! Enjoy your day.",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      ),
    );
  }

  return ListView.separated(
    // 1. DISABLE internal scrolling
    physics: const NeverScrollableScrollPhysics(),
    // 2. Shrink to fit the items
    shrinkWrap: true,
    padding: EdgeInsets.zero,
    // Safety check: limit to 5
    itemCount: tasks.length > 5 ? 5 : tasks.length, 
    separatorBuilder: (context, index) => const Divider(height: 1, indent: 16, endIndent: 16),
    itemBuilder: (context, index) {
      final task = tasks[index];
      
      // FIXED: Use 'status', not 'stats'
      final isCompleted = task.status == 'completed';

      return ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
        leading: CircleAvatar(
          backgroundColor: Colors.blue.withOpacity(0.1),
          radius: 20,
          child: const Icon(Icons.access_time, color: Colors.blue, size: 20),
        ),
        title: Text(
          task.title, 
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration: isCompleted ? TextDecoration.lineThrough : null,
            color: isCompleted ? Colors.grey : Colors.black,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // Uncommented and using helper
        subtitle: Text(
          _formatTaskDate(task.dueDate), 
          style: const TextStyle(color: Colors.grey, fontSize: 12),
        ),
        trailing: Transform.scale(
          scale: 0.9,
          child: Checkbox(
            activeColor: Colors.blue,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            value: isCompleted, // FIXED: Use boolean variable
            onChanged: (bool? value) {
              if (value != null) {
                // Trigger the Update Event
                context.read<DashboardBloc>().add(
                  ToggleTaskStatusEvent(
                    taskId: task.id, // This now works because Entity has 'id'
                  )
                );
              }
            },
          ),
        ),
        onTap: () {
          // Optional: Navigate to Task Details
        },
      );
    },
  );
}

// Helper to format DateTime nicely
String _formatTaskDate(DateTime? date) {
  if (date == null) return 'No due date';
  return DateFormat('E, MMM d • h:mm a').format(date);
}