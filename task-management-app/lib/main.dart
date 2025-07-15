import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/api/api_client.dart';
import 'package:task_management_app/cubits/task/task_cubit.dart';
import 'package:task_management_app/routes/router.dart';
import 'package:task_management_app/screens/auth/login_screen.dart';
import 'package:task_management_app/screens/splash_screen.dart';
import 'package:task_management_app/screens/tasks/TasksScreen.dart';

import 'config/app_constants.dart';
import 'cubits/auth/auth_cubit.dart';
import 'cubits/auth/auth_state.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  ApiClient.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (BuildContext context) => AuthCubit(),
      child: MaterialApp(
        title: appName,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        onGenerateRoute: AppRouter.generateRoute,
        home: BlocBuilder<AuthCubit, AuthState>(
          buildWhen: (oldState, newState) {
            return oldState is AuthInitialState;
          },
          builder: (context, state) {
            if (state is AuthLoggedInState) {
              return BlocProvider<TaskCubit>(
                create: (BuildContext context) => TaskCubit(),
                child: TaskListScreen(),
              );
            } else if (state is AuthLoggedOutState) {
              return const LoginScreen();
            } else {
              return const SplashScreen();
            }
          },
        ),
      ),
    );
  }
}
