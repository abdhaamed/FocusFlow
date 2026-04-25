// ASSIGNED TO: Octaf
// TODO(Octaf): Implement Eisenhower Quadrant Card UI.

import 'package:flutter/material.dart';
import '../../../shared/models/task_item.dart';

class EisenhowerQuadrantCard extends StatelessWidget {
  final String quadrantLabel;
  final String urgencyLabel;
  final String importanceLabel;
  final List<TaskItem> tasks;
  final Color color;

  const EisenhowerQuadrantCard({
    super.key,
    required this.quadrantLabel,
    required this.urgencyLabel,
    required this.importanceLabel,
    required this.tasks,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('EisenhowerQuadrantCard'),
    );
  }
}
