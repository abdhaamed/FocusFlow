import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_typography.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/progress_bar.dart';

class GoalSummaryScreen extends StatelessWidget {
  const GoalSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                    color: AppColors.primary.withOpacity(0.08),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.track_changes, 
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
              
              // Main Card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: const BoxDecoration(
                      border: Border(
                        left: BorderSide(color: AppColors.primary, width: 4),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          // Subheader
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'PRIMARY OBJECTIVE',
                                style: AppTypography.labelMedium.copyWith(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 1.0,
                                  color: AppColors.neutral,
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withOpacity(0.08),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Initiating',
                                  style: AppTypography.labelMedium.copyWith(
                                    fontSize: 11,
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Q4 Enterprise Market\nExpansion',
                            style: AppTypography.headlineMedium.copyWith(
                              fontSize: 22,
                              color: AppColors.primary,
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Progress',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 13,
                                  color: AppColors.neutral,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '0%',
                                style: AppTypography.bodyMedium.copyWith(
                                  fontSize: 13,
                                  color: AppColors.neutral,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          // Progress Bar
                          const AppProgressBar(
                            value: 0.0,
                          ),
                          const SizedBox(height: 24),
                          const Divider(color: Color(0xFFE2E8F0)),
                          const SizedBox(height: 16),
                          
                          // SMART Items
                          _buildSmartItem(
                            icon: Icons.my_location,
                            title: 'Specific',
                            description: 'Penetrate Tier 1 Financial Sector\naccounts.',
                          ),
                          _buildSmartItem(
                            icon: Icons.bar_chart_rounded,
                            title: 'Measurable',
                            description: 'Secure 3 net-new Enterprise\ncontracts.',
                          ),
                          _buildSmartItem(
                            icon: Icons.check_circle_outline,
                            title: 'Achievable',
                            description: 'Utilize existing Q3 warmed pipeline\nleads.',
                          ),
                          _buildSmartItem(
                            icon: Icons.link,
                            title: 'Relevant',
                            description: 'Aligns directly with FY24 global scale\ninitiative.',
                          ),
                          _buildSmartItem(
                            icon: Icons.calendar_today_outlined,
                            title: 'Time-bound',
                            description: 'Target completion by December 31,\n2024.',
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              
              // Bottom Buttons
              AppButton(
                label: 'Let\'s Go',
                variant: AppButtonVariant.primary,
                trailingIcon: const Icon(Icons.arrow_forward, size: 18, color: Colors.white),
                onPressed: () {
                  context.push(AppRoutes.onboardingSpecific); // Move to specific goal step
                },
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Back',
                variant: AppButtonVariant.outlined,
                onPressed: () {
                  context.pop(); // Go back
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmartItem({required IconData icon, required String title, required String description}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.background.withOpacity(0.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.neutral),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelMedium.copyWith(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTypography.bodyMedium.copyWith(
                    fontSize: 13,
                    color: AppColors.neutral,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
