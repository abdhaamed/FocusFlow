// ASSIGNED TO: Louis
// TODO(Louis): Implement Goal Summary Card to display the final SMART goal details.

import 'package:flutter/material.dart';
import 'package:focusflow/shared/models/smart_item.dart';

class GoalSummaryCard extends StatelessWidget {
  final String title;
  final List<SmartItem> smartItems;

  const GoalSummaryCard({
    super.key,
    required this.title,
    required this.smartItems,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
