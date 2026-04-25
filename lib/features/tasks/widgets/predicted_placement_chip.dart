// ASSIGNED TO: Raja
// TODO(Raja): Implement Predicted Placement Chip UI.

import 'package:flutter/material.dart';

class PredictedPlacementChip extends StatelessWidget {
  final String quadrant;
  final String description;

  const PredictedPlacementChip({
    super.key,
    required this.quadrant,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('PredictedPlacementChip'),
    );
  }
}
