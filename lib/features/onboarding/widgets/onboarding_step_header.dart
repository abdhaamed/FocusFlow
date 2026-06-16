import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';

class OnboardingStepHeader extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;

  const OnboardingStepHeader({
    super.key,
    this.title = '',
    this.description = '',
    this.icon = Icons.info_outline,
    // Keep constructor parameters for compatibility if needed, but we'll use our new ones
    int stepNumber = 0,
    int totalSteps = 0,
    String badgeLabel = '',
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 24, color: AppColors.primary),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: AppTypography.headlineLarge.copyWith(
            fontSize: 24,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 12),
        Text(
          description,
          style: AppTypography.bodyMedium.copyWith(
            fontSize: 14,
            color: AppColors.neutral,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

