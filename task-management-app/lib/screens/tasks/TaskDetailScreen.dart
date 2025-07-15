import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_management_app/repositories/comment_repository.dart';
import '../../models/task.dart';
import '../../models/comment.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({super.key, required this.task});

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {
  final _commentController = TextEditingController();
  bool _isCommenting = false;
  late List<Comment> _comments;

  @override
  void initState() {
    super.initState();
    _comments = List.from(widget.task.comments); // Initial comment list
  }

  void _addComment() async {
    if (_commentController.text.trim().isEmpty) return;

    setState(() => _isCommenting = true);

    try {
      final newComment = Comment(
        message: _commentController.text.trim(),
        taskId: widget.task.id
      );

      Response response = await CommentRepository().create(newComment);
      if(response.data['status']){
        final commentJson = response.data['comment'];
        setState(() {
          _comments.insert(0, Comment.fromMap(commentJson));
          _commentController.clear();
        });
      }

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to add comment'),
        backgroundColor: Colors.red,
      ));
    } finally {
      setState(() => _isCommenting = false);
    }
  }

  Widget _buildBadge(String label, Color color) => Chip(
    label: Text(label, style: const TextStyle(color: Colors.white)),
    backgroundColor: color,
  );

  Color _getStatusColor(String status) {
    switch (status) {
      case 'completed':
        return Colors.green;
      case 'in_progress':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.amber;
      default:
        return Colors.blue;
    }
  }

  @override
  Widget build(BuildContext context) {
    final task = widget.task;

    return Scaffold(
      appBar: AppBar(title: Text('Task Details')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Task Info
            Text(task.title,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 8),
            Text(task.description, style: TextStyle(color: Colors.grey[800])),
            const SizedBox(height: 12),
            Row(
              children: [
                _buildBadge(task.status.toUpperCase(), _getStatusColor(task.status)),
                const SizedBox(width: 8),
                _buildBadge(task.priority.toUpperCase(), _getPriorityColor(task.priority)),
                const Spacer(),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, size: 16),
                    const SizedBox(width: 4),
                    Text(DateFormat.yMMMd().format(task.dueDate)),
                  ],
                ),
              ],
            ),
            const Divider(height: 32),

            // Add Comment
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: const InputDecoration(
                      hintText: 'Add a comment...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _isCommenting
                    ? const CircularProgressIndicator()
                    : IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _addComment,
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Comments List
            Expanded(
              child: _comments.isEmpty
                  ? const Center(child: Text('No comments yet.'))
                  : ListView.builder(
                itemCount: _comments.length,
                itemBuilder: (context, index) {
                  final comment = _comments[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    child: ListTile(
                      title: Text(comment.message),
                      subtitle: Text(
                        DateFormat.yMMMd().add_jm().format(comment.createdAt!),
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
