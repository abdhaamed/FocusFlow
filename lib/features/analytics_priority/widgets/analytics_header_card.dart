// ASSIGNED TO: Octaf
// TODO(Octaf): Implement Analytics Header Card UI.

import 'package:flutter/material.dart';

class AnalyticsHeaderCard extends StatelessWidget {
  final String goalTitle;
  final double completionPercent;

  const AnalyticsHeaderCard({
    super.key,
    required this.goalTitle,
    required this.completionPercent,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('AnalyticsHeaderCard'),
    );
  }
}
