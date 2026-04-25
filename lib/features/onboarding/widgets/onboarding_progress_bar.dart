// ASSIGNED TO: Louis
// TODO(Louis): Implement Onboarding Progress Bar to show user progress through steps.

import 'package:flutter/material.dart';

class OnboardingProgressBar extends StatelessWidget {
  final int currentStep;
  final int totalSteps;

  const OnboardingProgressBar({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  @override
  Widget build(BuildContext context) {
    return const SizedBox.shrink();
  }
}
