// ASSIGNED TO: Octaf
// TODO(Octaf): Implement Quadrant Task Item UI.

import 'package:flutter/material.dart';

class QuadrantTaskItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool isCompleted;

  const QuadrantTaskItem({
    super.key,
    required this.title,
    this.subtitle,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('QuadrantTaskItem'),
    );
  }
}
