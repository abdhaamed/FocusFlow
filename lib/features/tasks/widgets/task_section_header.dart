// ASSIGNED TO: Raja
// TODO(Raja): Implement Task Section Header UI.

import 'package:flutter/material.dart';

class TaskSectionHeader extends StatelessWidget {
  final String label;
  final int count;
  final Color color;

  const TaskSectionHeader({
    super.key,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('TaskSectionHeader'),
    );
  }
}
