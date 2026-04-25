// ASSIGNED TO: Raja
// TODO(Raja): Implement Matrix Assessment Slider UI.

import 'package:flutter/material.dart';

class MatrixAssessmentSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;
  final String lowLabel;
  final String highLabel;

  const MatrixAssessmentSlider({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    required this.lowLabel,
    required this.highLabel,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('MatrixAssessmentSlider'),
    );
  }
}
