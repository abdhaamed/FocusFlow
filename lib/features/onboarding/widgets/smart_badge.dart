// ASSIGNED TO: Louis
// TODO(Louis): Implement Smart Badge to indicate completion status of a SMART criteria.

import 'package:flutter/material.dart';

class SmartBadge extends StatelessWidget {
  final String label;
  final bool isCompleted;

  const SmartBadge({
    super.key,
    required this.label,
    required this.isCompleted,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
