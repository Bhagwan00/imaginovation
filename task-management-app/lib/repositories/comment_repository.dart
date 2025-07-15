import 'package:dio/dio.dart';
import 'package:task_management_app/models/comment.dart';

import '../api/api_client.dart';

class CommentRepository {

  Future<Response> create(Comment comment) async {
    try {
      FormData formData = FormData.fromMap(comment.toMap());
      Response response =
      await ApiClient.dio.post('user/comments/create', data: formData);
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
}
