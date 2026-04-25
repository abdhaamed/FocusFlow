// ASSIGNED TO: Hamid
// TODO(Hamid): Implement Current Goal Card UI.

import 'package:flutter/material.dart';

class CurrentGoalCard extends StatelessWidget {
  final String goalTitle;
  final double progressValue;
  final List<String> smartBadges;
  final String timeRemaining;

  const CurrentGoalCard({
    super.key,
    required this.goalTitle,
    required this.progressValue,
    required this.smartBadges,
    required this.timeRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('CurrentGoalCard'),
    );
  }
}
