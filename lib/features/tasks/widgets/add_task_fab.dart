// ASSIGNED TO: Raja
// TODO(Raja): Implement Add Task FAB UI.

import 'package:flutter/material.dart';

class AddTaskFab extends StatelessWidget {
  final VoidCallback onPressed;

  const AddTaskFab({
    super.key,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('AddTaskFab'),
    );
  }
}
