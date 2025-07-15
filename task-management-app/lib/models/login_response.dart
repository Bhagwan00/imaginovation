import 'package:task_management_app/models/user.dart';

class LoginResponse {
  final bool status;
  final User user;
  final String token;
  final String? tokenType;
  final String? message;
  final String? error;

  LoginResponse({
    required this.status,
    required this.user,
    required this.token,
    this.tokenType,
    this.message,
    this.error,
  });

  factory LoginResponse.fromMap(Map<String, dynamic> json) => LoginResponse(
    status: json["status"],
    user: User.fromMap(json['user']),
    token: json['token'],
    tokenType: json['token_type'],
    message: json['message'],
    error: json['error'],
  );
}
