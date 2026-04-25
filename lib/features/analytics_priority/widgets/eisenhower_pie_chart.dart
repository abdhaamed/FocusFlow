// ASSIGNED TO: Octaf
// TODO(Octaf): Implement Eisenhower Pie Chart UI.

import 'package:flutter/material.dart';

class EisenhowerPieChart extends StatelessWidget {
  final double q1;
  final double q2;
  final double q3;
  final double q4;

  const EisenhowerPieChart({
    super.key,
    required this.q1,
    required this.q2,
    required this.q3,
    required this.q4,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('EisenhowerPieChart'),
    );
  }
}
