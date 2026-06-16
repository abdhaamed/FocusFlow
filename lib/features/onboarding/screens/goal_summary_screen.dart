import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/providers/goal_provider.dart';
import '../../../shared/widgets/app_button.dart';
import '../widgets/goal_summary_card.dart';

class GoalSummaryScreen extends StatelessWidget {
  const GoalSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goalProvider = context.watch<GoalProvider>();
    final timeboundStr = goalProvider.timebound != null 
        ? 'Goal completion by ${DateFormat('MMMM dd, yyyy').format(goalProvider.timebound!)}.' 
        : 'No deadline set.';

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Icon
              Center(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.auto_graph_rounded,
                    color: AppColors.primary,
                    size: 32,
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Header Titles
              Text(
                'Your Focus is Set.',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLarge.copyWith(
                  fontSize: 26,
                  color: AppColors.primary,
                  height: 1.2,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Strategic objective defined. Review your\nparameters below before initiating the tracking\ncycle.',
                textAlign: TextAlign.center,
                style: AppTypography.bodyMedium.copyWith(
                  fontSize: 14,
                  color: AppColors.neutral,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 32),
              
              // Main Card - Actual SMART Goal Data
              GoalSummaryCard(
                title: goalProvider.primaryObjective.isNotEmpty 
                    ? goalProvider.primaryObjective 
                    : 'Unspecified Objective',
                specific: goalProvider.specific,
                measurable: goalProvider.measurable,
                achievable: goalProvider.achievable,
                relevant: goalProvider.relevant,
                timebound: timeboundStr,
                progressValue: 0.0,
              ),
              const SizedBox(height: 32),
              
              // Bottom Buttons
              AppButton(
                label: 'Let\'s Go',
                variant: AppButtonVariant.primary,
                trailingIcon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                onPressed: () {
                  // Final navigation to home or next step
                  context.go(AppRoutes.home);
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Back',
                variant: AppButtonVariant.outlined,
                onPressed: () {
                  context.pop(); // Go back to Timebound
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
