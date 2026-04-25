// ASSIGNED TO: Raja
// TODO(Raja): Implement Task Card UI.

import 'package:flutter/material.dart';

class TaskCard extends StatelessWidget {
  final String title;
  final List<String> tags;
  final String? dueDate;
  final String? quadrant;
  final bool isCompleted;

  const TaskCard({
    super.key,
    required this.title,
    required this.tags,
    this.dueDate,
    this.quadrant,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('TaskCard'),
    );
  }
}
