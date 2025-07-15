import 'package:task_management_app/models/task.dart';

class PaginatedTasks {
  final List<Task> tasks;
  final String? nextCursor;

  PaginatedTasks({required this.tasks, this.nextCursor});
}