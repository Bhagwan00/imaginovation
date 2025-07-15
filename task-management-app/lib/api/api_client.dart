import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config/api_constants.dart';

class ApiClient {
  static final Dio _dio = Dio();

  // Define a method to initialize Dio with headers
  static void init() {
    // Add other headers as needed
    _dio.options.baseUrl = apiUrl;
    _dio.options.headers['Accept'] = 'application/json';
    setupInterceptors();
    _dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        responseHeader: false,
        error: true,
        compact: true,
        maxWidth: 90,
      ),
    );
  }

  static void setupInterceptors() {
    _dio.interceptors.add(QueuedInterceptorsWrapper(
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          SharedPreferences localStorage =
          await SharedPreferences.getInstance();
          if (localStorage.get('token') != null) {
            await _dio.get(
              'user/logout',
              options: Options(
                headers: {
                  'Authorization': 'Bearer ${localStorage.get('token')}',
                },
              ),
            );
          }
          localStorage.remove('token');
          localStorage.remove('userId');
          _dio.options.headers['Authorization'] = null;
          // navigatorKey.currentState
          //     ?.pushNamedAndRemoveUntil(loginRoute, (route) => false);
        }
        return handler.next(error);
      },
    ));
  }

  static void setAuthToken(String? token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Singleton Dio instance
  static Dio get dio => _dio;
}
