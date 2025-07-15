import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:loader_overlay/loader_overlay.dart';

import '../../config/colors.dart';
import '../../config/paddings.dart';
import '../../cubits/task/task_cubit.dart';
import '../../cubits/task/task_state.dart';
import '../../models/task.dart';
import '../../ui_components/input_field_label.dart';

class CreateTaskScreen extends StatefulWidget {
  final Task? task;

  const CreateTaskScreen({super.key, this.task});

  @override
  State<CreateTaskScreen> createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen> {
  TextEditingController cTitle = TextEditingController();
  TextEditingController cDescription = TextEditingController();
  String status = "Pending";
  String priority = "Low";
  DateTime? _dueDate;
  final _form = GlobalKey<FormState>();

  late TaskCubit taskCubit;

  @override
  void initState() {
    super.initState();

    taskCubit = context.read<TaskCubit>();
    if (widget.task != null) {
      cTitle.text = widget.task?.title ?? '';
      cDescription.text = widget.task?.description ?? '';
      status = widget.task?.status ?? '';
      priority = widget.task?.priority ?? '';
      _dueDate = widget.task?.dueDate;
    }
  }

  void submitForm() async {
    bool isValid = _form.currentState!.validate();
    if (isValid) {
      FocusScope.of(context).unfocus();
      _form.currentState!.save();
      Task task = Task(
        id: widget.task?.id ?? 0,
        title: cTitle.text,
        description: cDescription.text,
        status: status,
        priority: priority,
        dueDate: _dueDate!, comments: [],
      );
      context.loaderOverlay.show();
      if (widget.task == null) {
        taskCubit.createTask(task);
      } else {
        // taskCubit.editTask(task);
      }
    }
  }

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: DateTime(now.year + 5),
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          widget.task == null ? "Create new task" : "Edit task",
        ),
        centerTitle: true,
      ),
      body: LoaderOverlay(
        child: SingleChildScrollView(
          child: Container(
            padding: kPadding,
            child: Form(
              key: _form,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    InputFieldLabel(
                      controller: cTitle,
                      label: 'Title *',
                      validator: (value) {
                        if (cTitle.text.trim().isEmpty) {
                          return 'Please enter title';
                        }
                        return null;
                      },
                    ),
                    InputFieldLabel(
                      controller: cDescription,
                      label: 'Description *',
                      lines: 3,
                      validator: (value) {
                        if (cDescription.text.trim().isEmpty) {
                          return 'Please enter description';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(height: 10),
                    ListTile(
                      title: Text(_dueDate == null
                          ? 'Select Due Date'
                          : 'Due Date: ${DateFormat.yMMMd().format(_dueDate!)}'),
                      trailing: Icon(Icons.calendar_today),
                      onTap: _pickDueDate,
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: priority,
                      decoration: InputDecoration(labelText: 'Priority'),
                      items: ['Low', 'Medium', 'High']
                          .map((p) => DropdownMenuItem(
                        value: p,
                        child: Text(p),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() => priority = value!),
                    ),
                    SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: status,
                      decoration: InputDecoration(labelText: 'Status'),
                      items: ['Pending', 'In Progress', 'Done']
                          .map((s) => DropdownMenuItem(
                        value: s,
                        child: Text(s),
                      ))
                          .toList(),
                      onChanged: (value) => setState(() => status = value!),
                    ),
                    SizedBox(height: 10),
                    BlocConsumer<TaskCubit, TaskState>(
                      listener: (context, state) {
                        if (state is TaskCreatedState) {
                          context.loaderOverlay.hide();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: kSuccessColor,
                            ),
                          );
                          Navigator.pop(context);
                        }
                        if (state is TaskUpdatedState) {
                          context.loaderOverlay.hide();
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(state.message),
                              backgroundColor: kSuccessColor,
                            ),
                          );
                          Navigator.pop(context);
                        }
                        if (state is TaskErrorState) {
                          context.loaderOverlay.hide();
                        }
                      },
                      builder: (context, state) {
                        return Column(
                          children: [
                            if (state is TaskErrorState) ...[
                              Text(
                                state.error,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: kErrorColor,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              )
                            ],
                            SizedBox(
                              width: double.infinity,
                              height: 45,
                              child: ElevatedButton(
                                onPressed: submitForm,
                                style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  backgroundColor: kPrimaryColor,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.task == null ? 'Create Task' : 'Update Task',
                                      style: const TextStyle(
                                          fontSize: 20.0,
                                          color: kWhiteColor,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
