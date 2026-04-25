// ASSIGNED TO: Octaf
// TODO(Octaf): Implement Activity Heatmap UI.

import 'package:flutter/material.dart';

class ActivityHeatmap extends StatelessWidget {
  final Map<DateTime, int> activityData;

  const ActivityHeatmap({
    super.key,
    required this.activityData,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('ActivityHeatmap'),
    );
  }
}
