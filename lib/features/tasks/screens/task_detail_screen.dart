// ASSIGNED TO: Raja
// TODO(Raja): Implement Task Detail Screen UI.

import 'package:flutter/material.dart';

class TaskDetailScreen extends StatelessWidget {
  final String taskId;

  const TaskDetailScreen({
    super.key,
    required this.taskId,
  });

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('TaskDetailScreen'),
      ),
    );
  }
}
