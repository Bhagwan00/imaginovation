import '../../models/task.dart';

abstract class TaskState {}

class TaskInitialState extends TaskState {}

class TaskLoadingState extends TaskState {}

class TaskCreatedState extends TaskState {
  final String message;

  TaskCreatedState(this.message);
}

class TaskUpdatedState extends TaskState {
  final String message;

  TaskUpdatedState(this.message);
}

class TaskLoadedState extends TaskState {
  final List<Task> tasks;
  final String? nextCursor;
  final bool hasReachedEnd;

  TaskLoadedState({
    required this.tasks,
    required this.nextCursor,
    required this.hasReachedEnd,
  });
}

class TaskErrorState extends TaskState {
  final String error;

  TaskErrorState(this.error);
}
