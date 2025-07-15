import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/config/route_constants.dart';
import 'package:task_management_app/cubits/task/task_state.dart';
import 'package:task_management_app/ui_components/TaskListTile.dart';

import '../../config/colors.dart';
import '../../config/input_styles.dart';
import '../../cubits/task/task_cubit.dart';
import '../../ui_components/input_field_label.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  TaskListScreenState createState() => TaskListScreenState();
}

class TaskListScreenState extends State<TaskListScreen> {
  final ScrollController _scrollController = ScrollController();
  late TaskCubit _taskCubit;
  String? status;
  String? priority;
  final TextEditingController cDueDate = TextEditingController();

  @override
  void initState() {
    super.initState();
    _taskCubit = context.read<TaskCubit>();
    _taskCubit.fetchInitialTasks();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          _taskCubit.state is! TaskLoadingState) {
        _taskCubit.fetchMoreTasks();
      }
    });
  }

  void showSearchModal() async {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) => SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Status',
              ),
              DropdownButtonFormField<String>(
                decoration: kInputSecondaryStyle,
                value: status,
                isExpanded: true,
                onChanged: (String? newValue) {
                  FocusScope.of(context).unfocus();
                  status = newValue;
                },
                items: ['Pending', 'In Progress', 'Done']
                    .map(
                      (c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      c,
                    ),
                  ),
                )
                    .toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              const Text(
                'Priority',
              ),
              DropdownButtonFormField<String>(
                decoration: kInputSecondaryStyle,
                value: priority,
                isExpanded: true,
                onChanged: (String? newValue) {
                  FocusScope.of(context).unfocus();
                  priority = newValue;
                },
                items: ['Low', 'Medium', 'High']
                    .map(
                      (c) => DropdownMenuItem(
                    value: c,
                    child: Text(
                      c,
                    ),
                  ),
                )
                    .toList(),
              ),
              const SizedBox(
                height: 10,
              ),
              InputFieldLabel(
                controller: cDueDate,
                label: 'Due Date',
                readonly: true,
                onTap: () async {
                  DateTime? selectedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  );

                  if (selectedDate != null) {
                    cDueDate.text =
                        DateFormat('dd-MM-yyyy').format(selectedDate.toLocal());
                  }
                },
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      cDueDate.clear();
                      status = null;
                      priority = null;
                      Navigator.pop(context);
                      _taskCubit.resetState();
                      _taskCubit.fetchInitialTasks();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kSecondaryColor,
                      foregroundColor: kWhiteColor,
                    ),
                    child: const Text('Reset'),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      _taskCubit.resetState();
                      _taskCubit.fetchInitialTasks(
                        status: status,
                        priority: priority,
                        dueDate: cDueDate.text,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      foregroundColor: kWhiteColor,
                    ),
                    child: const Text('Search'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Tasks'),
        actions: [
          IconButton(
            onPressed: showSearchModal,
            icon: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
          IconButton(
            onPressed: () => Navigator.pushNamed(
              context,
              taskCreateRoute,
            ).then(
                  (value) {
                _taskCubit.resetState();
                _taskCubit.fetchInitialTasks();
              },
            ),
            icon: const Icon(Icons.add, size: 30,),
          ),
        ],
      ),
      body: BlocBuilder<TaskCubit, TaskState>(
        builder: (context, state) {
          if (state is TaskLoadingState || state is TaskInitialState) {
            return Center(child: CircularProgressIndicator());
          } else if (state is TaskErrorState) {
            return Center(child: Text('Error: ${state.error}'));
          } else if (state is TaskLoadedState) {
            return ListView.builder(
              controller: _scrollController,
              itemCount: state.tasks.length + (state.hasReachedEnd ? 0 : 1),
              itemBuilder: (context, index) {
                if (index < state.tasks.length) {
                  final task = state.tasks[index];
                  return TaskListTile(
                    task: task,
                  );
                } else {
                  return Center(child: CircularProgressIndicator());
                }
              },
            );
          }

          return Container();
        },
      ),
    );
  }
}
