// ASSIGNED TO: Raja
// TODO(Raja): Implement Task Status Stepper UI.

import 'package:flutter/material.dart';

class TaskStatusStepper extends StatelessWidget {
  final String currentStatus;

  const TaskStatusStepper({
    super.key,
    required this.currentStatus,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('TaskStatusStepper'),
    );
  }
}
