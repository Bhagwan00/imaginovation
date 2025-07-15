import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/repositories/auth_repository.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository = AuthRepository();

  AuthCubit() : super(AuthInitialState()) {
    checkAlreadyLoggedIn();
  }

  void resetState() {
    emit(AuthInitialState());
  }

  Future<void> login(String email, String password) async {
    try {
      emit(AuthLoadingState());
      authRepository.login(email, password).then((response) async {
        if (response.status) {
          emit(AuthLoggedInState(response.user));
        } else {
          emit(AuthErrorState(response.message!));
        }
      }).catchError((error) {
        emit(AuthErrorState(error.toString()));
      });
    } catch (error) {
      emit(AuthErrorState(error.toString()));
    }
  }

  Future<void> logout() async {
    try {
      emit(AuthLoadingState());
      authRepository.logout().then((response) async {
        if (response.status) {
          emit(AuthLoggedOutState());
        } else {
          emit(AuthErrorState(response.message));
        }
      });
    } catch (error) {
      emit(AuthErrorState(error.toString()));
    }
  }

  void checkAlreadyLoggedIn() async {
    final response =
        await authRepository.checkAlreadyLoggedIn().catchError((e) => null);
    if (response != null) {
      emit(AuthLoggedInState(response));
    } else {
      emit(AuthLoggedOutState());
    }
  }
}
