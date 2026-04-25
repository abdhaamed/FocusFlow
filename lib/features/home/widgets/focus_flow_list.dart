// ASSIGNED TO: Hamid
// TODO(Hamid): Implement Focus Flow List UI.

import 'package:flutter/material.dart';
import '../../../shared/models/task_item.dart';

class FocusFlowList extends StatelessWidget {
  final List<TaskItem> tasks;

  const FocusFlowList({
    super.key,
    required this.tasks,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('FocusFlowList'),
    );
  }
}
