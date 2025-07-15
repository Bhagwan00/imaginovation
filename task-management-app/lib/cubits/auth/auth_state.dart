
import 'package:task_management_app/models/user.dart';

abstract class AuthState {}

class AuthInitialState extends AuthState {}

class AuthLoadingState extends AuthState {}

class AuthLoggedInState extends AuthState {
  final User user;

  AuthLoggedInState(this.user);
}

class AuthSignupState extends AuthState {
  final String message;

  AuthSignupState(this.message);
}

class AuthLoggedOutState extends AuthState {}

class AuthErrorState extends AuthState {
  final String error;

  AuthErrorState(this.error);
}
