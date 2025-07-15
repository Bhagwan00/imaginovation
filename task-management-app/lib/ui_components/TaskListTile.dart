import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/config/route_constants.dart';
import '../../models/task.dart';

class TaskListTile extends StatelessWidget {
  final Task task;

  const TaskListTile({super.key, required this.task});

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Done':
        return Colors.green;
      case 'In Progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.amber;
      case 'Low':
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        title: Row(
          children: [
            Text(
              '#${task.id}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                task.title,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                task.description,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.grey.shade700),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Chip(
                    label: Text(
                      task.status.replaceAll('_', ' ').toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: _getStatusColor(task.status),
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    label: Text(
                      task.priority.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                    backgroundColor: _getPriorityColor(task.priority),
                  ),
                  const Spacer(),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today, size: 16),
                      const SizedBox(width: 4),
                      Text(
                        DateFormat.yMMMd().format(task.dueDate),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        ),
        onTap: () {
          Navigator.pushNamed(context, taskDetailsRoute, arguments: task);
        },
      ),
    );
  }
}
