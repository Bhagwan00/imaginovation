import 'package:dio/dio.dart';

import '../api/api_client.dart';
import '../models/paginated_tasks.dart';
import '../models/task.dart';

class TaskRepository {

  Future<PaginatedTasks> fetchTasksPagination(
      {String? cursor, required int limit, String? search, String? status, String? priority, String? dueDate}) async {
    try {
      String endpoint = 'user/tasks?cursor=$cursor&per_page=$limit';
      if(status != null){
        endpoint = "$endpoint&status=$status";
      }
      if(priority != null){
        endpoint = "$endpoint&priority=$priority";
      }
      if(dueDate != null){
        endpoint = "$endpoint&due_date=$dueDate";
      }
      Response response = await ApiClient.dio.get(endpoint);
      if (response.data['status'] && response.data['data'] != null) {
        final data = response.data['data'];
        final tasks = List<Task>.from(data['data'].map((c) => Task.fromMap(c)));

        return PaginatedTasks(
          tasks: tasks,
          nextCursor: data['next_cursor'],
        );
      } else {
        throw response.data['message'];
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError) {
        throw "Please check your internet connection";
      }
      throw error.message.toString();
    }
  }

  Future<Response> create(Task client) async {
    try {
      FormData formData = FormData.fromMap(client.toMap());
      Response response =
          await ApiClient.dio.post('user/tasks/create', data: formData);
      if (response.data['status']) {
        return response;
      } else {
        throw response.data['message'];
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError) {
        throw "Please check your internet connection";
      }
      if (error.response!.statusCode == 404) {
        throw error.response!.data['message'];
      }
      throw error.message.toString();
    }
  }

  Future<Response> update(Task task) async {
    try {
      FormData formData = FormData.fromMap(task.toMap());
      Response response = await ApiClient.dio.post(
        'tasks/update/${task.id}',
        data: formData,
      );
      if (response.data['status']) {
        return response;
      } else {
        throw response.data['message'];
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError) {
        throw "Please check your internet connection";
      }
      if (error.response!.statusCode != 200) {
        throw error.response!.data;
      }
      throw error.message.toString();
    }
  }
}
