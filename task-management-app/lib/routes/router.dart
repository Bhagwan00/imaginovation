import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_management_app/models/task.dart';
import 'package:task_management_app/screens/tasks/TaskDetailScreen.dart';

import '../config/route_constants.dart';
import '../cubits/task/task_cubit.dart';
import '../screens/auth/login_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/tasks/CreateTaskScreen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    return MaterialPageRoute(builder: (context) {
      switch (settings.name) {
        case splashRoute:
          return const SplashScreen();
        case loginRoute:
          return const LoginScreen();
        case taskCreateRoute:
          Task? task = settings.arguments as Task?;
          return BlocProvider(
            create: (context) =>TaskCubit(),
            child: CreateTaskScreen(
              task: task,
            ),
          );
        case taskDetailsRoute:
          Task task = settings.arguments as Task;
          return TaskDetailScreen(
            task: task,
          );
        default:
          return Scaffold(
            body: Center(child: Text('No route defined for ${settings.name}')),
          );
      }
    });
  }
}