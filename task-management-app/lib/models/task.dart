import 'package:task_management_app/models/comment.dart';
import 'package:task_management_app/models/user.dart';

class Task {
  final int id;
  final String title;
  final String description;
  final DateTime dueDate;
  final User? assignedToUser;
  final String status;
  final String priority;
  final DateTime? createdAt;
  final List<Comment> comments;

  Task({
    this.id = 0,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.status,
    required this.priority,
    this.assignedToUser,
    this.createdAt,
    required this.comments
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'title': title,
    'description': description,
    'due_date': dueDate.toIso8601String(),
    'assigned_to': assignedToUser?.id.toString(),
    'status': status,
    'priority': priority,
  };

  factory Task.fromMap(Map<String, dynamic> json) => Task(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    status: json["status"],
    priority: json["priority"],
    assignedToUser: json['assigned_user'] != null ? User.fromMap(json["assigned_user"]) : null,
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
    dueDate: DateTime.parse(json["due_date"]).toLocal(),
    comments: (json['comments'] as List)
        .map((c) => Comment.fromMap(c))
        .toList(),
  );
}
