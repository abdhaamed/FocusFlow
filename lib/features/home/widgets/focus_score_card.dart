// ASSIGNED TO: Hamid
// TODO(Hamid): Implement Focus Score Card UI.

import 'package:flutter/material.dart';

class FocusScoreCard extends StatelessWidget {
  final int score;

  const FocusScoreCard({
    super.key,
    required this.score,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('FocusScoreCard'),
    );
  }
}
