import 'package:task_management_app/models/user.dart';

class Comment {
  final int id;
  final int? taskId;
  final String message;
  final User? user;
  final DateTime? createdAt;

  Comment({
    this.id = 0,
    this.taskId,
    required this.message,
    this.user,
    this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'message': message,
    'task_id': taskId,
  };

  factory Comment.fromMap(Map<String, dynamic> json) => Comment(
    id: json["id"],
    message: json["message"],
    user: json['user'] != null ? User.fromMap(json["user"]) : null,
    createdAt: DateTime.parse(json["created_at"]).toLocal(),
  );
}
