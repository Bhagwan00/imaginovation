import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:task_management_app/models/login_response.dart';
import 'package:task_management_app/models/logout_response.dart';

import '../api/api_client.dart';
import '../models/user.dart';

class AuthRepository {
  Future<LoginResponse> login(String email, String password) async {
    try {
      Response response = await ApiClient.dio.post(
        'user/login',
        data: {'email': email, 'password': password},
      );
      LoginResponse loginResponse = LoginResponse.fromMap(response.data);
      if (loginResponse.status) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.setString('token', loginResponse.token);
        if(loginResponse.tokenType != null) {
          localStorage.setString('tokenType', loginResponse.tokenType!);
        }
        ApiClient.setAuthToken(loginResponse.token);
      }
      return loginResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError) {
        throw "Please check your internet connection";
      }
      if ([401, 500].contains(error.response!.statusCode)) {
        throw error.response!.data['message'];
      }
      throw error.message.toString();
    }
  }

  Future<LogoutResponse> logout() async {
    try {
      Response response = await ApiClient.dio.get(
        'logout',
      );

      LogoutResponse logoutResponse = LogoutResponse.fromMap(response.data);
      if (logoutResponse.status) {
        SharedPreferences localStorage = await SharedPreferences.getInstance();
        localStorage.remove('token');
        localStorage.remove('tokenType');
        ApiClient.dio.options.headers['Authorization'] = null;
      }
      return logoutResponse;
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError) {
        throw "Please check your internet connection";
      }
      throw error.message.toString();
    }
  }

  Future<User?> checkAlreadyLoggedIn() async {
    try {
      SharedPreferences localStorage = await SharedPreferences.getInstance();
      String? token = localStorage.getString('token');
      if (token != null) {
        ApiClient.setAuthToken(token);
        Response response = await ApiClient.dio.get('user');
        if (response.data['status']) {
          return User.fromMap(response.data['user']);
        } else {
          throw response.data['message'];
        }
      } else {
        ApiClient.dio.options.headers['Authorization'] = null;
        return null;
      }
    } on DioException catch (error) {
      if (error.type == DioExceptionType.connectionError) {
        throw "Please check your internet connection";
      }
      throw error.message.toString();
    }
  }
}
