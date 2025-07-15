import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/cubits/task/task_state.dart';

import '../../models/task.dart';
import '../../repositories/task_repository.dart';

class TaskCubit extends Cubit<TaskState> {
  final TaskRepository repository = TaskRepository();
  List<Task> _tasks = [];
  String? _nextCursor;
  bool _hasReachedEnd = false;
  bool _isLoading = false;

  TaskCubit() : super(TaskInitialState());

  void resetState() {
    emit(TaskInitialState());
  }

  Future<void> fetchInitialTasks({
    int limit = 5,
    String? status,
    String? priority,
    String? dueDate,
  }) async {
    _tasks.clear();
    _nextCursor = null;
    _hasReachedEnd = false;
    emit(TaskLoadingState());

    try {
      final result = await repository.fetchTasksPagination(
        limit: limit,
        status: status,
        priority: priority,
        dueDate: dueDate,
      );
      _tasks = result.tasks;
      _nextCursor = result.nextCursor;
      _hasReachedEnd = result.nextCursor == null;

      emit(
        TaskLoadedState(
          tasks: _tasks,
          nextCursor: _nextCursor,
          hasReachedEnd: _hasReachedEnd,
        ),
      );
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }
  }

  Future<void> fetchMoreTasks({int limit = 5,String? status,
    String? priority,
    String? dueDate,}) async {
    if (_isLoading || _hasReachedEnd) return;

    _isLoading = true;

    try {
      final result = await repository.fetchTasksPagination(
        limit: limit,
        cursor: _nextCursor,
        status: status,
        priority: priority,
        dueDate: dueDate,
      );

      _tasks.addAll(result.tasks);
      _nextCursor = result.nextCursor;
      _hasReachedEnd = result.nextCursor == null;

      emit(
        TaskLoadedState(
          tasks: _tasks,
          nextCursor: _nextCursor,
          hasReachedEnd: _hasReachedEnd,
        ),
      );
    } catch (e) {
      emit(TaskErrorState(e.toString()));
    }

    _isLoading = false;
  }

  Future<void> createTask(Task client) async {
    try {
      emit(TaskLoadingState());
      Response response = await repository.create(client);
      if (response.data['status']) {
        emit(TaskCreatedState(response.data['message']));
      } else {
        emit(TaskErrorState(response.data['message']));
      }
    } catch (error) {
      emit(TaskErrorState(error.toString()));
    }
  }

  //
  // Future<void> editTask(Task client) async {
  //   try {
  //     emit(TaskLoadingState());
  //     Response response = await clientRepository.update(client);
  //     if (response.data['status']) {
  //       emit(TaskUpdatedState(response.data['message']));
  //     } else {
  //       emit(TaskErrorState(response.data['message']));
  //     }
  //   } catch (error) {
  //     emit(TaskErrorState(error.toString()));
  //   }
  // }
}
