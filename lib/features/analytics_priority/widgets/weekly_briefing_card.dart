// ASSIGNED TO: Octaf
// TODO(Octaf): Implement Weekly Briefing Card UI.

import 'package:flutter/material.dart';

class WeeklyBriefingCard extends StatelessWidget {
  final int deepWorkHours;
  final int completionPercent;
  final String insightText;

  const WeeklyBriefingCard({
    super.key,
    required this.deepWorkHours,
    required this.completionPercent,
    required this.insightText,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('WeeklyBriefingCard'),
    );
  }
}
