// ASSIGNED TO: Louis
// TODO(Louis): Implement Onboarding Step Header with step number and badge.

import 'package:flutter/material.dart';

class OnboardingStepHeader extends StatelessWidget {
  final int stepNumber;
  final int totalSteps;
  final String badgeLabel;

  const OnboardingStepHeader({
    super.key,
    required this.stepNumber,
    required this.totalSteps,
    required this.badgeLabel,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
